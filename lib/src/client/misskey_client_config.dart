import 'package:meta/meta.dart';

/// MisskeyAPIクライアント設定
@immutable
class MisskeyClientConfig {
  const MisskeyClientConfig({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 10),
    this.userAgent,
    this.defaultHeaders = const {},
    this.maxRetries = 3,
    this.enableLog = false,
  });

  /// サーバーのベースURL
  ///
  /// 例: `https://misskey.example.com`
  final Uri baseUrl;

  /// 接続/送受信を包括するタイムアウト
  final Duration timeout;

  /// User-Agentを上書きしたい場合に指定
  final String? userAgent;

  /// 既定ヘッダ
  ///
  /// UAやAcceptはクライアント側で付与されるため、通常は追加分のみを指定
  final Map<String, String> defaultHeaders;

  /// リトライ最大試行回数（1 = リトライ無し）
  final int maxRetries;

  /// ログ出力を有効にするか
  final bool enableLog;
}
