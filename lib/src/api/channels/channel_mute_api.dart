import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/misskey_channel.dart';

/// チャンネルミュート関連API
///
/// `channels/mute/*` の各エンドポイントを提供する。
class ChannelMuteApi {
  const ChannelMuteApi({required this.http});

  final MisskeyHttp http;

  /// チャンネルをミュート
  ///
  /// [channelId] で対象チャンネルを指定する。
  /// [expiresAt] にUnixエポックタイムスタンプ（ms）を指定すると
  /// その時刻まで有効な期限付きミュートになる。
  /// `null`の場合は無期限ミュートとなる。
  Future<void> create({
    required String channelId,
    int? expiresAt,
  }) =>
      http.send<Object?>(
        '/channels/mute/create',
        body: <String, dynamic>{
          'channelId': channelId,
          if (expiresAt != null) 'expiresAt': expiresAt,
        },
      );

  /// チャンネルのミュートを解除
  ///
  /// [channelId] で対象チャンネルを指定する。
  Future<void> delete({required String channelId}) => http.send<Object?>(
        '/channels/mute/delete',
        body: <String, dynamic>{'channelId': channelId},
      );

  /// ミュート中のチャンネル一覧を取得
  ///
  /// パラメータなし。認証ユーザーがミュートしているチャンネルをすべて返す。
  Future<List<MisskeyChannel>> list() async {
    final res = await http.send<List<dynamic>>(
      '/channels/mute/list',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyChannel.fromJson)
        .toList();
  }
}
