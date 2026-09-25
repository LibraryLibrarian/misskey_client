import '../../client/misskey_cancellation_token.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/bounded_batch.dart';
import '../../internal/drive/folder_dissolver.dart' as folder_dissolver;
import '../../internal/drive/recursive_deleter.dart';
import '../../internal/drive/usage_aggregator.dart';
import '../../internal/id_paginator.dart';
import '../../models/drive/drive_folder_dissolve_result.dart';
import '../../models/drive/drive_recursive_delete.dart';
import '../../models/drive/drive_usage_summary.dart';
import '../../models/misskey_drive_file.dart';
import 'drive_files_api.dart';
import 'drive_folders_api.dart';
import 'drive_stats_api.dart';

/// Serves as a facade for Drive-related APIs.
///
/// Aggregates [files], [folders], and [stats] into a single access point,
/// and also provides top-level `/api/drive/*` endpoints directly.
class DriveApi {
  /// Creates a [DriveApi] instance.
  DriveApi({required MisskeyHttp http})
    : _http = http,
      files = DriveFilesApi(http: http),
      folders = DriveFoldersApi(http: http),
      stats = DriveStatsApi(http: http);

  final MisskeyHttp _http;

  /// Provides Drive file operations.
  final DriveFilesApi files;

  /// Provides Drive folder operations.
  final DriveFoldersApi folders;

  /// Provides Drive statistics operations.
  final DriveStatsApi stats;

  /// Moves a folder's direct files and subfolders to its parent or the root,
  /// then deletes the now-empty folder.
  ///
  /// Misskey permits duplicate names, so this does not rename moved items. It
  /// throws before any change if the folder, its contents, or the destination
  /// parent (checked when moving files) cannot be read. After moves begin, it
  /// returns their individual outcomes and deletes the source folder only when
  /// every move succeeds. If file moves are not complete, subfolders and
  /// deletion are skipped. Concurrent additions can make deletion fail with
  /// `HAS_CHILD_FILES_OR_FOLDERS`; that failure is reported in the result. It
  /// is safe to run again after a partial result.
  ///
  /// [concurrency] bounds parallel subfolder moves; files are moved sequentially
  /// in chunks of 100. It must be positive or an [ArgumentError] is thrown
  /// before any request is sent.
  Future<DriveFolderDissolveResult> dissolveFolder({
    required String folderId,
    int concurrency = 4,
  }) => folder_dissolver.dissolveFolder(
    folderId: folderId,
    concurrency: concurrency,
    files: files,
    folders: folders,
  );

  /// Irreversibly deletes a folder and all its planned contents.
  ///
  /// Run with [dryRun] first to inspect the plan without deleting anything.
  /// Notes and gallery posts keep dangling references to deleted files;
  /// chat messages lose their attachment.
  /// Files are deleted first, then folders deepest-first. A folder whose
  /// planned contents did not succeed is not attempted, nor are its ancestors.
  /// Already absent files and folders count as successfully deleted.
  ///
  /// Planning failures throw before anything is deleted. Once deletion starts,
  /// individual failures are returned in the result. Rate limiting stops new
  /// work. Cancellation is cooperative: in-flight requests finish normally.
  /// Cancellation during planning stops unstarted file listings. The partial
  /// plan contains only files already listed; every planned file and folder is
  /// returned as skipped with `cancelled`, and no deletes are sent (even for a
  /// dry run). Tree traversal itself finishes before cancellation is observed.
  /// Planning spans multiple requests and is not atomic: items added during
  /// planning may be included. Only items absent from the completed plan are
  /// excluded from deletion. A dry run does not freeze the targets of a later
  /// non-dry-run call, which creates a new plan.
  /// Planned items are deleted even if they are moved elsewhere after planning.
  ///
  /// Misskey removes file database rows after responding to file deletion.
  /// A folder with successful planned children therefore retries
  /// `HAS_CHILD_FILES_OR_FOLDERS` with exponential backoff starting at 200 ms,
  /// for at most five attempts. Cancellation interrupts backoff promptly.
  /// If cancellation or rate limiting interrupts a retry, the folder is a
  /// failure containing its last `HAS_CHILD_FILES_OR_FOLDERS` error, not a skip:
  /// its deletion was already attempted. Other write failures are not retried.
  ///
  /// [concurrency] must be positive or an [ArgumentError] is thrown before
  /// any request. Progress counts are per phase and include skipped items.
  /// If [onProgress] throws, unstarted work stops and the error is rethrown
  /// after in-flight work finishes; earlier deletions cannot be rolled back.
  Future<DriveRecursiveDeleteResult> deleteFolderRecursive({
    required String folderId,
    bool dryRun = false,
    int concurrency = 4,
    void Function(DriveRecursiveDeleteProgress progress)? onProgress,
    MisskeyCancellationToken? cancellation,
  }) {
    validateConcurrency(concurrency);
    return deleteDriveFolderRecursive(
      files: files,
      folders: folders,
      folderId: folderId,
      dryRun: dryRun,
      concurrency: concurrency,
      onProgress: onProgress,
      cancellation: cancellation,
    );
  }

  /// Lazily retrieves all files across all folders in newest-first ID order.
  ///
  /// Only ID order is supported: the server applies `untilId` as an ID filter
  /// even when sorting by name or size, causing pages to skip or repeat items.
  /// Collect the results and sort locally for other orders. This is not a
  /// snapshot; changes on the server during pagination may affect results.
  ///
  /// [type] accepts only letters, `/`, `-`, and `*` (for example, `image/*`).
  /// The server rejects values containing digits such as `video/mp4`.
  /// [pageSize] must be 1-100 and [maxItems] must be non-negative, or an
  /// [ArgumentError] is thrown synchronously. A zero [maxItems] sends no request.
  ///
  /// Each call returns a cold, single-subscription stream: requests start only
  /// when listened to. API errors are delivered as stream errors after any
  /// already-yielded items.
  Stream<MisskeyDriveFile> streamAll({
    String? type,
    int pageSize = 100,
    int? maxItems,
  }) {
    validatePageArgs(pageSize, maxItems);
    return paginateById(
      fetchPage: (limit, untilId) =>
          stream(limit: limit, untilId: untilId, type: type),
      idOf: (item) => item.id,
      pageSize: pageSize,
      maxItems: maxItems,
    );
  }

  /// Scans the whole Drive and aggregates file usage by folder and MIME type.
  ///
  /// This makes about one `/drive/stream` request per 100 files plus one
  /// `/drive/folders` listing per folder. It is not an atomic snapshot:
  /// concurrent Drive changes can cause small inconsistencies. Linked files
  /// (uncached remote files with `isLink`) are included here but excluded from
  /// server-reported Drive usage, so [DriveUsageSummary.total] may differ from
  /// the usage reported by [DriveStatsApi.getCapacity].
  ///
  /// [onProgress] is called after every scanned file with the cumulative count.
  /// [concurrency] limits concurrent folder-tree requests and must be positive.
  /// Invalid concurrency throws [ArgumentError] before any request is made. If
  /// scanning fails, in-flight folder listings cannot be cancelled and may
  /// continue briefly before their errors are discarded.
  Future<DriveUsageSummary> getUsageSummary({
    int concurrency = 4,
    void Function(int filesScanned)? onProgress,
  }) {
    validateConcurrency(concurrency);
    return aggregateDriveUsage(
      getTree: () => folders.getTree(concurrency: concurrency),
      streamAll: streamAll,
      onProgress: onProgress,
    );
  }

  /// Retrieves all files in the Drive regardless of folder
  /// (`/api/drive/stream`).
  ///
  /// Unlike [DriveFilesApi.list], this endpoint does not support folder
  /// filtering or sorting, and is specialized for MIME type filtering
  /// and pagination.
  ///
  /// [limit] caps the number of results (1-100, default 10). Use [sinceId]
  /// and [untilId] to paginate by ID, or [sinceDate] and [untilDate] to
  /// paginate by Unix timestamp in milliseconds. Pass [type] to filter by MIME
  /// type pattern (e.g., `"image/*"`).
  Future<List<MisskeyDriveFile>> stream({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? type,
  }) async {
    final body = <String, dynamic>{
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
      'type': ?type,
    };
    final res = await _http.send<List<dynamic>>(
      '/drive/stream',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFile.fromJson)
        .toList();
  }
}
