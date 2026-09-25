import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/bounded_batch.dart';
import '../../internal/drive/folder_dissolver.dart' as folder_dissolver;
import '../../internal/drive/usage_aggregator.dart';
import '../../internal/id_paginator.dart';
import '../../models/drive/drive_folder_dissolve_result.dart';
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
  /// deletion are skipped. An HTTP 429 stops scheduling additional subfolder
  /// moves; already-started requests finish, remaining subfolders are reported
  /// as `rateLimited`, and deletion is skipped. Concurrent additions can make
  /// deletion fail with `HAS_CHILD_FILES_OR_FOLDERS`; that failure is reported
  /// in the result. It is safe to run again after a partial result.
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

  /// Lazily retrieves all files across all folders in newest-first ID order.
  ///
  /// Results are newest-first by ID. Other orders require collecting the
  /// results and sorting locally. This is not a snapshot; changes on the
  /// server during pagination may affect results.
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
  /// scanning fails, no additional folder listings start; already-started
  /// requests finish before their results and errors are discarded.
  Future<DriveUsageSummary> getUsageSummary({
    int concurrency = 4,
    void Function(int filesScanned)? onProgress,
  }) {
    validateConcurrency(concurrency);
    return aggregateDriveUsage(
      showFolder: (folderId) => folders.show(folderId: folderId),
      listAllFolders: (folderId) => folders.listAll(folderId: folderId),
      concurrency: concurrency,
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
