import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/federation/misskey_federation_instance.dart';
import '../models/federation/misskey_federation_stats.dart';
import '../models/misskey_following.dart';
import '../models/misskey_user.dart';

/// Provides federation-related operations (`/api/federation/*`).
///
/// Handles retrieval of federated instance lists, details, follow
/// relationships, and statistics.
class FederationApi {
  const FederationApi({required this.http});

  final MisskeyHttp http;

  /// Retrieves a list of federated instances (`/api/federation/instances`).
  ///
  /// No authentication required. Responses are cached for 3600 seconds.
  ///
  /// Pass [host] to filter by host name, or omit it to return all instances.
  /// Use [blocked], [notResponding], [suspended], [silenced], [federating],
  /// [subscribing], and [publishing] to filter by instance status flags.
  /// Use [limit] to cap the number of results (1-100, default: 30) and
  /// [offset] to skip entries (default: 0). Pass [sort] to control the order;
  /// accepted values are `+pubSub` / `-pubSub` / `+notes` / `-notes` /
  /// `+users` / `-users` / `+following` / `-following` /
  /// `+followers` / `-followers` /
  /// `+firstRetrievedAt` / `-firstRetrievedAt` /
  /// `+latestRequestReceivedAt` / `-latestRequestReceivedAt`.
  Future<List<MisskeyFederationInstance>> instances({
    String? host,
    bool? blocked,
    bool? notResponding,
    bool? suspended,
    bool? silenced,
    bool? federating,
    bool? subscribing,
    bool? publishing,
    int? limit,
    int? offset,
    String? sort,
  }) async {
    final body = <String, dynamic>{
      if (host != null) 'host': host,
      if (blocked != null) 'blocked': blocked,
      if (notResponding != null) 'notResponding': notResponding,
      if (suspended != null) 'suspended': suspended,
      if (silenced != null) 'silenced': silenced,
      if (federating != null) 'federating': federating,
      if (subscribing != null) 'subscribing': subscribing,
      if (publishing != null) 'publishing': publishing,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (sort != null) 'sort': sort,
    };
    final res = await http.send<List<dynamic>>(
      '/federation/instances',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFederationInstance.fromJson)
        .toList();
  }

  /// Retrieves detailed information about a federated instance
  /// (`/api/federation/show-instance`).
  ///
  /// No authentication required. Returns `null` if the instance is unknown.
  /// Pass [host] as the host name to look up.
  Future<MisskeyFederationInstance?> showInstance({
    required String host,
  }) async {
    final res = await http.send<Map<String, dynamic>?>(
      '/federation/show-instance',
      body: <String, dynamic>{'host': host},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    if (res == null) return null;
    return MisskeyFederationInstance.fromJson(res);
  }

  /// Retrieves the list of followers from a specified instance
  /// (`/api/federation/followers`).
  ///
  /// No authentication required. Pass [host] as the host name to query.
  /// Use [limit] to cap the number of results (1-100, default: 10).
  /// Pass [sinceId] or [untilId] to paginate by ID, or pass [sinceDate]
  /// or [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyFollowing>> followers({
    required String host,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'host': host,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/federation/followers',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowing.fromJson)
        .toList();
  }

  /// Retrieves the list of accounts followed on a specified instance
  /// (`/api/federation/following`).
  ///
  /// No authentication required. Pass [host] as the host name to query.
  /// Use [limit] to cap the number of results (1-100, default: 10).
  /// Pass [sinceId] or [untilId] to paginate by ID, or pass [sinceDate]
  /// or [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyFollowing>> following({
    required String host,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'host': host,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/federation/following',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowing.fromJson)
        .toList();
  }

  /// Retrieves the list of users on a specified instance
  /// (`/api/federation/users`).
  ///
  /// No authentication required. Pass [host] as the host name to query.
  /// Use [limit] to cap the number of results (1-100, default: 10).
  /// Pass [sinceId] or [untilId] to paginate by ID, or pass [sinceDate]
  /// or [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyUser>> users({
    required String host,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'host': host,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/federation/users',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// Retrieves federation statistics (`/api/federation/stats`).
  ///
  /// Returns the top instances by follower/following count along with totals.
  /// No authentication required. Use [limit] to cap the number of top
  /// instances returned (1-100, default: 10).
  Future<MisskeyFederationStats> stats({int? limit}) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/federation/stats',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return MisskeyFederationStats.fromJson(res);
  }

  /// Re-fetches a remote user's information
  /// (`/api/federation/update-remote-user`).
  ///
  /// Re-fetches the ActivityPub information for the specified remote user.
  /// Authentication required. Pass [userId] as the ID of the user to update.
  Future<void> updateRemoteUser({required String userId}) => http.send<Object?>(
        '/federation/update-remote-user',
        body: <String, dynamic>{'userId': userId},
      );
}
