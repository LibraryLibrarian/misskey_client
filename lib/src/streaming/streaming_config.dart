import 'package:meta/meta.dart';

/// Configuration for the Misskey Streaming API connection.
@immutable
class MisskeyStreamingConfig {
  /// Creates Streaming API connection settings.
  MisskeyStreamingConfig({
    this.enableAutoReconnect = true,
    this.connectTimeout = const Duration(seconds: 15),
    this.subscriptionTimeout = const Duration(seconds: 10),
    this.reconnectInitialDelay = const Duration(seconds: 1),
    this.reconnectMaxDelay = const Duration(seconds: 30),
    this.maxReconnectAttempts,
  }) {
    _requirePositive(connectTimeout, 'connectTimeout');
    _requirePositive(subscriptionTimeout, 'subscriptionTimeout');
    _requirePositive(reconnectInitialDelay, 'reconnectInitialDelay');
    _requirePositive(reconnectMaxDelay, 'reconnectMaxDelay');
    if (reconnectInitialDelay > reconnectMaxDelay) {
      throw ArgumentError.value(
        reconnectInitialDelay,
        'reconnectInitialDelay',
        'must not be greater than reconnectMaxDelay',
      );
    }
    if (maxReconnectAttempts != null && maxReconnectAttempts! < 0) {
      throw ArgumentError.value(
        maxReconnectAttempts,
        'maxReconnectAttempts',
        'must be null or non-negative',
      );
    }
  }

  static void _requirePositive(Duration value, String name) {
    if (value <= Duration.zero) {
      throw ArgumentError.value(value, name, 'must be positive');
    }
  }

  /// Whether an unexpected disconnection should trigger reconnection.
  final bool enableAutoReconnect;

  /// The maximum duration to wait for the WebSocket connection to open.
  final Duration connectTimeout;

  /// The maximum duration to wait for a subscription acknowledgement.
  final Duration subscriptionTimeout;

  /// The delay before the first automatic reconnection attempt.
  final Duration reconnectInitialDelay;

  /// The upper bound for automatic reconnection delays.
  final Duration reconnectMaxDelay;

  /// The maximum number of automatic reconnection attempts.
  ///
  /// A value of `null` allows unlimited attempts. A value of zero disables
  /// reconnection attempts after an unexpected disconnection.
  final int? maxReconnectAttempts;
}
