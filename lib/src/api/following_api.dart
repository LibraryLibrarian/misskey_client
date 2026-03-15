import '../client/misskey_http.dart';
import '../models/misskey_user.dart';
import 'following_requests_api.dart';

/// フォロー関連API（`/api/following/*`）
///
/// ユーザーのフォロー・アンフォロー・フォロー設定の更新、
/// およびフォロワーの強制解除を提供する。
/// フォローリクエスト操作は [requests] サブAPIを使用する。
class FollowingApi {
  FollowingApi({required MisskeyHttp http})
      : _http = http,
        requests = FollowingRequestsApi(http: http);

  final MisskeyHttp _http;

  /// フォローリクエスト関連API
  final FollowingRequestsApi requests;

  /// ユーザーをフォローする（`/api/following/create`）
  ///
  /// 対象ユーザーが承認制の場合はフォローリクエストが送信される。
  /// レート制限: 100回/時。
  ///
  /// - [userId]: フォロー対象のユーザーID（必須）
  /// - [withReplies]: リプライをタイムラインに含めるか
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `FOLLOWEE_IS_YOURSELF`: 自分自身をフォローしようとした
  /// - `ALREADY_FOLLOWING`: 既にフォロー済み
  /// - `BLOCKING`: 対象ユーザーをブロック中
  /// - `BLOCKED`: 対象ユーザーからブロックされている
  Future<MisskeyUser> create({
    required String userId,
    bool? withReplies,
  }) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/following/create',
      body: <String, dynamic>{
        'userId': userId,
        if (withReplies != null) 'withReplies': withReplies,
      },
    );
    return MisskeyUser.fromJson(res);
  }

  /// ユーザーのフォローを解除する（`/api/following/delete`）
  ///
  /// レート制限: 100回/時。
  ///
  /// - [userId]: フォロー解除対象のユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `FOLLOWEE_IS_YOURSELF`: 自分自身を指定した
  /// - `NOT_FOLLOWING`: フォローしていない
  Future<MisskeyUser> delete({required String userId}) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/following/delete',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// フォロー設定を更新する（`/api/following/update`）
  ///
  /// 通知設定やリプライ表示設定を個別のフォロー関係に対して変更する。
  /// レート制限: 100回/時。
  ///
  /// - [userId]: 対象ユーザーID（必須）
  /// - [notify]: 通知設定（`normal` / `none`）
  /// - [withReplies]: リプライをタイムラインに含めるか
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `FOLLOWEE_IS_YOURSELF`: 自分自身を指定した
  /// - `NOT_FOLLOWING`: フォローしていない
  Future<MisskeyUser> update({
    required String userId,
    String? notify,
    bool? withReplies,
  }) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/following/update',
      body: <String, dynamic>{
        'userId': userId,
        if (notify != null) 'notify': notify,
        if (withReplies != null) 'withReplies': withReplies,
      },
    );
    return MisskeyUser.fromJson(res);
  }

  /// 全フォローの設定を一括更新する（`/api/following/update-all`）
  ///
  /// レート制限: 10回/時。
  ///
  /// - [notify]: 通知設定（`normal` / `none`）
  /// - [withReplies]: リプライをタイムラインに含めるか
  Future<void> updateAll({
    String? notify,
    bool? withReplies,
  }) =>
      _http.send<Object?>(
        '/following/update-all',
        body: <String, dynamic>{
          if (notify != null) 'notify': notify,
          if (withReplies != null) 'withReplies': withReplies,
        },
      );

  /// フォロワーを強制解除する（`/api/following/invalidate`）
  ///
  /// 自分をフォローしているユーザーのフォローを強制的に解除する。
  /// レート制限: 100回/時。
  ///
  /// - [userId]: 強制解除対象のフォロワーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `FOLLOWER_IS_YOURSELF`: 自分自身を指定した
  /// - `NOT_FOLLOWING`: 対象ユーザーにフォローされていない
  Future<MisskeyUser> invalidate({required String userId}) async {
    final res = await _http.send<Map<String, dynamic>>(
      '/following/invalidate',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }
}
