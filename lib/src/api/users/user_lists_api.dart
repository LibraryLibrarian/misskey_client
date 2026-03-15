import '../../client/auth_mode.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/users/misskey_user_list.dart';
import '../../models/users/misskey_user_list_membership.dart';

/// ユーザーリスト関連API（`/api/users/lists/*`）
class UserListsApi {
  const UserListsApi({required this.http});

  final MisskeyHttp http;

  /// リスト一覧を取得
  ///
  /// [userId] を指定するとそのユーザーの公開リストを返す。
  /// 省略時は認証ユーザー自身のリストを返す。
  Future<List<MisskeyUserList>> list({String? userId}) async {
    final body = <String, dynamic>{
      if (userId != null) 'userId': userId,
    };
    final res = await http.send<List<dynamic>>(
      '/users/lists/list',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUserList.fromJson)
        .toList();
  }

  /// リストの詳細情報を取得
  ///
  /// [forPublic] を `true` にすると公開リストとして取得し、
  /// `likedCount` / `isLiked` が含まれる。
  Future<MisskeyUserList> show({
    required String listId,
    bool? forPublic,
  }) async {
    final body = <String, dynamic>{
      'listId': listId,
      if (forPublic != null) 'forPublic': forPublic,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/users/lists/show',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyUserList.fromJson(res);
  }

  /// リストを新規作成
  Future<MisskeyUserList> create({required String name}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/users/lists/create',
      body: <String, dynamic>{'name': name},
    );
    return MisskeyUserList.fromJson(res);
  }

  /// 公開リストをコピーして新規作成
  Future<MisskeyUserList> createFromPublic({
    required String name,
    required String listId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/users/lists/create-from-public',
      body: <String, dynamic>{'name': name, 'listId': listId},
    );
    return MisskeyUserList.fromJson(res);
  }

  /// リストを更新
  ///
  /// [name] と [isPublic] はいずれも省略可能。指定した項目のみ更新される。
  Future<MisskeyUserList> update({
    required String listId,
    String? name,
    bool? isPublic,
  }) async {
    final body = <String, dynamic>{
      'listId': listId,
      if (name != null) 'name': name,
      if (isPublic != null) 'isPublic': isPublic,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/users/lists/update',
      body: body,
    );
    return MisskeyUserList.fromJson(res);
  }

  /// リストを削除
  Future<void> delete({required String listId}) => http.send<Object?>(
        '/users/lists/delete',
        body: <String, dynamic>{'listId': listId},
      );

  /// リストにユーザーを追加
  Future<void> push({
    required String listId,
    required String userId,
  }) =>
      http.send<Object?>(
        '/users/lists/push',
        body: <String, dynamic>{'listId': listId, 'userId': userId},
      );

  /// リストからユーザーを削除
  Future<void> pull({
    required String listId,
    required String userId,
  }) =>
      http.send<Object?>(
        '/users/lists/pull',
        body: <String, dynamic>{'listId': listId, 'userId': userId},
      );

  /// リストのメンバーシップ一覧を取得
  ///
  /// [forPublic] を `true` にすると公開リストのメンバーを取得する。
  /// [limit] は1〜100（デフォルト: 30）。
  Future<List<MisskeyUserListMembership>> getMemberships({
    required String listId,
    bool? forPublic,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'listId': listId,
      if (forPublic != null) 'forPublic': forPublic,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/users/lists/get-memberships',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUserListMembership.fromJson)
        .toList();
  }

  /// メンバーシップを更新（リプライ含めるかの設定変更）
  Future<void> updateMembership({
    required String listId,
    required String userId,
    bool? withReplies,
  }) =>
      http.send<Object?>(
        '/users/lists/update-membership',
        body: <String, dynamic>{
          'listId': listId,
          'userId': userId,
          if (withReplies != null) 'withReplies': withReplies,
        },
      );

  /// リストをお気に入り登録
  Future<void> favorite({required String listId}) => http.send<Object?>(
        '/users/lists/favorite',
        body: <String, dynamic>{'listId': listId},
      );

  /// リストのお気に入りを解除
  Future<void> unfavorite({required String listId}) => http.send<Object?>(
        '/users/lists/unfavorite',
        body: <String, dynamic>{'listId': listId},
      );
}
