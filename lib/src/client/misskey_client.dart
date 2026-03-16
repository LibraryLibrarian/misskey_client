import '../api/account/account_api.dart';
import '../api/announcements_api.dart';
import '../api/antennas_api.dart';
import '../api/ap_api.dart';
import '../api/blocking_api.dart';
import '../api/channels/channels_api.dart';
import '../api/charts_api.dart';
import '../api/chat/chat_api.dart';
import '../api/clips_api.dart';
import '../api/drive/drive_api.dart';
import '../api/federation_api.dart';
import '../api/following_api.dart';
import '../api/gallery/gallery_api.dart';
import '../api/hashtags_api.dart';
import '../api/invite_api.dart';
import '../api/meta_api.dart';
import '../api/mute_api.dart';
import '../api/notes_api.dart';
import '../api/notifications_api.dart';
import '../api/pages_api.dart';
import '../api/renote_mute_api.dart';
import '../api/roles_api.dart';
import '../api/sw_api.dart';
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
    announcements = AnnouncementsApi(http: http);
    antennas = AntennasApi(http: http);
    ap = ApApi(http: http);
    blocking = BlockingApi(http: http);
    channels = ChannelsApi(http: http);
    charts = ChartsApi(http: http);
    chat = ChatApi(http: http);
    clips = ClipsApi(http: http);
    drive = DriveApi(http: http);
    federation = FederationApi(http: http);
    following = FollowingApi(http: http);
    gallery = GalleryApi(http: http);
    hashtags = HashtagsApi(http: http);
    invite = InviteApi(http: http);
    meta = MetaApi(http: http);
    mute = MuteApi(http: http);
    notes = NotesApi(http: http);
    notifications = NotificationsApi(http: http);
    pages = PagesApi(http: http);
    renoteMute = RenoteMuteApi(http: http);
    roles = RolesApi(http: http);
    sw = SwApi(http: http);
    users = UsersApi(http: http);
  }

  final MisskeyHttp http;

  late final AccountApi account;

  /// お知らせ関連API
  late final AnnouncementsApi announcements;

  late final AntennasApi antennas;

  /// ActivityPub関連API
  late final ApApi ap;

  late final BlockingApi blocking;
  late final ChannelsApi channels;

  /// 統計チャート関連API
  late final ChartsApi charts;

  late final ChatApi chat;
  late final ClipsApi clips;
  late final DriveApi drive;
  late final FederationApi federation;
  late final FollowingApi following;

  /// ギャラリー関連API
  late final GalleryApi gallery;

  late final HashtagsApi hashtags;

  /// 招待コード関連API
  late final InviteApi invite;

  late final MetaApi meta;
  late final MuteApi mute;
  late final NotesApi notes;
  late final NotificationsApi notifications;

  /// ページ関連API
  late final PagesApi pages;

  late final RenoteMuteApi renoteMute;
  late final RolesApi roles;

  /// プッシュ通知関連API
  late final SwApi sw;

  late final UsersApi users;
}
