import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_blocking.dart';
import '../models/misskey_user.dart';

/// ブロック関連API（`/api/blocking/*`）
///
/// ユーザーのブロック・ブロック解除・ブロック一覧取得を提供する。
class BlockingApi {
  const BlockingApi({required this.http});

  final MisskeyHttp http;

  /// ユーザーをブロックする（`/api/blocking/create`）
  ///
  /// ブロックすると相互のフォロー関係が解除される。
  /// レート制限: 20回/時。
  ///
  /// - [userId]: ブロック対象のユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `BLOCKEE_IS_YOURSELF`: 自分自身をブロックしようとした
  /// - `ALREADY_BLOCKING`: 既にブロック済み
  Future<MisskeyUser> create({required String userId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/blocking/create',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// ユーザーのブロックを解除する（`/api/blocking/delete`）
  ///
  /// レート制限: 100回/時。
  ///
  /// - [userId]: ブロック解除対象のユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `BLOCKEE_IS_YOURSELF`: 自分自身を指定した
  /// - `NOT_BLOCKING`: ブロックしていない
  Future<MisskeyUser> delete({required String userId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/blocking/delete',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// ブロック中のユーザー一覧を取得する（`/api/blocking/list`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト30）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyBlocking>> list({
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
      '/blocking/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyBlocking.fromJson)
        .toList();
  }
}
