import 'package:meta/meta.dart';

import 'package:dio/dio.dart' show FormData, MultipartFile;

import '../../client/misskey_cancellation_token.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/drive/batch_uploader.dart';
import '../../internal/drive/bulk_mover.dart' as bulk_mover;
import '../../internal/drive/dedup_uploader.dart';
import '../../internal/id_paginator.dart';
import '../../internal/optional.dart';
import '../../internal/request_body.dart';
import '../../models/batch/misskey_batch_result.dart';
import '../../models/chat/misskey_chat_message.dart';
import '../../models/drive/drive_move_bulk_result.dart';
import '../../models/drive/drive_upload_batch.dart';
import '../../models/drive/drive_upload_result.dart';
import '../../models/misskey_drive_file.dart';
import '../../models/misskey_note.dart';

/// Provides Drive file operations (`/api/drive/files/*`).
///
/// Delegates `/api/drive/files` endpoint calls to [MisskeyHttp].
/// Authentication is handled by [MisskeyHttp]'s interceptor.
class DriveFilesApi {
  /// Creates a [DriveFilesApi] instance.
  const DriveFilesApi({required this.http});

  /// The HTTP client used for requests.
  @internal
  final MisskeyHttp http;

  /// Lazily retrieves all files in newest-first ID order.
  ///
  /// Only ID order is supported: the server applies `untilId` as an ID filter
  /// even when sorting by name or size, causing pages to skip or repeat items.
  /// Collect the results and sort locally for other orders. This is not a
  /// snapshot; changes on the server during pagination may affect results.
  ///
  /// [folderId] selects the parent folder; omit it for root-level items.
  /// [type] accepts only letters, `/`, `-`, and `*` (for example, `image/*`).
  /// The server rejects values containing digits such as `video/mp4`.
  /// [pageSize] must be 1-100 and [maxItems] must be non-negative, or an
  /// [ArgumentError] is thrown synchronously. A zero [maxItems] sends no request.
  ///
  /// Each call returns a cold, single-subscription stream: requests start only
  /// when listened to. API errors are delivered as stream errors after any
  /// already-yielded items.
  Stream<MisskeyDriveFile> listAll({
    String? folderId,
    String? type,
    int pageSize = 100,
    int? maxItems,
  }) {
    validatePageArgs(pageSize, maxItems);
    return paginateById(
      fetchPage: (limit, untilId) =>
          list(limit: limit, untilId: untilId, folderId: folderId, type: type),
      idOf: (item) => item.id,
      pageSize: pageSize,
      maxItems: maxItems,
    );
  }

  /// Retrieves a list of Drive files (`/api/drive/files`).
  ///
  /// [limit] caps the number of results (1-100). Use [sinceId] and [untilId]
  /// to paginate by ID, or [sinceDate] and [untilDate] to paginate by Unix
  /// timestamp in milliseconds. Pass [folderId] to filter by folder (`null`
  /// for root) and [type] to filter by MIME type pattern (e.g., `"image/*"`).
  /// [sort] controls the sort order and accepts `+createdAt`, `-createdAt`,
  /// `+name`, `-name`, `+size`, or `-size`; `+` means descending.
  /// Only `+createdAt` (or null) is consistent with [untilId] pagination,
  /// and `-createdAt` (or null) with [sinceId] alone. Other sorts override the
  /// pagination order while the cursors still filter by ID, causing skipped
  /// or repeated items.
  Future<List<MisskeyDriveFile>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? folderId,
    String? type,
    String? sort,
  }) async {
    final body = <String, dynamic>{
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
      'folderId': ?folderId,
      'type': ?type,
      'sort': ?sort,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/files',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFile.fromJson)
        .toList();
  }

  /// Retrieves Drive file details by file ID
  /// (`/api/drive/files/show`).
  Future<MisskeyDriveFile> showByFileId(String fileId) async {
    final res = await http.send<Map<String, dynamic>>(
      '/drive/files/show',
      body: <String, dynamic>{'fileId': fileId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyDriveFile.fromJson(res);
  }

  /// Retrieves Drive file details by URL
  /// (`/api/drive/files/show`).
  Future<MisskeyDriveFile> showByUrl(String url) async {
    final res = await http.send<Map<String, dynamic>>(
      '/drive/files/show',
      body: <String, dynamic>{'url': url},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyDriveFile.fromJson(res);
  }

  /// Uploads a file to Drive (`/api/drive/files/create`).
  ///
  /// The file content is specified via [bytes] and [filename]. The auth token
  /// is injected into the `FormData` by [MisskeyHttp]'s interceptor.
  ///
  /// [name] sets the name to store on the server and defaults to [filename].
  /// [folderId] specifies the destination folder. [comment] is an optional
  /// comment (subject to `DB_MAX_IMAGE_COMMENT_LENGTH`). Set [isSensitive] to
  /// mark the file as sensitive content. Set [force] to store a new file even
  /// if a file with the same content (MD5) already exists; otherwise the
  /// server returns the existing file. [onSendProgress] is an optional
  /// callback for upload progress.
  Future<MisskeyDriveFile> create({
    required List<int> bytes,
    required String filename,
    String? name,
    String? folderId,
    String? comment,
    bool? isSensitive,
    bool? force,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final form = FormData();
    form.files.add(
      MapEntry('file', MultipartFile.fromBytes(bytes, filename: filename)),
    );
    if (name != null) form.fields.add(MapEntry('name', name));
    if (folderId != null) form.fields.add(MapEntry('folderId', folderId));
    if (comment != null) form.fields.add(MapEntry('comment', comment));
    if (isSensitive != null) {
      form.fields.add(MapEntry('isSensitive', isSensitive.toString()));
    }
    if (force != null) {
      form.fields.add(MapEntry('force', force.toString()));
    }

    final res = await http.send<Map<String, dynamic>>(
      '/drive/files/create',
      body: form,
      onSendProgress: onSendProgress,
    );
    return MisskeyDriveFile.fromJson(res);
  }

  /// Uploads a Drive file while avoiding a transfer when its content exists.
  ///
  /// This checks for an existing file by MD5 before uploading. Without this
  /// check, the server receives the complete upload before returning an
  /// existing file, and ignores the requested [folderId], [name], and
  /// [comment]. Supply [md5] to avoid hashing large inputs; it must be a
  /// 32-character hexadecimal MD5 value. Except with
  /// [DriveDuplicatePolicy.uploadAnyway], hashing is synchronous on the
  /// caller's isolate when [md5] is not supplied.
  ///
  /// A concurrent upload can win after the hash lookup. Detection is
  /// best-effort: a create response that differs in folder or requested comment
  /// is treated as a reused file and handled according to [onDuplicate].
  ///
  /// [onDuplicate] controls whether to reuse, move, or always upload matching
  /// content. Existing files retain their name and comment. If [isSensitive] is
  /// `true`, an existing non-sensitive file is upgraded to sensitive. With
  /// [DriveDuplicatePolicy.reuseExisting], a match means a nonexistent or
  /// foreign [folderId] is not validated, whereas a plain upload would fail.
  /// With [DriveDuplicatePolicy.moveExisting], a match already in [folderId]
  /// is reused rather than reported as moved.
  Future<DriveUploadResult> createDeduplicated({
    required List<int> bytes,
    required String filename,
    String? name,
    String? folderId,
    String? comment,
    bool? isSensitive,
    String? md5,
    DriveDuplicatePolicy onDuplicate = DriveDuplicatePolicy.reuseExisting,
    void Function(int sent, int total)? onSendProgress,
  }) => createDeduplicatedDriveFile(
    files: this,
    bytes: bytes,
    filename: filename,
    name: name,
    folderId: folderId,
    comment: comment,
    isSensitive: isSensitive,
    md5: md5,
    onDuplicate: onDuplicate,
    onSendProgress: onSendProgress,
  );

  /// Uploads multiple files with bounded concurrency.
  ///
  /// The returned per-item outcomes preserve [inputs] order. A server rate
  /// limit stops new uploads and marks remaining inputs as `rateLimited`; Drive
  /// files/create permits 120 uploads per user per hour by default, subject to
  /// role rate-limit factors. In-flight uploads finish. Set [stopOnError] to
  /// stop after any error. Cancellation is cooperative: it prevents new work
  /// but does not abort in-flight requests.
  ///
  /// When [deduplicate] is set, identical inputs form an ordered chain. A
  /// follower occupies a worker while waiting for its predecessor, then uses
  /// that latest result according to the duplicate policy. With `moveExisting`,
  /// the file ends in the last member's folder; earlier results describe the
  /// state at their own step. A follower's filename, name, and comment are
  /// ignored, while `isSensitive` can only upgrade the file to `true`. With
  /// `uploadAnyway`, every input uploads independently.
  ///
  /// A follower already running when its predecessor fails or is skipped is
  /// skipped as `dependencyFailed`. An unstarted follower keeps the batch stop
  /// reason, such as `cancelled`, `rateLimited`, or `stoppedAfterError`.
  ///
  /// This method never retries automatically. A network failure after the
  /// server stored a file is reported as a failure; rerunning is safe with
  /// server deduplication. With no [deduplicate] policy, the server can still
  /// return an existing file because `force` defaults to false, although the
  /// reported outcome is `uploaded`. All input bytes remain held by the caller
  /// for the duration of the operation.
  Future<MisskeyBatchResult<DriveUploadInput, DriveUploadResult>> createMany(
    List<DriveUploadInput> inputs, {
    int concurrency = 2,
    DriveDuplicatePolicy? deduplicate,
    bool stopOnError = false,
    void Function(DriveBatchUploadProgress progress)? onProgress,
    MisskeyCancellationToken? cancellation,
  }) => createManyDriveFiles(
    files: this,
    inputs: inputs,
    concurrency: concurrency,
    deduplicate: deduplicate,
    stopOnError: stopOnError,
    onProgress: onProgress,
    cancellation: cancellation,
  );

  /// Updates the metadata of a Drive file (`/api/drive/files/update`).
  ///
  /// [fileId] identifies the file to update. [name] sets a new file name.
  /// [folderId] moves the file to the specified folder. Set [moveToRoot] to
  /// `true` to move the file to the root folder (sends `folderId: null`
  /// explicitly). [comment] is an optional comment (up to 512 characters).
  /// Set [isSensitive] to mark the file as sensitive content.
  ///
  /// For [comment], use the [Optional] type: pass `Optional('value')` to set
  /// and `Optional.null_()` to clear.
  Future<MisskeyDriveFile> update({
    required String fileId,
    String? name,
    String? folderId,
    bool moveToRoot = false,
    Optional<String>? comment,
    bool? isSensitive,
  }) async {
    final body = <String, dynamic>{
      'fileId': fileId,
      'name': ?name,
      if (moveToRoot) 'folderId': null else 'folderId': ?folderId,
      'isSensitive': ?isSensitive,
    };
    putOptional(body, 'comment', comment);
    final res = await http.send<Map<String, dynamic>>(
      '/drive/files/update',
      body: body,
    );
    return MisskeyDriveFile.fromJson(res);
  }

  /// Deletes a Drive file (`/api/drive/files/delete`).
  ///
  /// [fileId] is the ID of the file to delete.
  Future<void> delete({required String fileId}) => http.send<Object?>(
    '/drive/files/delete',
    body: <String, dynamic>{'fileId': fileId},
  );

  /// Searches the Drive by file name (`/api/drive/files/find`).
  ///
  /// [name] is the file name to search for. Pass [folderId] to restrict the
  /// search to a specific folder (`null` searches the root).
  Future<List<MisskeyDriveFile>> find({
    required String name,
    String? folderId,
  }) async {
    final body = <String, dynamic>{'name': name, 'folderId': ?folderId};
    final res = await http.send<List<dynamic>>(
      '/drive/files/find',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFile.fromJson)
        .toList();
  }

  /// Checks whether a file with the specified MD5 hash exists in the Drive
  /// (`/api/drive/files/check-existence`).
  ///
  /// [md5] is the MD5 hash to check.
  Future<bool> checkExistence({required String md5}) => http.send<bool>(
    '/drive/files/check-existence',
    body: <String, dynamic>{'md5': md5},
    options: const RequestOptions(idempotent: true),
  );

  /// Uploads a file to Drive from a URL
  /// (`/api/drive/files/upload-from-url`).
  ///
  /// This endpoint initiates an asynchronous upload after the request
  /// completes, and notifies the result via a stream event
  /// (`urlUploadFinished`).
  ///
  /// [url] is the source URL to download from. [folderId] specifies the
  /// destination folder. Set [isSensitive] to mark the file as sensitive
  /// content. [comment] is an optional comment (up to 512 characters).
  /// [marker] is an optional tracking string that is included in the stream
  /// event. Set [force] to store a new file even if a file with the same
  /// content (MD5) already exists; otherwise the server returns the existing
  /// file.
  Future<void> uploadFromUrl({
    required String url,
    String? folderId,
    bool? isSensitive,
    String? comment,
    String? marker,
    bool? force,
  }) => http.send<Object?>(
    '/drive/files/upload-from-url',
    body: <String, dynamic>{
      'url': url,
      'folderId': ?folderId,
      'isSensitive': ?isSensitive,
      'comment': ?comment,
      'marker': ?marker,
      'force': ?force,
    },
  );

  /// Searches Drive files by MD5 hash
  /// (`/api/drive/files/find-by-hash`).
  ///
  /// Unlike [checkExistence], this returns a list of file details.
  /// Only files owned by the authenticated user are searched.
  ///
  /// [md5] is the MD5 hash to search for.
  Future<List<MisskeyDriveFile>> findByHash({required String md5}) async {
    final res = await http.send<List<dynamic>>(
      '/drive/files/find-by-hash',
      body: <String, dynamic>{'md5': md5},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFile.fromJson)
        .toList();
  }

  /// Moves every distinct file ID to a folder in sequential bulk requests.
  ///
  /// Requests are split into chunks of at most 100 IDs. Processing stops after
  /// the first failed chunk, and later chunks are reported as skipped. A
  /// successful chunk means the server accepted it, not that every ID moved:
  /// the server silently ignores IDs that do not exist or belong to another
  /// user.
  ///
  /// This requires Misskey 2025.5.1 or later. Older servers return their
  /// endpoint error unchanged as a failed chunk. When [folderId] is non-null,
  /// this validates the destination folder before any mutation because the
  /// server otherwise reports a missing folder as a generic 500 error.
  /// A failed destination check is thrown (for example a `MisskeyApiException`
  /// with code `NO_SUCH_FOLDER`) and no files are moved. A folder deleted
  /// after the check surfaces as a failed chunk instead.
  ///
  /// Pass `null` for [folderId] to move files to the root. An empty [fileIds]
  /// iterable sends no request, including no destination-folder validation.
  Future<DriveMoveBulkResult> moveBulkAll({
    required Iterable<String> fileIds,
    String? folderId,
  }) => bulk_mover.moveBulkAll(
    http: http,
    fileIds: fileIds,
    folderId: folderId,
    moveBulk: moveBulk,
  );

  /// Moves multiple files to a folder in bulk
  /// (`/api/drive/files/move-bulk`).
  ///
  /// [fileIds] is the list of file IDs to move (1-100 entries, no duplicates).
  /// [folderId] is the destination folder ID; pass `null` to move to the
  /// root.
  Future<void> moveBulk({required List<String> fileIds, String? folderId}) =>
      http.send<Object?>(
        '/drive/files/move-bulk',
        body: <String, dynamic>{'fileIds': fileIds, 'folderId': folderId},
      );

  /// Retrieves chat messages that have the specified file attached
  /// (`/api/drive/files/attached-chat-messages`).
  ///
  /// [fileId] is the target file ID. [limit] caps the number of results
  /// (1-100, default 10). Use [sinceId] and [untilId] to paginate by ID, or
  /// [sinceDate] and [untilDate] to paginate by Unix timestamp in
  /// milliseconds.
  Future<List<MisskeyChatMessage>> attachedChatMessages({
    required String fileId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'fileId': fileId,
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/files/attached-chat-messages',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChatMessage.fromJson)
        .toList();
  }

  /// Retrieves notes that have the specified file attached
  /// (`/api/drive/files/attached-notes`).
  ///
  /// [fileId] is the target file ID. [limit] caps the number of results
  /// (1-100). Use [sinceId] and [untilId] to paginate by ID, or [sinceDate]
  /// and [untilDate] to paginate by Unix timestamp in milliseconds.
  Future<List<MisskeyNote>> attachedNotes({
    required String fileId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'fileId': fileId,
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/drive/files/attached-notes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }
}
