import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';

/// Provides federation management admin APIs (`/api/admin/federation/*`).
///
/// All endpoints require moderator privileges.
class AdminFederationApi {
  const AdminFederationApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Deletes all cached files from a remote instance
  /// (`/api/admin/federation/delete-all-files`).
  Future<void> deleteAllFiles({required String host}) => http.send<Object?>(
    '/admin/federation/delete-all-files',
    body: <String, dynamic>{'host': host},
  );

  /// Refreshes the cached metadata of a remote instance
  /// (`/api/admin/federation/refresh-remote-instance-metadata`).
  Future<void> refreshRemoteInstanceMetadata({required String host}) =>
      http.send<Object?>(
        '/admin/federation/refresh-remote-instance-metadata',
        body: <String, dynamic>{'host': host},
      );

  /// Removes all follow relationships involving a remote instance
  /// (`/api/admin/federation/remove-all-following`).
  ///
  /// This is a destructive moderation action; follow relationships
  /// cannot be restored automatically afterwards.
  Future<void> removeAllFollowing({required String host}) => http.send<Object?>(
    '/admin/federation/remove-all-following',
    body: <String, dynamic>{'host': host},
  );

  /// Updates moderation settings for a remote instance
  /// (`/api/admin/federation/update-instance`).
  ///
  /// Set [isSuspended] to stop delivering activities to the instance.
  /// [moderationNote] is visible only to moderators.
  ///
  /// Note: the server returns `INTERNAL_ERROR` (500) when the update
  /// results in no actual change (e.g. setting [isSuspended] to its
  /// current value), as observed on Misskey 2026.5.1.
  Future<void> updateInstance({
    required String host,
    bool? isSuspended,
    String? moderationNote,
  }) => http.send<Object?>(
    '/admin/federation/update-instance',
    body: <String, dynamic>{
      'host': host,
      'isSuspended': ?isSuspended,
      'moderationNote': ?moderationNote,
    },
  );
}
