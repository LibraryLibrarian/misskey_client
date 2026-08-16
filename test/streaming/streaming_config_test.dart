import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyStreamingConfig', () {
    test('uses safe connection and reconnection defaults', () {
      final config = MisskeyStreamingConfig();

      expect(config.enableAutoReconnect, isTrue);
      expect(config.connectTimeout, const Duration(seconds: 15));
      expect(config.subscriptionTimeout, const Duration(seconds: 10));
      expect(config.reconnectInitialDelay, const Duration(seconds: 1));
      expect(config.reconnectMaxDelay, const Duration(seconds: 30));
      expect(config.maxReconnectAttempts, isNull);
    });

    test('accepts custom settings including zero reconnect attempts', () {
      final config = MisskeyStreamingConfig(
        enableAutoReconnect: false,
        connectTimeout: Duration(seconds: 3),
        subscriptionTimeout: Duration(seconds: 4),
        reconnectInitialDelay: Duration(milliseconds: 250),
        reconnectMaxDelay: Duration(seconds: 5),
        maxReconnectAttempts: 0,
      );

      expect(config.enableAutoReconnect, isFalse);
      expect(config.connectTimeout, const Duration(seconds: 3));
      expect(config.subscriptionTimeout, const Duration(seconds: 4));
      expect(config.reconnectInitialDelay, const Duration(milliseconds: 250));
      expect(config.reconnectMaxDelay, const Duration(seconds: 5));
      expect(config.maxReconnectAttempts, 0);
    });

    test('rejects non-positive timeouts and reconnect delays', () {
      expect(
        () => MisskeyStreamingConfig(connectTimeout: Duration.zero),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => MisskeyStreamingConfig(subscriptionTimeout: Duration.zero),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => MisskeyStreamingConfig(reconnectInitialDelay: Duration.zero),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => MisskeyStreamingConfig(reconnectMaxDelay: Duration.zero),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects an initial delay greater than the maximum delay', () {
      expect(
        () => MisskeyStreamingConfig(
          reconnectInitialDelay: const Duration(seconds: 2),
          reconnectMaxDelay: const Duration(seconds: 1),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects a negative maximum reconnect attempt count', () {
      expect(
        () => MisskeyStreamingConfig(maxReconnectAttempts: -1),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
