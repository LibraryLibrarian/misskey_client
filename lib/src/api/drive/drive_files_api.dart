import 'package:dio/dio.dart' show FormData, MultipartFile;

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/chat/misskey_chat_message.dart';
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
  final MisskeyHttp http;

  /// Retrieves a list of Drive files (`/api/drive/files`).
  ///
  /// [limit] caps the number of results (1-100). Use [sinceId] and [untilId]
  /// to paginate by ID, or [sinceDate] and [untilDate] to paginate by Unix
  /// timestamp in milliseconds. Pass [folderId] to filter by folder (`null`
  /// for root) and [type] to filter by MIME type pattern (e.g., `"image/*"`).
  /// [sort] controls the sort order and accepts `+createdAt`, `-createdAt`,
  /// `+name`, `-name`, `+size`, or `-size`.
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
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (folderId != null) 'folderId': folderId,
      if (type != null) 'type': type,
      if (sort != null) 'sort': sort,
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
  /// mark the file as sensitive content. Set [force] to upload even if a file
  /// with the same name already exists. [onSendProgress] is an optional
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

  /// Updates the metadata of a Drive file (`/api/drive/files/update`).
  ///
  /// [fileId] identifies the file to update. [name] sets a new file name.
  /// [folderId] moves the file to the specified folder. Set [moveToRoot] to
  /// `true` to move the file to the root folder (sends `folderId: null`
  /// explicitly). [comment] is an optional comment (up to 512 characters).
  /// Set [isSensitive] to mark the file as sensitive content.
  Future<MisskeyDriveFile> update({
    required String fileId,
    String? name,
    String? folderId,
    bool moveToRoot = false,
    String? comment,
    bool? isSensitive,
  }) async {
    final body = <String, dynamic>{
      'fileId': fileId,
      if (name != null) 'name': name,
      if (moveToRoot)
        'folderId': null
      else if (folderId != null)
        'folderId': folderId,
      if (comment != null) 'comment': comment,
      if (isSensitive != null) 'isSensitive': isSensitive,
    };
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
    final body = <String, dynamic>{
      'name': name,
      if (folderId != null) 'folderId': folderId,
    };
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
  /// event. Set [force] to upload even if a file with the same name already
  /// exists.
  Future<void> uploadFromUrl({
    required String url,
    String? folderId,
    bool? isSensitive,
    String? comment,
    String? marker,
    bool? force,
  }) =>
      http.send<Object?>(
        '/drive/files/upload-from-url',
        body: <String, dynamic>{
          'url': url,
          if (folderId != null) 'folderId': folderId,
          if (isSensitive != null) 'isSensitive': isSensitive,
          if (comment != null) 'comment': comment,
          if (marker != null) 'marker': marker,
          if (force != null) 'force': force,
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

  /// Moves multiple files to a folder in bulk
  /// (`/api/drive/files/move-bulk`).
  ///
  /// [fileIds] is the list of file IDs to move (1-100 entries, no duplicates).
  /// [folderId] is the destination folder ID; pass `null` to move to the
  /// root.
  Future<void> moveBulk({
    required List<String> fileIds,
    String? folderId,
  }) =>
      http.send<Object?>(
        '/drive/files/move-bulk',
        body: <String, dynamic>{
          'fileIds': fileIds,
          'folderId': folderId,
        },
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
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
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
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
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
