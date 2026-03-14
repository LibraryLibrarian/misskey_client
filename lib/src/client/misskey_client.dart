import '../api/account/account_api.dart';
import '../api/channels_api.dart';
import '../api/drive/drive_api.dart';
import '../api/meta_api.dart';
import '../api/notes_api.dart';
import '../api/notifications_api.dart';
import '../api/users_api.dart';
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
    channels = ChannelsApi(http: http);
    drive = DriveApi(http: http);
    meta = MetaApi(http: http);
    notes = NotesApi(http: http);
    notifications = NotificationsApi(http: http);
    users = UsersApi(http: http);
  }

  final MisskeyHttp http;

  late final AccountApi account;
  late final ChannelsApi channels;
  late final DriveApi drive;
  late final MetaApi meta;
  late final NotesApi notes;
  late final NotificationsApi notifications;
  late final UsersApi users;
}
