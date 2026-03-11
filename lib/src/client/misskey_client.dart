import '../api/account/account_api.dart';
import '../api/channels/channels_api.dart';
import '../api/drive/drive_files_api.dart';
import '../api/notes/notes_api.dart';
import '../api/notifications/notifications_api.dart';
import '../api/users/users_api.dart';
import '../logging/logger.dart';
import 'misskey_client_config.dart';
import 'misskey_http.dart';
import 'token_provider.dart';

/// Misskey API クライアント
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
    driveFiles = DriveFilesApi(http: http);
    notes = NotesApi(http: http);
    notifications = NotificationsApi(http: http);
    users = UsersApi(http: http);
  }

  final MisskeyHttp http;

  late final AccountApi account;
  late final ChannelsApi channels;
  late final DriveFilesApi driveFiles;
  late final NotesApi notes;
  late final NotificationsApi notifications;
  late final UsersApi users;
}
