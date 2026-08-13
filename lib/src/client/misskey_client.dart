import 'package:dio/dio.dart';

import '../api/account/account_api.dart';
import '../api/admin/admin_abuse_reports_api.dart';
import '../api/admin/admin_accounts_api.dart';
import '../api/admin/admin_ad_api.dart';
import '../api/admin/admin_announcements_api.dart';
import '../api/admin/admin_api.dart';
import '../api/admin/admin_avatar_decorations_api.dart';
import '../api/admin/admin_captcha_api.dart';
import '../api/admin/admin_drive_api.dart';
import '../api/admin/admin_emoji_api.dart';
import '../api/admin/admin_federation_api.dart';
import '../api/admin/admin_invite_api.dart';
import '../api/admin/admin_queue_api.dart';
import '../api/admin/admin_relays_api.dart';
import '../api/admin/admin_roles_api.dart';
import '../api/admin/admin_system_webhook_api.dart';
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
  /// Creates a [MisskeyClient].
  ///
  /// Pass [httpClientAdapter] to customize the underlying HTTP transport
  /// (e.g. trusting a private CA in test environments, or proxying).
  MisskeyClient({
    required MisskeyClientConfig config,
    TokenProvider? tokenProvider,
    Logger? logger,
    HttpClientAdapter? httpClientAdapter,
  }) : http = MisskeyHttp(
         config: config,
         tokenProvider: tokenProvider,
         logger: logger,
         httpClientAdapter: httpClientAdapter,
       ) {
    account = AccountApi(http: http);
    admin = AdminApi(http: http);
    adminAbuseReports = AdminAbuseReportsApi(http: http);
    adminAccounts = AdminAccountsApi(http: http);
    adminAd = AdminAdApi(http: http);
    adminAnnouncements = AdminAnnouncementsApi(http: http);
    adminAvatarDecorations = AdminAvatarDecorationsApi(http: http);
    adminCaptcha = AdminCaptchaApi(http: http);
    adminDrive = AdminDriveApi(http: http);
    adminEmoji = AdminEmojiApi(http: http);
    adminFederation = AdminFederationApi(http: http);
    adminInvite = AdminInviteApi(http: http);
    adminQueue = AdminQueueApi(http: http);
    adminRelays = AdminRelaysApi(http: http);
    adminRoles = AdminRolesApi(http: http);
    adminSystemWebhook = AdminSystemWebhookApi(http: http);
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

  /// Core admin API (instance settings, user moderation).
  late final AdminApi admin;

  /// Admin abuse report management API.
  late final AdminAbuseReportsApi adminAbuseReports;

  /// Admin account management API.
  late final AdminAccountsApi adminAccounts;

  /// Admin advertisement management API.
  late final AdminAdApi adminAd;

  /// Admin announcement management API.
  late final AdminAnnouncementsApi adminAnnouncements;

  /// Admin avatar decoration management API.
  late final AdminAvatarDecorationsApi adminAvatarDecorations;

  /// Admin CAPTCHA configuration API.
  late final AdminCaptchaApi adminCaptcha;

  /// Admin drive management API.
  late final AdminDriveApi adminDrive;

  /// Admin custom emoji management API.
  late final AdminEmojiApi adminEmoji;

  /// Admin federation management API.
  late final AdminFederationApi adminFederation;

  /// Admin invite code management API.
  late final AdminInviteApi adminInvite;

  /// Admin job queue management API.
  late final AdminQueueApi adminQueue;

  /// Admin relay management API.
  late final AdminRelaysApi adminRelays;

  /// Admin role management API.
  late final AdminRolesApi adminRoles;

  /// Admin system webhook management API.
  late final AdminSystemWebhookApi adminSystemWebhook;

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
