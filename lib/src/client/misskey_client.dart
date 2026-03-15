import '../api/account/account_api.dart';
import '../api/antennas_api.dart';
import '../api/blocking_api.dart';
import '../api/channels/channels_api.dart';
import '../api/chat/chat_api.dart';
import '../api/clips_api.dart';
import '../api/drive/drive_api.dart';
import '../api/following_api.dart';
import '../api/meta_api.dart';
import '../api/mute_api.dart';
import '../api/notes_api.dart';
import '../api/notifications_api.dart';
import '../api/renote_mute_api.dart';
import '../api/users/users_api.dart';
import '../logging/logger.dart';
import 'misskey_client_config.dart';
import 'misskey_http.dart';
import 'token_provider.dart';

/// Misskey API クライアント。
///
/// 全APIドメインへのアクセスを提供するメインエントリーポイント
class MisskeyClient {
  MisskeyClient({
    required MisskeyClientConfig config,
    TokenProvider? tokenProvider,
    Logger? logger,
  }) : http = MisskeyHttp(
          config: config,
          tokenProvider: tokenProvider,
          logger: logger,
        ) {
    account = AccountApi(http: http);
    antennas = AntennasApi(http: http);
    blocking = BlockingApi(http: http);
    channels = ChannelsApi(http: http);
    chat = ChatApi(http: http);
    clips = ClipsApi(http: http);
    drive = DriveApi(http: http);
    following = FollowingApi(http: http);
    meta = MetaApi(http: http);
    mute = MuteApi(http: http);
    notes = NotesApi(http: http);
    notifications = NotificationsApi(http: http);
    renoteMute = RenoteMuteApi(http: http);
    users = UsersApi(http: http);
  }

  final MisskeyHttp http;

  late final AccountApi account;
  late final AntennasApi antennas;
  late final BlockingApi blocking;
  late final ChannelsApi channels;
  late final ChatApi chat;
  late final ClipsApi clips;
  late final DriveApi drive;
  late final FollowingApi following;
  late final MetaApi meta;
  late final MuteApi mute;
  late final NotesApi notes;
  late final NotificationsApi notifications;
  late final RenoteMuteApi renoteMute;
  late final UsersApi users;
}
