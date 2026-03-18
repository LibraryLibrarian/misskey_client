import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';

/// Provides statistics chart APIs.
///
/// Delegates `/api/charts/*` endpoint calls to [MisskeyHttp].
/// Each method returns a nested `Map<String, dynamic>` where all leaf
/// values are `List<num>` (time-series data).
class ChartsApi {
  /// Creates a [ChartsApi] instance.
  const ChartsApi({required this.http});

  /// The HTTP client.
  final MisskeyHttp http;

  /// Retrieves active user statistics (`/api/charts/active-users`).
  ///
  /// Response fields:
  /// `readWrite`, `read`, `write`,
  /// `registeredWithinWeek`, `registeredWithinMonth`,
  /// `registeredWithinYear`, `registeredOutsideWeek`,
  /// `registeredOutsideMonth`, `registeredOutsideYear`
  ///
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getActiveUsers({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/active-users',
        span: span, limit: limit, offset: offset);
  }

  /// Retrieves ActivityPub request statistics (`/api/charts/ap-request`).
  ///
  /// Response fields:
  /// `deliverFailed`, `deliverSucceeded`, `inboxReceived`
  ///
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getApRequest({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/ap-request',
        span: span, limit: limit, offset: offset);
  }

  /// Retrieves federation statistics (`/api/charts/federation`).
  ///
  /// Response fields:
  /// `deliveredInstances`, `inboxInstances`, `stalled`,
  /// `sub`, `pub`, `pubsub`, `subActive`, `pubActive`
  ///
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getFederation({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/federation',
        span: span, limit: limit, offset: offset);
  }

  /// Retrieves statistics for a specific instance (`/api/charts/instance`).
  ///
  /// Response fields (nested):
  /// `requests.{failed, succeeded, received}`,
  /// `notes.{total, inc, dec, diffs.{normal, reply, renote, withFile}}`,
  /// `users.{total, inc, dec}`,
  /// `following.{total, inc, dec}`,
  /// `followers.{total, inc, dec}`,
  /// `drive.{totalFiles, incFiles, decFiles, incUsage, decUsage}`
  ///
  /// Pass [host] as the hostname of the target instance.
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getInstance({
    required String host,
    required String span,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'host': host,
      'span': span,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/charts/instance',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res;
  }

  /// Retrieves note statistics (`/api/charts/notes`).
  ///
  /// Response fields (nested):
  /// `local.{total, inc, dec, diffs.{normal, reply, renote, withFile}}`,
  /// `remote.{total, inc, dec, diffs.{normal, reply, renote, withFile}}`
  ///
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getNotes({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/notes',
        span: span, limit: limit, offset: offset);
  }

  /// Retrieves user statistics (`/api/charts/users`).
  ///
  /// Response fields (nested):
  /// `local.{total, inc, dec}`,
  /// `remote.{total, inc, dec}`
  ///
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getUsers({
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchChart('/charts/users',
        span: span, limit: limit, offset: offset);
  }

  /// Retrieves following statistics for a specific user
  /// (`/api/charts/user/following`).
  ///
  /// Response fields (nested):
  /// `local.followings.{total, inc, dec}`,
  /// `local.followers.{total, inc, dec}`,
  /// `remote.followings.{total, inc, dec}`,
  /// `remote.followers.{total, inc, dec}`
  ///
  /// Pass [userId] to identify the target user.
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getUserFollowing({
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchUserChart('/charts/user/following',
        userId: userId, span: span, limit: limit, offset: offset);
  }

  /// Retrieves note statistics for a specific user
  /// (`/api/charts/user/notes`).
  ///
  /// Response fields (nested):
  /// `total`, `inc`, `dec`,
  /// `diffs.{normal, reply, renote, withFile}`
  ///
  /// Pass [userId] to identify the target user.
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getUserNotes({
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchUserChart('/charts/user/notes',
        userId: userId, span: span, limit: limit, offset: offset);
  }

  /// Retrieves page view statistics for a specific user
  /// (`/api/charts/user/pv`).
  ///
  /// Response fields (nested):
  /// `upv.{user, visitor}`,
  /// `pv.{user, visitor}`
  ///
  /// Pass [userId] to identify the target user.
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getUserPv({
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchUserChart('/charts/user/pv',
        userId: userId, span: span, limit: limit, offset: offset);
  }

  /// Retrieves reaction statistics for a specific user
  /// (`/api/charts/user/reactions`).
  ///
  /// Response fields (nested):
  /// `local.{count}`,
  /// `remote.{count}`
  ///
  /// Pass [userId] to identify the target user.
  /// Pass [span] to set the aggregation period (`'day'` or `'hour'`).
  /// Use [limit] to cap the number of data points (1-500, default 30).
  /// Pass [offset] to shift the retrieval start position.
  Future<Map<String, dynamic>> getUserReactions({
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) {
    return _fetchUserChart('/charts/user/reactions',
        userId: userId, span: span, limit: limit, offset: offset);
  }

  /// 共通のチャートデータ取得処理（サーバー全体用）
  Future<Map<String, dynamic>> _fetchChart(
    String path, {
    required String span,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'span': span,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<Map<String, dynamic>>(
      path,
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res;
  }

  /// 共通のチャートデータ取得処理（ユーザー別用）
  Future<Map<String, dynamic>> _fetchUserChart(
    String path, {
    required String userId,
    required String span,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      'span': span,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<Map<String, dynamic>>(
      path,
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res;
  }
}
