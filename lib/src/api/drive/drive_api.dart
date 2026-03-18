import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
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
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (type != null) 'type': type,
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
