import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_following.dart';
import '../models/misskey_user.dart';
import 'following_requests_api.dart';

/// Provides following operations (`/api/following/*`).
///
/// Handles following, unfollowing, updating follow settings,
/// forcibly removing followers, and listing the authenticated user's
/// follows.
/// Use [requests] for follow request operations.
class FollowingApi {
  FollowingApi({required MisskeyHttp http})
    : _http = http,
      requests = FollowingRequestsApi(http: http);

  final MisskeyHttp _http;

  /// Provides follow request operations.
  final FollowingRequestsApi requests;

  /// Follows a user (`/api/following/create`).
  ///
  /// If the target user requires approval, a follow request is sent instead.
  /// Rate limit: 100 requests/hour.
  ///
  /// Pass [userId] as the ID of the user to follow. Set [withReplies] to
  /// include that user's replies in the timeline.
  ///
  /// Notable errors:
  /// - `NO_SUCH_USER`: The target user does not exist.
  /// - `FOLLOWEE_IS_YOURSELF`: Attempted to follow yourself.
  /// - `ALREADY_FOLLOWING`: Already following.
  /// - `BLOCKING`: Currently blocking the target user.
  /// - `BLOCKED`: Blocked by the target user.
  Future<MisskeyUser> create({
    required String userId,
    bool? withReplies,
  }) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/following/create',
      body: <String, dynamic>{'userId': userId, 'withReplies': ?withReplies},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Unfollows a user (`/api/following/delete`).
  ///
  /// Rate limit: 100 requests/hour. Pass [userId] as the ID of the user
  /// to unfollow.
  ///
  /// Notable errors:
  /// - `NO_SUCH_USER`: The target user does not exist.
  /// - `FOLLOWEE_IS_YOURSELF`: Specified yourself.
  /// - `NOT_FOLLOWING`: Not following the user.
  Future<MisskeyUser> delete({required String userId}) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/following/delete',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Updates follow settings (`/api/following/update`).
  ///
  /// Changes notification and reply display settings for an individual
  /// follow relationship. Rate limit: 100 requests/hour.
  ///
  /// Pass [userId] to identify the follow relationship to update.
  /// Use [notify] to control notifications (`normal` / `none`) and
  /// [withReplies] to toggle reply visibility in the timeline.
  ///
  /// Notable errors:
  /// - `NO_SUCH_USER`: The target user does not exist.
  /// - `FOLLOWEE_IS_YOURSELF`: Specified yourself.
  /// - `NOT_FOLLOWING`: Not following the user.
  Future<MisskeyUser> update({
    required String userId,
    String? notify,
    bool? withReplies,
  }) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/following/update',
      body: <String, dynamic>{
        'userId': userId,
        'notify': ?notify,
        'withReplies': ?withReplies,
      },
    );
    return MisskeyUser.fromJson(res);
  }

  /// Updates settings for all follows at once (`/api/following/update-all`).
  ///
  /// Rate limit: 10 requests/hour. Use [notify] to control notifications
  /// (`normal` / `none`) and [withReplies] to toggle reply visibility
  /// in the timeline for all followed users.
  Future<void> updateAll({String? notify, bool? withReplies}) =>
      _http.send<Object?>(
        '/following/update-all',
        body: <String, dynamic>{'notify': ?notify, 'withReplies': ?withReplies},
      );

  /// Forcibly removes a follower (`/api/following/invalidate`).
  ///
  /// Forcibly removes a user who is following the authenticated user.
  /// Rate limit: 100 requests/hour. Pass [userId] as the ID of the
  /// follower to remove.
  ///
  /// Notable errors:
  /// - `NO_SUCH_USER`: The target user does not exist.
  /// - `FOLLOWER_IS_YOURSELF`: Specified yourself.
  /// - `NOT_FOLLOWING`: The target user is not following you.
  Future<MisskeyUser> invalidate({required String userId}) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/following/invalidate',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Lists the users the authenticated user follows (`/api/following/list`).
  ///
  /// Set [notification] to `true` to return only follows whose new-note
  /// notifications are enabled (`notify: 'normal'` via [update] or
  /// [updateAll]). Each element includes [MisskeyFollowing.followee], whose
  /// `notify` field (`normal` / `none`) reflects that setting.
  ///
  /// [limit] is 1-100 (default 10).
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  ///
  /// Requires Misskey 2026.5.2 or later; older servers respond with a
  /// `MisskeyNotFoundException`. Use `MetaApi.isEndpointAvailable` to check
  /// support beforehand.
  Future<List<MisskeyFollowing>> list({
    bool? notification,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final res = await _http.send<List<dynamic>>(
      '/following/list',
      body: <String, dynamic>{
        'notification': ?notification,
        'limit': ?limit,
        'sinceId': ?sinceId,
        'untilId': ?untilId,
        'sinceDate': ?sinceDate,
        'untilDate': ?untilDate,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowing.fromJson)
        .toList();
  }
}
