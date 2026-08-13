import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/misskey_drive_file.dart';

/// Provides drive management admin APIs (`/api/admin/drive/*`).
///
/// All endpoints require moderator privileges.
class AdminDriveApi {
  const AdminDriveApi({required this.http});

  final MisskeyHttp http;

  /// Fetches drive files across all users (`/api/admin/drive/files`).
  ///
  /// Use [limit] (1-100, default 10) to cap the number of results and
  /// [sinceId] / [untilId] for cursor-based pagination. [userId] filters
  /// by owner, [type] by MIME type (e.g. `image/*`), [origin] by origin
  /// (`combined`, `local`, `remote`), and [hostname] by remote host.
  Future<List<MisskeyDriveFile>> files({
    int? limit,
    String? sinceId,
    String? untilId,
    String? userId,
    String? type,
    String? origin,
    String? hostname,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/drive/files',
      body: <String, dynamic>{
        'limit': ?limit,
        'sinceId': ?sinceId,
        'untilId': ?untilId,
        'userId': ?userId,
        'type': ?type,
        'origin': ?origin,
        'hostname': ?hostname,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyDriveFile.fromJson)
        .toList();
  }

  /// Fetches a drive file including moderation details
  /// (`/api/admin/drive/show-file`).
  ///
  /// Identify the file by [fileId] or [url] (at least one is required).
  /// The response includes fields not present in the regular drive API,
  /// so it is returned as raw JSON.
  ///
  /// Common errors:
  /// - `NO_SUCH_FILE`: The specified file does not exist
  Future<Map<String, dynamic>> showFile({String? fileId, String? url}) {
    assert(
      fileId != null || url != null,
      'Either fileId or url must be provided to identify the file.',
    );
    return http.send<Map<String, dynamic>>(
      '/admin/drive/show-file',
      body: <String, dynamic>{'fileId': ?fileId, 'url': ?url},
      options: const RequestOptions(idempotent: true),
    );
  }

  /// Deletes cached remote files (`/api/admin/drive/clean-remote-files`).
  ///
  /// The cleanup is processed asynchronously on the server.
  Future<void> cleanRemoteFiles() => http.send<Object?>(
    '/admin/drive/clean-remote-files',
    body: const <String, dynamic>{},
  );

  /// Deletes orphaned drive files (`/api/admin/drive/cleanup`).
  Future<void> cleanup() => http.send<Object?>(
    '/admin/drive/cleanup',
    body: const <String, dynamic>{},
  );
}
