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
        );

  /// 内部HTTPクライアント（APIクラスから参照）
  final MisskeyHttp http;

  // 各APIドメインは後続のコミットで追加
}
