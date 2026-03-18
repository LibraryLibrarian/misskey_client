import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_follow_request.dart';
import '../models/misskey_user.dart';

/// Provides follow request operations (`/api/following/requests/*`).
///
/// Handles accepting, rejecting received follow requests,
/// and viewing or cancelling sent requests.
class FollowingRequestsApi {
  const FollowingRequestsApi({required this.http});

  final MisskeyHttp http;

  /// Retrieves received follow requests (`/api/following/requests/list`).
  ///
  /// Use [limit] to cap the number of results (1-100, default 10).
  /// Pass [sinceId] or [untilId] to paginate by ID, or pass [sinceDate]
  /// or [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyFollowRequest>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/following/requests/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowRequest.fromJson)
        .toList();
  }

  /// Accepts a follow request (`/api/following/requests/accept`).
  ///
  /// Pass [userId] as the user ID of the request sender.
  ///
  /// Notable errors:
  /// - `NO_SUCH_USER`: The target user does not exist.
  /// - `NO_FOLLOW_REQUEST`: The follow request does not exist.
  Future<void> accept({required String userId}) => http.send<Object?>(
        '/following/requests/accept',
        body: <String, dynamic>{'userId': userId},
      );

  /// Rejects a follow request (`/api/following/requests/reject`).
  ///
  /// Pass [userId] as the user ID of the request sender.
  ///
  /// Notable errors:
  /// - `NO_SUCH_USER`: The target user does not exist.
  Future<void> reject({required String userId}) => http.send<Object?>(
        '/following/requests/reject',
        body: <String, dynamic>{'userId': userId},
      );

  /// Cancels a sent follow request (`/api/following/requests/cancel`).
  ///
  /// Pass [userId] as the user ID the request was sent to.
  ///
  /// Notable errors:
  /// - `NO_SUCH_USER`: The target user does not exist.
  /// - `FOLLOW_REQUEST_NOT_FOUND`: The follow request does not exist.
  Future<MisskeyUser> cancel({required String userId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/following/requests/cancel',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Retrieves sent follow requests (`/api/following/requests/sent`).
  ///
  /// Use [limit] to cap the number of results (1-100, default 10).
  /// Pass [sinceId] or [untilId] to paginate by ID, or pass [sinceDate]
  /// or [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyFollowRequest>> sent({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/following/requests/sent',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowRequest.fromJson)
        .toList();
  }
}
