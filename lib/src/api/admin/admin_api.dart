import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../internal/request_body.dart';
import '../../models/admin/misskey_admin_meta.dart';
import '../../models/admin/misskey_admin_server_info.dart';
import '../../models/admin/misskey_admin_user_detail.dart';
import '../../models/admin/misskey_moderation_log.dart';
import '../../models/misskey_user.dart';

/// Provides core admin API endpoints (`/api/admin/*`).
///
/// All endpoints require a token belonging to an administrator
/// (or a moderator, where noted).
class AdminApi {
  const AdminApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Fetches the full instance settings (`/api/admin/meta`).
  ///
  /// Requires administrator privileges. Fields not typed on
  /// [MisskeyAdminMeta] are available through `raw`.
  Future<MisskeyAdminMeta> meta() async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/meta',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyAdminMeta.fromJson(res);
  }

  /// Updates instance settings (`/api/admin/update-meta`).
  ///
  /// Requires administrator privileges. Only the parameters that are
  /// provided are sent; omitted parameters remain unchanged on the server.
  /// Nullable settings use the [Optional] type: pass `Optional('value')`
  /// to set and `Optional.null_()` to clear.
  ///
  /// [federation] accepts `all`, `specified`, or `none`. When it is
  /// `specified`, [federationHosts] lists the hosts allowed to federate.
  Future<void> updateMeta({
    Optional<String>? name,
    Optional<String>? description,
    Optional<String>? maintainerName,
    Optional<String>? maintainerEmail,
    Optional<String>? tosUrl,
    Optional<String>? privacyPolicyUrl,
    Optional<String>? impressumUrl,
    Optional<String>? inquiryUrl,
    Optional<String>? proxyAccountId,
    bool? disableRegistration,
    bool? emailRequiredForSignup,
    bool? enableEmail,
    bool? enableServiceWorker,
    bool? enableIpLogging,
    bool? enableActiveEmailValidation,
    bool? cacheRemoteFiles,
    bool? cacheRemoteSensitiveFiles,
    String? federation,
    List<String>? federationHosts,
    List<String>? blockedHosts,
    List<String>? silencedHosts,
    List<String>? mediaSilencedHosts,
    List<String>? sensitiveWords,
    List<String>? prohibitedWords,
    List<String>? hiddenTags,
    List<String>? preservedUsernames,
  }) async {
    final body = <String, dynamic>{
      'disableRegistration': ?disableRegistration,
      'emailRequiredForSignup': ?emailRequiredForSignup,
      'enableEmail': ?enableEmail,
      'enableServiceWorker': ?enableServiceWorker,
      'enableIpLogging': ?enableIpLogging,
      'enableActiveEmailValidation': ?enableActiveEmailValidation,
      'cacheRemoteFiles': ?cacheRemoteFiles,
      'cacheRemoteSensitiveFiles': ?cacheRemoteSensitiveFiles,
      'federation': ?federation,
      'federationHosts': ?federationHosts,
      'blockedHosts': ?blockedHosts,
      'silencedHosts': ?silencedHosts,
      'mediaSilencedHosts': ?mediaSilencedHosts,
      'sensitiveWords': ?sensitiveWords,
      'prohibitedWords': ?prohibitedWords,
      'hiddenTags': ?hiddenTags,
      'preservedUsernames': ?preservedUsernames,
    };
    putOptional(body, 'name', name);
    putOptional(body, 'description', description);
    putOptional(body, 'maintainerName', maintainerName);
    putOptional(body, 'maintainerEmail', maintainerEmail);
    putOptional(body, 'tosUrl', tosUrl);
    putOptional(body, 'privacyPolicyUrl', privacyPolicyUrl);
    putOptional(body, 'impressumUrl', impressumUrl);
    putOptional(body, 'inquiryUrl', inquiryUrl);
    putOptional(body, 'proxyAccountId', proxyAccountId);
    await http.send<Object?>('/admin/update-meta', body: body);
  }

  /// Fetches server hardware/software information
  /// (`/api/admin/server-info`).
  ///
  /// Requires administrator privileges.
  Future<MisskeyAdminServerInfo> serverInfo() async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/server-info',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyAdminServerInfo.fromJson(res);
  }

  /// Fetches moderation details for a user (`/api/admin/show-user`).
  ///
  /// Requires moderator privileges. Pass the target user ID in [userId].
  ///
  /// Common errors:
  /// - `NO_SUCH_USER`: The specified user does not exist
  Future<MisskeyAdminUserDetail> showUser({required String userId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/show-user',
      body: <String, dynamic>{'userId': userId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyAdminUserDetail.fromJson(res);
  }

  /// Fetches a filtered list of users (`/api/admin/show-users`).
  ///
  /// Requires moderator privileges.
  ///
  /// Use [limit] (1-100, default 10) and [offset] for paging. Pass [sort]
  /// such as `+createdAt` / `-createdAt` / `+follower` / `-follower` /
  /// `+updatedAt` / `-updatedAt` / `+lastActiveDate` / `-lastActiveDate`.
  /// [state] filters by user state (`all`, `alive`, `available`, `admin`,
  /// `moderator`, `adminOrModerator`, `suspended`). [origin] filters by
  /// origin (`combined`, `local`, `remote`). [username] and [hostname]
  /// filter by partial match.
  Future<List<MisskeyUser>> showUsers({
    int? limit,
    int? offset,
    String? sort,
    String? state,
    String? origin,
    String? username,
    String? hostname,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/show-users',
      body: <String, dynamic>{
        'limit': ?limit,
        'offset': ?offset,
        'sort': ?sort,
        'state': ?state,
        'origin': ?origin,
        'username': ?username,
        'hostname': ?hostname,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// Suspends a user (`/api/admin/suspend-user`).
  ///
  /// Requires moderator privileges. Pass the target user ID in [userId].
  Future<void> suspendUser({required String userId}) => http.send<Object?>(
    '/admin/suspend-user',
    body: <String, dynamic>{'userId': userId},
  );

  /// Lifts a user's suspension (`/api/admin/unsuspend-user`).
  ///
  /// Requires moderator privileges. Pass the target user ID in [userId].
  Future<void> unsuspendUser({required String userId}) => http.send<Object?>(
    '/admin/unsuspend-user',
    body: <String, dynamic>{'userId': userId},
  );

  /// Resets a user's password (`/api/admin/reset-password`).
  ///
  /// Requires moderator privileges. Returns the newly generated password
  /// (8 characters).
  Future<String> resetPassword({required String userId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/reset-password',
      body: <String, dynamic>{'userId': userId},
    );
    return res['password'] as String;
  }

  /// Updates the moderation note for a user
  /// (`/api/admin/update-user-note`).
  ///
  /// Requires moderator privileges. The note in [text] is visible only
  /// to moderators.
  Future<void> updateUserNote({required String userId, required String text}) =>
      http.send<Object?>(
        '/admin/update-user-note',
        body: <String, dynamic>{'userId': userId, 'text': text},
      );

  /// Deletes a user account (`/api/admin/delete-account`).
  ///
  /// Requires administrator privileges. The deletion is processed
  /// asynchronously on the server.
  Future<void> deleteAccount({required String userId}) => http.send<Object?>(
    '/admin/delete-account',
    body: <String, dynamic>{'userId': userId},
  );

  /// Deletes every drive file owned by a user
  /// (`/api/admin/delete-all-files-of-a-user`).
  ///
  /// Requires moderator privileges.
  Future<void> deleteAllFilesOfAUser({required String userId}) =>
      http.send<Object?>(
        '/admin/delete-all-files-of-a-user',
        body: <String, dynamic>{'userId': userId},
      );

  /// Removes a user's avatar image (`/api/admin/unset-user-avatar`).
  ///
  /// Requires moderator privileges.
  Future<void> unsetUserAvatar({required String userId}) => http.send<Object?>(
    '/admin/unset-user-avatar',
    body: <String, dynamic>{'userId': userId},
  );

  /// Removes a user's banner image (`/api/admin/unset-user-banner`).
  ///
  /// Requires moderator privileges.
  Future<void> unsetUserBanner({required String userId}) => http.send<Object?>(
    '/admin/unset-user-banner',
    body: <String, dynamic>{'userId': userId},
  );

  /// Fetches the IP addresses recorded for a user
  /// (`/api/admin/get-user-ips`).
  ///
  /// Requires moderator privileges. Returns an empty list when IP
  /// logging is disabled (`enableIpLogging`).
  Future<List<MisskeyUserIp>> getUserIps({required String userId}) async {
    final res = await http.send<List<dynamic>>(
      '/admin/get-user-ips',
      body: <String, dynamic>{'userId': userId},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUserIp.fromJson)
        .toList();
  }

  /// Fetches moderation logs (`/api/admin/show-moderation-logs`).
  ///
  /// Requires moderator privileges. Use [limit] (1-100, default 10) to
  /// cap the number of results and [sinceId] / [untilId] for
  /// cursor-based pagination. [type] filters by action type, [userId] by
  /// the moderator who performed the action, and [search] by keyword.
  Future<List<MisskeyModerationLog>> showModerationLogs({
    int? limit,
    String? sinceId,
    String? untilId,
    String? type,
    String? userId,
    String? search,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/show-moderation-logs',
      body: <String, dynamic>{
        'limit': ?limit,
        'sinceId': ?sinceId,
        'untilId': ?untilId,
        'type': ?type,
        'userId': ?userId,
        'search': ?search,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyModerationLog.fromJson)
        .toList();
  }

  /// Sends an email (`/api/admin/send-email`).
  ///
  /// Requires administrator privileges and a configured SMTP server.
  Future<void> sendEmail({
    required String to,
    required String subject,
    required String text,
  }) => http.send<Object?>(
    '/admin/send-email',
    body: <String, dynamic>{'to': to, 'subject': subject, 'text': text},
  );

  /// Updates the proxy account's profile
  /// (`/api/admin/update-proxy-account`).
  ///
  /// Requires administrator privileges. Returns the updated proxy
  /// account.
  ///
  /// Omitting [description] keeps the current value. Use the [Optional] type
  /// to change it: pass `Optional('value')` to set and `Optional.null_()` to
  /// clear.
  Future<MisskeyUser> updateProxyAccount({
    Optional<String>? description,
  }) async {
    final body = <String, dynamic>{};
    putOptional(body, 'description', description);
    final res = await http.send<Map<String, dynamic>>(
      '/admin/update-proxy-account',
      body: body,
    );
    return MisskeyUser.fromJson(res);
  }

  /// Pins a note as a promotion (`/api/admin/promo/create`).
  ///
  /// Requires moderator privileges. [expiresAt] is an epoch timestamp in
  /// milliseconds.
  ///
  /// Common errors:
  /// - `NO_SUCH_NOTE`: The specified note does not exist
  /// - `ALREADY_PROMOTED`: The note is already promoted
  Future<void> createPromo({required String noteId, required int expiresAt}) =>
      http.send<Object?>(
        '/admin/promo/create',
        body: <String, dynamic>{'noteId': noteId, 'expiresAt': expiresAt},
      );

  /// Fetches PostgreSQL index statistics
  /// (`/api/admin/get-index-stats`).
  ///
  /// Requires administrator privileges.
  Future<List<MisskeyIndexStat>> getIndexStats() async {
    final res = await http.send<List<dynamic>>(
      '/admin/get-index-stats',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyIndexStat.fromJson)
        .toList();
  }

  /// Fetches PostgreSQL table statistics
  /// (`/api/admin/get-table-stats`).
  ///
  /// Requires administrator privileges. The result maps each table name
  /// to its row count and size in bytes.
  Future<Map<String, MisskeyTableStat>> getTableStats() async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/get-table-stats',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res.map(
      (key, value) => MapEntry(
        key,
        MisskeyTableStat.fromJson(value as Map<String, dynamic>),
      ),
    );
  }
}
