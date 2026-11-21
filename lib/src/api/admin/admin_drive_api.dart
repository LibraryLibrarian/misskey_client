import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/admin/misskey_admin_drive_file.dart';
import '../../models/misskey_drive_file.dart';

/// Provides drive management admin APIs (`/api/admin/drive/*`).
///
/// All endpoints require moderator privileges.
class AdminDriveApi {
  @internal
  const AdminDriveApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Fetches drive files across all users (`/api/admin/drive/files`).
  ///
  /// Use [limit] (1-100, default 10) to cap the number of results and
  /// [sinceId] / [untilId] for cursor-based pagination. [sinceDate] /
  /// [untilDate] paginate by Unix timestamp in milliseconds. [userId]
  /// filters by owner, [type] by MIME type (e.g. `image/*`), [origin] by
  /// origin (`combined`, `local`, `remote`), and [hostname] by remote host.
  Future<List<MisskeyDriveFile>> files({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
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
        'sinceDate': ?sinceDate,
        'untilDate': ?untilDate,
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
  /// Identify the file by [fileId] or [url]. At least one is required; an
  /// [ArgumentError] is thrown when both are omitted.
  /// Returns file metadata and moderation details, including storage keys
  /// and upload request information when visible to the moderator.
  ///
  /// Common errors:
  /// - `NO_SUCH_FILE`: The specified file does not exist
  Future<MisskeyAdminDriveFile> showFile({String? fileId, String? url}) async {
    if (fileId == null && url == null) {
      throw ArgumentError(
        'Either fileId or url must be provided to identify the file.',
      );
    }
    final res = await http.send<Map<String, dynamic>>(
      '/admin/drive/show-file',
      body: <String, dynamic>{'fileId': ?fileId, 'url': ?url},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyAdminDriveFile.fromJson(res);
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
