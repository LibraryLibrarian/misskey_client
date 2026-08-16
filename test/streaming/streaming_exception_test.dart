import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyStreamingException', () {
    test('connection exception preserves diagnostic information', () {
      final cause = StateError('socket failed');
      final stackTrace = StackTrace.current;
      final exception = MisskeyStreamingConnectionException(
        message: 'Could not connect',
        cause: cause,
        stackTrace: stackTrace,
        operation: 'connect',
        context: const {'attempt': 2},
      );

      expect(exception, isA<MisskeyStreamingException>());
      expect(exception, isA<MisskeyClientException>());
      expect(exception.message, 'Could not connect');
      expect(exception.cause, same(cause));
      expect(exception.stackTrace, same(stackTrace));
      expect(exception.operation, 'connect');
      expect(exception.context, const {'attempt': 2});
      expect(exception.toString(), contains('operation=connect'));
      expect(exception.toString(), isNot(contains('attempt: 2')));
    });

    test('timeout exception records the configured timeout', () {
      const exception = MisskeyStreamingTimeoutException(
        operation: 'subscribe',
        timeout: Duration(seconds: 10),
      );

      expect(exception.timeout, const Duration(seconds: 10));
      expect(exception.operation, 'subscribe');
    });

    test('specialized exceptions share structured diagnostics', () {
      const protocol = MisskeyStreamingProtocolException(
        operation: 'decodeMessage',
        context: {'type': 42},
      );
      const subscription = MisskeyStreamingSubscriptionException(
        operation: 'subscribe',
        context: {'subscriptionId': 'home'},
      );

      expect(protocol.context?['type'], 42);
      expect(subscription.context?['subscriptionId'], 'home');
      expect(protocol, isA<MisskeyStreamingException>());
      expect(subscription, isA<MisskeyStreamingException>());
    });
  });
}
