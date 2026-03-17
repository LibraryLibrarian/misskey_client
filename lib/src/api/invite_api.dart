import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_invite_code.dart';

/// 招待コード関連API（`/api/invite/*`）
///
/// 招待制サーバーにおける招待コードの作成・削除・残数確認・一覧取得を提供する。
/// 全エンドポイントで認証必須かつ `canInvite` ロールポリシーが必要。
class InviteApi {
  const InviteApi({required this.http});

  final MisskeyHttp http;

  /// 招待コードを作成する（`/api/invite/create`）
  ///
  /// ロールポリシーの上限に基づき有効期限付きチケットを生成する。
  ///
  /// 主なエラー:
  /// - `EXCEEDED_LIMIT_OF_CREATE_INVITE_CODE`: 招待コード作成上限超過
  Future<MisskeyInviteCode> create() async {
    final res = await http.send<Map<String, dynamic>>(
      '/invite/create',
      body: const <String, dynamic>{},
    );
    return MisskeyInviteCode.fromJson(res);
  }

  /// 招待コードを削除する（`/api/invite/delete`）
  ///
  /// - [inviteId]: 削除対象の招待コードID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_INVITE_CODE`: 指定の招待コードが存在しない
  /// - `CAN_NOT_DELETE_INVITE_CODE`: この招待コードは削除できない
  /// - `ACCESS_DENIED`: 作成者でもモデレーターでもない
  Future<void> delete({required String inviteId}) => http.send<Object?>(
        '/invite/delete',
        body: <String, dynamic>{'inviteId': inviteId},
      );

  /// 残りの招待可能数を取得する（`/api/invite/limit`）
  ///
  /// 制限なしの場合は `null` を返す。
  Future<int?> limit() async {
    final res = await http.send<Map<String, dynamic>>(
      '/invite/limit',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res['remaining'] as int?;
  }

  /// 自分が作成した招待コード一覧を取得する（`/api/invite/list`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト30）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyInviteCode>> list({
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
      '/invite/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyInviteCode.fromJson)
        .toList();
  }
}
