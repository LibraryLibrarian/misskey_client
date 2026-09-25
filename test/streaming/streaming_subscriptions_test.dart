import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/fake_streaming_socket.dart';

void main() {
  test(
    'subscriptions is an ordered unmodifiable snapshot including pending ACKs',
    () async {
      final socket = FakeStreamingSocket(ackMode: StreamingAckMode.manual);
      final streaming = MisskeyStreaming.withConnector(
        baseUrl: Uri.parse('https://misskey.example'),
        connector: FakeStreamingConnector([socket]).call,
      );
      addTearDown(streaming.dispose);
      expect(streaming.subscriptions, isEmpty);
      await streaming.connect();
      final firstFuture = streaming.subscribeRaw(channel: 'main', id: 'first');
      final secondFuture = streaming.subscribeRaw(
        channel: 'homeTimeline',
        id: 'second',
      );
      final snapshot = streaming.subscriptions;
      expect(snapshot.map((s) => s.id), ['first', 'second']);
      expect(snapshot.every((s) => s.isActive), isTrue);
      expect(() => snapshot.clear(), throwsUnsupportedError);
      socket.acknowledge('second');
      socket.acknowledge('first');
      final first = await firstFuture;
      final second = await secondFuture;
      expect(streaming.subscriptions, [first, second]);
      await first.unsubscribe();
      expect(streaming.subscriptions, [second]);
      expect(snapshot, [first, second]);
      await streaming.disconnect();
      expect(streaming.subscriptions, [second]);
      await streaming.dispose();
      expect(streaming.subscriptions, isEmpty);
    },
  );

  test(
    'never ACK mode leaves subscriptions registered until disposal',
    () async {
      final socket = FakeStreamingSocket(ackMode: StreamingAckMode.never);
      final streaming = MisskeyStreaming.withConnector(
        baseUrl: Uri.parse('https://misskey.example'),
        connector: FakeStreamingConnector([socket]).call,
      );
      await streaming.connect();
      final pending = streaming.subscribeRaw(channel: 'main', id: 'pending');
      final assertion = expectLater(
        pending,
        throwsA(isA<MisskeyStreamingSubscriptionException>()),
      );
      socket.acknowledge('pending');
      expect(streaming.subscriptions.single.id, 'pending');
      await streaming.dispose();
      await assertion;
      expect(streaming.subscriptions, isEmpty);
    },
  );
}
