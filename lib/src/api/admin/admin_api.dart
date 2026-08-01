import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../models/admin/misskey_admin_meta.dart';
import '../../models/admin/misskey_admin_server_info.dart';
import '../../models/admin/misskey_admin_user_detail.dart';
import '../../models/misskey_user.dart';

/// Provides core admin API endpoints (`/api/admin/*`).
///
/// All endpoints require a token belonging to an administrator
/// (or a moderator, where noted).
class AdminApi {
  const AdminApi({required this.http});

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
      if (disableRegistration != null)
        'disableRegistration': disableRegistration,
      if (emailRequiredForSignup != null)
        'emailRequiredForSignup': emailRequiredForSignup,
      if (enableEmail != null) 'enableEmail': enableEmail,
      if (enableServiceWorker != null)
        'enableServiceWorker': enableServiceWorker,
      if (enableIpLogging != null) 'enableIpLogging': enableIpLogging,
      if (enableActiveEmailValidation != null)
        'enableActiveEmailValidation': enableActiveEmailValidation,
      if (cacheRemoteFiles != null) 'cacheRemoteFiles': cacheRemoteFiles,
      if (cacheRemoteSensitiveFiles != null)
        'cacheRemoteSensitiveFiles': cacheRemoteSensitiveFiles,
      if (federation != null) 'federation': federation,
      if (federationHosts != null) 'federationHosts': federationHosts,
      if (blockedHosts != null) 'blockedHosts': blockedHosts,
      if (silencedHosts != null) 'silencedHosts': silencedHosts,
      if (mediaSilencedHosts != null)
        'mediaSilencedHosts': mediaSilencedHosts,
      if (sensitiveWords != null) 'sensitiveWords': sensitiveWords,
      if (prohibitedWords != null) 'prohibitedWords': prohibitedWords,
      if (hiddenTags != null) 'hiddenTags': hiddenTags,
      if (preservedUsernames != null)
        'preservedUsernames': preservedUsernames,
    };
    _putOptional(body, 'name', name);
    _putOptional(body, 'description', description);
    _putOptional(body, 'maintainerName', maintainerName);
    _putOptional(body, 'maintainerEmail', maintainerEmail);
    _putOptional(body, 'tosUrl', tosUrl);
    _putOptional(body, 'privacyPolicyUrl', privacyPolicyUrl);
    _putOptional(body, 'impressumUrl', impressumUrl);
    _putOptional(body, 'inquiryUrl', inquiryUrl);
    _putOptional(body, 'proxyAccountId', proxyAccountId);
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
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (sort != null) 'sort': sort,
        if (state != null) 'state': state,
        if (origin != null) 'origin': origin,
        if (username != null) 'username': username,
        if (hostname != null) 'hostname': hostname,
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
  Future<void> updateUserNote({
    required String userId,
    required String text,
  }) =>
      http.send<Object?>(
        '/admin/update-user-note',
        body: <String, dynamic>{'userId': userId, 'text': text},
      );
}

/// Adds an [Optional]-wrapped value to the request body.
///
/// When [opt] is `null` (unspecified) the function does nothing. When [opt]
/// is a [Some] instance, `body[key]` is set to the wrapped value, which is
/// `null` for `Some.null_()`.
void _putOptional<T>(
  Map<String, dynamic> body,
  String key,
  Optional<T>? opt,
) {
  if (opt case Some<T>(:final value)) {
    body[key] = value;
  }
}
