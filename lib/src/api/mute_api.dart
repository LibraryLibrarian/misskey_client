import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_muting.dart';

/// ミュート関連API（`/api/mute/*`）
///
/// ユーザーのミュート・ミュート解除・ミュート一覧取得を提供する。
class MuteApi {
  const MuteApi({required this.http});

  final MisskeyHttp http;

  /// ユーザーをミュートする（`/api/mute/create`）
  ///
  /// レート制限: 20回/時。
  ///
  /// - [userId]: ミュート対象のユーザーID（必須）
  /// - [expiresAt]: ミュートの有効期限（Unixタイムスタンプms）。
  ///   `null`の場合は無期限ミュート。
  ///   過去の時刻を指定した場合は何も起きない。
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `MUTEE_IS_YOURSELF`: 自分自身をミュートしようとした
  /// - `ALREADY_MUTING`: 既にミュート済み
  Future<void> create({
    required String userId,
    int? expiresAt,
  }) =>
      http.send<Object?>(
        '/mute/create',
        body: <String, dynamic>{
          'userId': userId,
          if (expiresAt != null) 'expiresAt': expiresAt,
        },
      );

  /// ユーザーのミュートを解除する（`/api/mute/delete`）
  ///
  /// - [userId]: ミュート解除対象のユーザーID（必須）
  ///
  /// 主なエラー:
  /// - `NO_SUCH_USER`: 対象ユーザーが存在しない
  /// - `MUTEE_IS_YOURSELF`: 自分自身を指定した
  /// - `NOT_MUTING`: ミュートしていない
  Future<void> delete({required String userId}) => http.send<Object?>(
        '/mute/delete',
        body: <String, dynamic>{'userId': userId},
      );

  /// ミュート中のユーザー一覧を取得する（`/api/mute/list`）
  ///
  /// - [limit]: 取得件数 1〜100（デフォルト30）
  /// - [sinceId] / [untilId]: IDによるページング
  /// - [sinceDate] / [untilDate]: Unixタイムスタンプ（ms）によるページング
  Future<List<MisskeyMuting>> list({
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
      '/mute/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyMuting.fromJson)
        .toList();
  }
}
