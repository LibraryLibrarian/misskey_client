import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_following.dart';
import '../models/misskey_note.dart';
import '../models/misskey_user.dart';

/// ユーザー関連API
///
/// `users/show` / `users/followers` / `users/following` /
/// `users/notes` の各エンドポイントを提供する。
class UsersApi {
  const UsersApi({required this.http});

  final MisskeyHttp http;

  /// ユーザーIDを指定してユーザー情報を1件取得
  ///
  /// 複数ユーザーをまとめて取得する場合は [showMany] を使うこと。
  /// 認証は任意（未認証でも利用可能）。
  Future<MisskeyUser> showOneByUserId(String userId) async {
    final res = await http.send<Map<String, dynamic>>(
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
    final res = await http.send<Map<String, dynamic>>(
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
    final res = await http.send<List<dynamic>>(
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
    final res = await http.send<List<dynamic>>(
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
    final res = await http.send<List<dynamic>>(
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
