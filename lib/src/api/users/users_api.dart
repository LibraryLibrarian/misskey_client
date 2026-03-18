import '../../client/auth_mode.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/gallery/misskey_gallery_post.dart';
import '../../models/misskey_clip.dart';
import '../../models/misskey_following.dart';
import '../../models/misskey_note.dart';
import '../../models/misskey_note_reaction.dart';
import '../../models/misskey_user.dart';
import '../../models/users/misskey_achievement.dart';
import '../../models/users/misskey_birthday_user.dart';
import '../../models/users/misskey_flash.dart';
import '../../models/users/misskey_frequent_user.dart';
import '../../models/users/misskey_page.dart';
import '../../models/users/misskey_user_relation.dart';
import 'user_lists_api.dart';

/// Provides user-related API endpoints.
///
/// Covers `users/*` endpoints.
/// Use [lists] for list operations.
class UsersApi {
  UsersApi({required MisskeyHttp http})
      : _http = http,
        lists = UserListsApi(http: http);

  final MisskeyHttp _http;

  /// User list API.
  final UserListsApi lists;

  /// Fetches a list of users (`/api/users`).
  ///
  /// Returns explorable (`isExplorable`) and non-suspended users.
  /// No authentication required (when authenticated, muted/blocked users are
  /// excluded). Uses offset-based pagination via [offset] (default: 0).
  /// Use [limit] to cap results (1-100, default: 10), [sort] to order them
  /// (`+follower`/`-follower`/`+createdAt`/`-createdAt`/`+updatedAt`/
  /// `-updatedAt`), [state] to filter by user state (`all`/`alive`, default:
  /// `all`), [origin] to filter by federation (`combined`/`local`/`remote`,
  /// default: `local`), and [hostname] to filter by remote hostname.
  Future<List<MisskeyUser>> list({
    int? limit,
    int? offset,
    String? sort,
    String? state,
    String? origin,
    String? hostname,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (sort != null) 'sort': sort,
      if (state != null) 'state': state,
      if (origin != null) 'origin': origin,
      if (hostname != null) 'hostname': hostname,
    };
    final res = await _http.send<List<dynamic>>(
      '/users',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// Fetches a single user by user ID.
  ///
  /// Use [showMany] to retrieve multiple users at once.
  /// Authentication optional (works without authentication).
  Future<MisskeyUser> showOneByUserId(String userId) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/users/show',
      body: <String, dynamic>{'userId': userId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyUser.fromJson(res);
  }

  /// Fetches a single user by username.
  ///
  /// Omit [host] to search for a local user.
  /// Use [showMany] to retrieve multiple users at once.
  /// Authentication optional (works without authentication).
  Future<MisskeyUser> showOneByUsername(
    String username, {
    String? host,
  }) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/users/show',
      body: <String, dynamic>{
        'username': username,
        'host': host?.isNotEmpty == true ? host : null,
      },
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyUser.fromJson(res);
  }

  /// Fetches multiple users at once.
  ///
  /// Specify one or more user IDs in [userIds].
  /// Authentication optional (works without authentication).
  Future<List<MisskeyUser>> showMany({required List<String> userIds}) async {
    final body = <String, dynamic>{'userIds': userIds};
    final res = await _http.send<List<dynamic>>(
      '/users/show',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// Fetches the followers of a user by user ID.
  ///
  /// [limit] is 1-100.
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  /// Authentication optional (works without authentication).
  Future<List<MisskeyFollowing>> followersByUserId(
    String userId, {
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) =>
      _fetchFollowList(
        path: '/users/followers',
        userId: userId,
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
      );

  /// Fetches the followers of a user by username.
  ///
  /// Omit [host] to search for a local user.
  /// [limit] is 1-100.
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  /// Authentication optional (works without authentication).
  Future<List<MisskeyFollowing>> followersByUsername(
    String username, {
    String? host,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) =>
      _fetchFollowList(
        path: '/users/followers',
        username: username,
        host: host,
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
      );

  /// Fetches the following list of a user by user ID.
  ///
  /// [limit] is 1-100.
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  /// Authentication optional (works without authentication).
  Future<List<MisskeyFollowing>> followingByUserId(
    String userId, {
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) =>
      _fetchFollowList(
        path: '/users/following',
        userId: userId,
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
      );

  /// Fetches the following list of a user by username.
  ///
  /// Omit [host] to search for a local user.
  /// [limit] is 1-100.
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  /// Authentication optional (works without authentication).
  Future<List<MisskeyFollowing>> followingByUsername(
    String username, {
    String? host,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) =>
      _fetchFollowList(
        path: '/users/following',
        username: username,
        host: host,
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
      );

  /// Fetches notes by a user.
  ///
  /// [userId] is required.
  /// [limit] is 1-100.
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  /// [withReplies] and [withFiles] cannot both be `true` (server constraint).
  /// Set [allowPartial] to `true` to return partial results
  /// even if the cache is insufficient.
  Future<List<MisskeyNote>> notes({
    required String userId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? withReplies,
    bool? withRenotes,
    bool? withChannelNotes,
    bool? withFiles,
    bool? allowPartial,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (withReplies != null) 'withReplies': withReplies,
      if (withRenotes != null) 'withRenotes': withRenotes,
      if (withChannelNotes != null) 'withChannelNotes': withChannelNotes,
      if (withFiles != null) 'withFiles': withFiles,
      if (allowPartial != null) 'allowPartial': allowPartial,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/notes',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches a user's achievements.
  ///
  /// No authentication required. No pagination.
  Future<List<MisskeyAchievement>> achievements({
    required String userId,
  }) async {
    final res = await _http.send<List<dynamic>>(
      '/users/achievements',
      body: <String, dynamic>{'userId': userId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAchievement.fromJson)
        .toList();
  }

  /// Fetches a user's public clips.
  ///
  /// [limit] is 1-100 (default: 10).
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  Future<List<MisskeyClip>> clips({
    required String userId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/clips',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyClip.fromJson)
        .toList();
  }

  /// Fetches a user's featured notes.
  ///
  /// [limit] is 1-100 (default: 10).
  /// Pagination supports [untilId] only.
  Future<List<MisskeyNote>> featuredNotes({
    required String userId,
    int? limit,
    String? untilId,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      if (limit != null) 'limit': limit,
      if (untilId != null) 'untilId': untilId,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/featured-notes',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches a user's public Flash (Play) posts.
  ///
  /// [limit] is 1-100 (default: 10).
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  Future<List<MisskeyFlash>> flashs({
    required String userId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/flashs',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFlash.fromJson)
        .toList();
  }

  /// Fetches users that a user frequently replies to.
  ///
  /// [limit] is 1-100 (default: 10).
  /// The response is a list of `{ user, weight }` where
  /// weight is a normalized frequency between 0.0 and 1.0.
  Future<List<MisskeyFrequentUser>> getFrequentlyRepliedUsers({
    required String userId,
    int? limit,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      if (limit != null) 'limit': limit,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/get-frequently-replied-users',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFrequentUser.fromJson)
        .toList();
  }

  /// Fetches a user's public pages.
  ///
  /// [limit] is 1-100 (default: 10).
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  Future<List<MisskeyPage>> pages({
    required String userId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/pages',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyPage.fromJson)
        .toList();
  }

  /// Fetches a user's reactions.
  ///
  /// Only available if the target user has public reactions enabled.
  /// When authenticated, the user or a moderator can access private reactions.
  /// [limit] is 1-100 (default: 10).
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  Future<List<MisskeyNoteReaction>> reactions({
    required String userId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/reactions',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNoteReaction.fromJson)
        .toList();
  }

  /// Fetches recommended users.
  ///
  /// Authentication required.
  /// [limit] is 1-100 (default: 10).
  /// Paginate with [offset] (default: 0).
  Future<List<MisskeyUser>> recommendation({
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/recommendation',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// Fetches the relationship with a single user.
  ///
  /// Authentication required.
  Future<MisskeyUserRelation> relation({required String userId}) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/users/relation',
      body: <String, dynamic>{'userId': userId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyUserRelation.fromJson(res);
  }

  /// Fetches relationships with multiple users at once.
  ///
  /// Authentication required.
  Future<List<MisskeyUserRelation>> relationMany({
    required List<String> userIds,
  }) async {
    final res = await _http.send<List<dynamic>>(
      '/users/relation',
      body: <String, dynamic>{'userId': userIds},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUserRelation.fromJson)
        .toList();
  }

  /// Reports a user.
  ///
  /// Authentication required.
  /// [comment] must be 1-2048 characters.
  Future<void> reportAbuse({
    required String userId,
    required String comment,
  }) =>
      _http.send<Object?>(
        '/users/report-abuse',
        body: <String, dynamic>{'userId': userId, 'comment': comment},
      );

  /// Searches for users.
  ///
  /// [origin] is `local` / `remote` / `combined` (default: `combined`).
  /// Set [detail] to `false` to return UserLite format (default: `true`).
  /// [limit] is 1-100 (default: 10).
  /// Paginate with [offset] (default: 0).
  Future<List<MisskeyUser>> search({
    required String query,
    int? offset,
    int? limit,
    String? origin,
    bool? detail,
  }) async {
    final body = <String, dynamic>{
      'query': query,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
      if (origin != null) 'origin': origin,
      if (detail != null) 'detail': detail,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/search',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// Searches for users by username and host.
  ///
  /// At least one of [username] or [host] is required.
  /// Set [detail] to `false` to return UserLite format (default: `true`).
  /// [limit] is 1-100 (default: 10).
  Future<List<MisskeyUser>> searchByUsernameAndHost({
    String? username,
    String? host,
    int? limit,
    bool? detail,
  }) async {
    final body = <String, dynamic>{
      if (username != null) 'username': username,
      if (host != null) 'host': host,
      if (limit != null) 'limit': limit,
      if (detail != null) 'detail': detail,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/search-by-username-and-host',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// Updates the user memo.
  ///
  /// Authentication required.
  /// Pass `null` to [memo] to delete the memo.
  Future<void> updateMemo({
    required String userId,
    required String? memo,
  }) =>
      _http.send<Object?>(
        '/users/update-memo',
        body: <String, dynamic>{'userId': userId, 'memo': memo},
      );

  /// Fetches followed users by birthday (single date).
  ///
  /// Authentication required.
  /// [month] is 1-12, [day] is 1-31.
  /// [limit] is 1-100 (default: 10).
  /// Paginate with [offset] (default: 0).
  Future<List<MisskeyBirthdayUser>> getFollowingUsersByBirthday({
    required int month,
    required int day,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'birthday': {'month': month, 'day': day},
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/get-following-users-by-birthday',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyBirthdayUser.fromJson)
        .toList();
  }

  /// Fetches followed users by birthday range.
  ///
  /// Authentication required.
  /// Specify start and end dates by month and day.
  /// [limit] is 1-100 (default: 10).
  /// Paginate with [offset] (default: 0).
  Future<List<MisskeyBirthdayUser>> getFollowingUsersByBirthdayRange({
    required int beginMonth,
    required int beginDay,
    required int endMonth,
    required int endDay,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'birthday': {
        'begin': {'month': beginMonth, 'day': beginDay},
        'end': {'month': endMonth, 'day': endDay},
      },
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/get-following-users-by-birthday',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyBirthdayUser.fromJson)
        .toList();
  }

  /// Fetches a user's gallery posts.
  ///
  /// [limit] is 1-100 (default: 10).
  /// Paginate with [sinceId] / [untilId] / [sinceDate] / [untilDate].
  Future<List<MisskeyGalleryPost>> galleryPosts({
    required String userId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'userId': userId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await _http.send<List<dynamic>>(
      '/users/gallery/posts',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyGalleryPost.fromJson)
        .toList();
  }

  /// フォロワー / フォロー一覧取得の共通ヘルパー
  Future<List<MisskeyFollowing>> _fetchFollowList({
    required String path,
    String? userId,
    String? username,
    String? host,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (userId != null) 'userId': userId,
      if (username != null) ...{
        'username': username,
        'host': host?.isNotEmpty == true ? host : null,
      },
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await _http.send<List<dynamic>>(
      path,
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFollowing.fromJson)
        .toList();
  }
}
