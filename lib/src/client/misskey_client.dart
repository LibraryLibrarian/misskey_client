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
import '../api/flash_api.dart';
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

/// The main entry point for accessing all Misskey API domains.
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
    flash = FlashApi(http: http);
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

  /// The underlying HTTP client used for all API requests.
  final MisskeyHttp http;

  /// Account and profile management API.
  late final AccountApi account;

  /// Announcements API.
  late final AnnouncementsApi announcements;

  /// Antennas API.
  late final AntennasApi antennas;

  /// ActivityPub API.
  late final ApApi ap;

  /// User blocking API.
  late final BlockingApi blocking;

  /// Channels API.
  late final ChannelsApi channels;

  /// Statistics charts API.
  late final ChartsApi charts;

  /// Chat API.
  late final ChatApi chat;

  /// Clips API.
  late final ClipsApi clips;

  /// Drive (file storage) API.
  late final DriveApi drive;

  /// Federation API.
  late final FederationApi federation;

  /// Flash (Play) API.
  late final FlashApi flash;

  /// Following API.
  late final FollowingApi following;

  /// Gallery API.
  late final GalleryApi gallery;

  /// Hashtags API.
  late final HashtagsApi hashtags;

  /// Invite code API.
  late final InviteApi invite;

  /// Server metadata API.
  late final MetaApi meta;

  /// User muting API.
  late final MuteApi mute;

  /// Notes API.
  late final NotesApi notes;

  /// Notifications API.
  late final NotificationsApi notifications;

  /// Pages API.
  late final PagesApi pages;

  /// Renote muting API.
  late final RenoteMuteApi renoteMute;

  /// Roles API.
  late final RolesApi roles;

  /// Push notifications (Service Worker) API.
  late final SwApi sw;

  /// Users API.
  late final UsersApi users;
}
