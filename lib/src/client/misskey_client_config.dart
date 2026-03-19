import 'package:meta/meta.dart';

/// Configuration for the Misskey API client.
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

  /// The base URL of the Misskey server.
  ///
  /// Example: `https://misskey.example.com`
  final Uri baseUrl;

  /// The timeout covering connection, send, and receive phases.
  final Duration timeout;

  /// A custom User-Agent string override.
  final String? userAgent;

  /// Default headers appended to every request.
  ///
  /// The client already sets `User-Agent` and `Accept`, so typically only
  /// additional headers need to be specified here.
  final Map<String, String> defaultHeaders;

  /// Maximum number of retry attempts (1 means no retries).
  final int maxRetries;

  /// Whether to enable debug logging.
  final bool enableLog;
}
