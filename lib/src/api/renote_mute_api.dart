import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_renote_muting.dart';

/// リノートミュート関連API（`/api/renote-mute/*`）
///
/// 特定ユーザーのリノートのみをミュートする機能を提供する。
/// 通常のミュートとは異なり、対象ユーザーの通常のノートは
/// タイムラインに表示される。
class RenoteMuteApi {
  const RenoteMuteApi({required this.http});

  final MisskeyHttp http;

  /// ユーザーのリノートをミュートする（`/api/renote-mute/create`）
  ///
  /// レート制限: 20回/時。
  ///
  /// - [userId]: リノートミュート対象のユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `MUTEE_IS_YOURSELF`: 自分自身を指定した
  /// - `ALREADY_MUTING`: 既にリノートミュート済み
  Future<void> create({required String userId}) => http.send<Object?>(
        '/renote-mute/create',
        body: <String, dynamic>{'userId': userId},
      );

  /// ユーザーのリノートミュートを解除する（`/api/renote-mute/delete`）
  ///
  /// - [userId]: リノートミュート解除対象のユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `MUTEE_IS_YOURSELF`: 自分自身を指定した
  /// - `NOT_MUTING`: リノートミュートしていない
  Future<void> delete({required String userId}) => http.send<Object?>(
        '/renote-mute/delete',
        body: <String, dynamic>{'userId': userId},
      );

  /// リノートミュート中のユーザー一覧を取得する（`/api/renote-mute/list`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト30）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyRenoteMuting>> list({
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
      '/renote-mute/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRenoteMuting.fromJson)
        .toList();
  }
}
