import '../../client/misskey_cancellation_token.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/bounded_batch.dart';
import '../../internal/drive/recursive_deleter.dart';
import '../../internal/id_paginator.dart';
import '../../models/drive/drive_recursive_delete.dart';
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

  /// Irreversibly deletes a folder and all its planned contents.
  ///
  /// Run with [dryRun] first to inspect the plan without deleting anything.
  /// Notes and chat messages retain dangling references to deleted files.
  /// Files are deleted first, then folders deepest-first. A folder whose
  /// planned contents did not succeed is not attempted, nor are its ancestors.
  /// Already absent files and folders count as successfully deleted.
  ///
  /// Planning failures throw before anything is deleted. Once deletion starts,
  /// individual failures are returned in the result. Rate limiting stops new
  /// work. Cancellation is cooperative: in-flight requests finish normally.
  /// The plan is a snapshot; concurrently added contents are not deleted.
  ///
  /// Misskey removes file database rows after responding to file deletion.
  /// A folder with successful planned children therefore retries
  /// `HAS_CHILD_FILES_OR_FOLDERS` with exponential backoff starting at 200 ms,
  /// for at most five attempts. Other write failures are not retried.
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
