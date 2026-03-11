import '../client/misskey_http.dart';
import '../client/request_options.dart';

/// ユーザーのJSON表現
typedef UserJson = Map<String, dynamic>;

/// ユーザー関連API
///
/// `users/show` / `users/followers` / `users/following` /
/// `users/notes` の各エンドポイントを提供する。
class UsersApi {
  const UsersApi({required this.http});

  final MisskeyHttp http;

  /// ユーザー情報を1件取得
  ///
  /// [userId]・[username] のいずれかでユーザーを指定する。
  /// 複数ユーザーをまとめて取得する場合は `showMany` を使うこと。
  /// [host] を省略するとローカルユーザーとして検索する。
  /// 認証は任意（未認証でも利用可能）。
  Future<UserJson> showOne({
    String? userId,
    String? username,
    String? host,
  }) async {
    final body = <String, dynamic>{
      if (userId != null) 'userId': userId,
      if (username != null) 'username': username,
      if (host != null && host.isNotEmpty) 'host': host,
    };
    final res = await http.send<Map<dynamic, dynamic>>(
      '/users/show',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res.cast<String, dynamic>();
  }

  /// 複数ユーザーの情報をまとめて取得
  ///
  /// [userIds] に1件以上のユーザーIDを指定する。
  /// 認証は任意（未認証でも利用可能）。
  Future<List<UserJson>> showMany({required List<String> userIds}) async {
    final body = <String, dynamic>{'userIds': userIds};
    final res = await http.send<List<dynamic>>(
      '/users/show',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  /// フォロワー一覧を取得
  ///
  /// [userId] または [username]（必要に応じて [host]）でユーザーを指定する。
  /// [limit] は1〜100。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
  /// 認証は任意（未認証でも利用可能）。
  Future<List<UserJson>> followers({
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
      if (username != null) 'username': username,
      if (host != null && host.isNotEmpty) 'host': host,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/users/followers',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  /// フォロー一覧を取得
  ///
  /// [userId] または [username]（必要に応じて [host]）でユーザーを指定する。
  /// [limit] は1〜100。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
  /// 認証は任意（未認証でも利用可能）。
  Future<List<UserJson>> following({
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
      if (username != null) 'username': username,
      if (host != null && host.isNotEmpty) 'host': host,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/users/following',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  /// 指定ユーザーのノート一覧を取得する
  ///
  /// [userId] は必須。
  /// [limit] は1〜100。
  /// [sinceId] / [untilId] / [sinceDate] / [untilDate] でページングを行う。
  /// [withReplies] と [withFiles] は同時に `true` にできない（サーバー側制約）。
  /// [allowPartial] を `true` にするとキャッシュが不十分でも部分的な結果を返す。
  Future<List<UserJson>> notes({
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
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }
}
