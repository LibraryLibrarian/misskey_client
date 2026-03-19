import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/misskey_channel.dart';

/// Provides channel mute APIs.
///
/// Offers endpoints under `channels/mute/*`.
class ChannelMuteApi {
  const ChannelMuteApi({required this.http});

  final MisskeyHttp http;

  /// Mutes a channel.
  ///
  /// Specify the target channel with [channelId].
  /// Set [expiresAt] to a Unix epoch timestamp (ms) for a time-limited mute.
  /// If `null`, the mute is indefinite.
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

  /// Unmutes a channel.
  ///
  /// Specify the target channel with [channelId].
  Future<void> delete({required String channelId}) => http.send<Object?>(
        '/channels/mute/delete',
        body: <String, dynamic>{'channelId': channelId},
      );

  /// Retrieves the list of muted channels.
  ///
  /// Takes no parameters. Returns all channels muted by the authenticated
  /// user.
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
