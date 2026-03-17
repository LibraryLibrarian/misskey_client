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

/// ユーザー関連API
///
/// `users/*` の各エンドポイントを提供する。
/// リスト操作は [lists] サブAPIを使用する。
class UsersApi {
  UsersApi({required MisskeyHttp http})
      : _http = http,
        lists = UserListsApi(http: http);

  final MisskeyHttp _http;

  /// ユーザーリスト関連API
  final UserListsApi lists;

  /// ユーザー一覧を取得する（`/api/users`）
  ///
  /// 探索可能（`isExplorable`）かつ凍結されていないユーザーを返す。
  /// 認証不要（認証時はミュート・ブロックユーザーを除外）。
  /// offsetベースのページネーション。
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト: 10）
  /// - [offset]: スキップ件数（デフォルト: 0）
  /// - [sort]: ソート順（`+follower`/`-follower`/`+createdAt`/`-createdAt`/
  ///   `+updatedAt`/`-updatedAt`）
  /// - [state]: ユーザー状態フィルタ（`all`/`alive`、デフォルト: `all`）
  /// - [origin]: 連合フィルタ（`combined`/`local`/`remote`、デフォルト: `local`）
  /// - [hostname]: リモートホスト名で絞り込む（`null`でローカル）
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

  /// ユーザーIDを指定してユーザー情報を1件取得
  ///
  /// 複数ユーザーをまとめて取得する場合は [showMany] を使うこと。
  /// 認証は任意（未認証でも利用可能）。
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

  /// ユーザー名を指定してユーザー情報を1件取得
  ///
  /// [host] を省略するとローカルユーザーとして検索する。
  /// 複数ユーザーをまとめて取得する場合は [showMany] を使うこと。
  /// 認証は任意（未認証でも利用可能）。
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

  /// 複数ユーザーの情報をまとめて取得
  ///
  /// [userIds] に1件以上のユーザーIDを指定する。
  /// 認証は任意（未認証でも利用可能）。
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

  /// ユーザーIDを指定してフォロワー一覧を取得
  ///
  /// [limit] は1〜100。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
  /// 認証は任意（未認証でも利用可能）。
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

  /// ユーザー名を指定してフォロワー一覧を取得
  ///
  /// [host] を省略するとローカルユーザーとして検索する。
  /// [limit] は1〜100。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
  /// 認証は任意（未認証でも利用可能）。
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

  /// ユーザーIDを指定してフォロー一覧を取得
  ///
  /// [limit] は1〜100。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
  /// 認証は任意（未認証でも利用可能）。
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

  /// ユーザー名を指定してフォロー一覧を取得
  ///
  /// [host] を省略するとローカルユーザーとして検索する。
  /// [limit] は1〜100。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
  /// 認証は任意（未認証でも利用可能）。
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

  /// 指定ユーザーのノート一覧を取得する
  ///
  /// [userId] は必須。
  /// [limit] は1〜100。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
  /// [withReplies] と [withFiles] は同時に `true` にできない（サーバー側制約）。
  /// [allowPartial] を `true` にするとキャッシュが不十分でも部分的な結果を返す。
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

  /// ユーザーの実績一覧を取得
  ///
  /// 認証不要。ページネーションなし。
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

  /// ユーザーの公開クリップ一覧を取得
  ///
  /// [limit] は1〜100（デフォルト: 10）。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
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

  /// ユーザーの注目ノートを取得
  ///
  /// [limit] は1〜100（デフォルト: 10）。
  /// ページングは [untilId] のみ対応。
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

  /// ユーザーの公開Flash(Play)一覧を取得
  ///
  /// [limit] は1〜100（デフォルト: 10）。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
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

  /// よくリプライするユーザー一覧を取得
  ///
  /// [limit] は1〜100（デフォルト: 10）。
  /// レスポンスは `{ user, weight }` のリストで、
  /// weight は0.0〜1.0の正規化された頻度。
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

  /// ユーザーの公開ページ一覧を取得
  ///
  /// [limit] は1〜100（デフォルト: 10）。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
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

  /// ユーザーのリアクション一覧を取得
  ///
  /// 対象ユーザーがリアクションを公開設定にしている場合のみ取得可能。
  /// 認証済みの場合、本人またはモデレータであれば非公開でも取得可。
  /// [limit] は1〜100（デフォルト: 10）。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
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

  /// おすすめユーザー一覧を取得
  ///
  /// 認証必須。
  /// [limit] は1〜100（デフォルト: 10）。
  /// [offset] でページングを行う（デフォルト: 0）。
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

  /// 指定ユーザーとの関係情報を1件取得
  ///
  /// 認証必須。
  Future<MisskeyUserRelation> relation({required String userId}) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/users/relation',
      body: <String, dynamic>{'userId': userId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyUserRelation.fromJson(res);
  }

  /// 複数ユーザーとの関係情報をまとめて取得
  ///
  /// 認証必須。
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

  /// ユーザーを通報する
  ///
  /// 認証必須。
  /// [comment] は1〜2048文字。
  Future<void> reportAbuse({
    required String userId,
    required String comment,
  }) =>
      _http.send<Object?>(
        '/users/report-abuse',
        body: <String, dynamic>{'userId': userId, 'comment': comment},
      );

  /// ユーザーを検索する
  ///
  /// [origin] は `local` / `remote` / `combined`（デフォルト: `combined`）。
  /// [detail] を `false` にするとUserLite形式で返す（デフォルト: `true`）。
  /// [limit] は1〜100（デフォルト: 10）。
  /// [offset] でページングを行う（デフォルト: 0）。
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

  /// ユーザー名・ホスト名でユーザーを検索する
  ///
  /// [username] または [host] のいずれか一方は必須。
  /// [detail] を `false` にするとUserLite形式で返す（デフォルト: `true`）。
  /// [limit] は1〜100（デフォルト: 10）。
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

  /// ユーザーメモを更新する
  ///
  /// 認証必須。
  /// [memo] に `null` を渡すとメモを削除する。
  Future<void> updateMemo({
    required String userId,
    required String? memo,
  }) =>
      _http.send<Object?>(
        '/users/update-memo',
        body: <String, dynamic>{'userId': userId, 'memo': memo},
      );

  /// 誕生日でフォロー中ユーザーを取得する（単一日付指定）
  ///
  /// 認証必須。
  /// [month] は1〜12、[day] は1〜31。
  /// [limit] は1〜100（デフォルト: 10）。
  /// [offset] でページングを行う（デフォルト: 0）。
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

  /// 誕生日の期間指定でフォロー中ユーザーを取得する
  ///
  /// 認証必須。
  /// 開始日と終了日をそれぞれ月・日で指定する。
  /// [limit] は1〜100（デフォルト: 10）。
  /// [offset] でページングを行う（デフォルト: 0）。
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

  /// ユーザーのギャラリー投稿一覧を取得
  ///
  /// [limit] は1〜100（デフォルト: 10）。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
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
