import 'dart:async';
import 'dart:convert';

import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/streaming/internal/streaming_socket.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyStreaming raw subscriptions', () {
    test('waits for ACK and sends one idempotent disconnect', () async {
      final socket = FakeSubscriptionSocket()..completeReady();
      final client = createSubscriptionClient([socket]);
      await client.connect();

      final subscriptionFuture = client.subscribeRaw(
        channel: 'homeTimeline',
        params: const {'withRenotes': true, 'withFiles': false},
        id: 'home',
      );

      expect(socket.sent, hasLength(1));
      expect(socket.sent.single, {
        'type': 'connect',
        'body': {
          'channel': 'homeTimeline',
          'id': 'home',
          'params': {'withRenotes': true, 'withFiles': false},
          'pong': true,
        },
      });

      var acknowledged = false;
      subscriptionFuture.then((_) => acknowledged = true);
      await flushEvents();
      expect(acknowledged, isFalse);

      socket.emitConnected('home');
      final subscription = await subscriptionFuture;
      expect(subscription.id, 'home');
      expect(subscription.channel, 'homeTimeline');
      expect(subscription.params, {'withRenotes': true, 'withFiles': false});

      final messagesDone = expectLater(subscription.messages, emitsDone);
      final firstUnsubscribe = subscription.unsubscribe();
      final secondUnsubscribe = subscription.unsubscribe();
      expect(secondUnsubscribe, same(firstUnsubscribe));
      await firstUnsubscribe;
      await messagesDone;

      expect(socket.sent.where((message) => message['type'] == 'disconnect'), [
        {
          'type': 'disconnect',
          'body': {'id': 'home'},
        },
      ]);

      await client.dispose();
    });

    test('rolls back a timed out request and ignores its late ACK', () async {
      final socket = FakeSubscriptionSocket()..completeReady();
      final client = createSubscriptionClient([
        socket,
      ], subscriptionTimeout: const Duration(milliseconds: 5));
      await client.connect();

      await expectLater(
        client.subscribeRaw(channel: 'homeTimeline', id: 'home'),
        throwsA(
          isA<MisskeyStreamingTimeoutException>()
              .having((error) => error.operation, 'operation', 'subscribe')
              .having(
                (error) => error.timeout,
                'timeout',
                const Duration(milliseconds: 5),
              ),
        ),
      );

      socket.emitConnected('home');
      await flushEvents();

      final replacementFuture = client.subscribeRaw(
        channel: 'localTimeline',
        id: 'home',
      );
      socket.emitConnected('home');
      final replacement = await replacementFuture;
      expect(replacement.channel, 'localTimeline');
      expect(
        socket.sent.where((message) => message['type'] == 'disconnect'),
        hasLength(1),
      );

      await replacement.unsubscribe();
      await client.dispose();
    });

    test('pauses pending ACK timeout across an explicit disconnect', () async {
      final firstSocket = FakeSubscriptionSocket()..completeReady();
      final secondSocket = FakeSubscriptionSocket()..completeReady();
      final client = createSubscriptionClient([
        firstSocket,
        secondSocket,
      ], subscriptionTimeout: const Duration(milliseconds: 10));
      await client.connect();

      final subscriptionFuture = client.subscribeRaw(
        channel: 'homeTimeline',
        id: 'home',
      );
      final outcome = Completer<Object?>();
      subscriptionFuture.then(
        outcome.complete,
        onError: (Object error, StackTrace _) => outcome.complete(error),
      );

      await client.disconnect();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(outcome.isCompleted, isFalse);

      await client.connect();
      expect(secondSocket.sent, hasLength(1));
      secondSocket.emitConnected('home');
      final subscription = await subscriptionFuture;
      expect(subscription.id, 'home');

      await client.dispose();
    });

    test('resends an acknowledged definition after reconnection', () async {
      final firstSocket = FakeSubscriptionSocket()..completeReady();
      final secondSocket = FakeSubscriptionSocket()..completeReady();
      final client = createSubscriptionClient([firstSocket, secondSocket]);
      await client.connect();

      final subscriptionFuture = client.subscribeRaw(
        channel: 'forkSpecificChannel',
        params: const {'custom': 1},
      );
      final generatedId = bodyOf(firstSocket.sent.single)['id']! as String;
      expect(generatedId, 'subscription-1');
      firstSocket.emitConnected(generatedId);
      final subscription = await subscriptionFuture;

      await client.disconnect();
      await client.connect();

      expect(secondSocket.sent, hasLength(1));
      expect(secondSocket.sent.single, firstSocket.sent.single);
      secondSocket.emitConnected(generatedId);
      await flushEvents();
      expect(subscription.id, generatedId);

      await client.dispose();
    });

    test(
      'retains an existing definition when a resubscribe ACK times out',
      () async {
        final firstSocket = FakeSubscriptionSocket()..completeReady();
        final secondSocket = FakeSubscriptionSocket()..completeReady();
        final thirdSocket = FakeSubscriptionSocket()..completeReady();
        final client = createSubscriptionClient([
          firstSocket,
          secondSocket,
          thirdSocket,
        ], subscriptionTimeout: const Duration(milliseconds: 5));
        await client.connect();

        final subscriptionFuture = client.subscribeRaw(
          channel: 'homeTimeline',
          id: 'home',
        );
        firstSocket.emitConnected('home');
        final subscription = await subscriptionFuture;

        final timeoutFuture = client.errors.firstWhere(
          (error) =>
              error is MisskeyStreamingTimeoutException &&
              error.operation == 'subscribe',
        );
        await client.disconnect();
        await client.connect();
        final timeout = await timeoutFuture.timeout(const Duration(seconds: 1));

        expect(timeout, isA<MisskeyStreamingTimeoutException>());
        expect(secondSocket.sent, hasLength(1));

        await client.disconnect();
        await client.connect();
        expect(thirdSocket.sent, hasLength(1));
        expect(thirdSocket.sent.single, firstSocket.sent.single);
        thirdSocket.emitConnected('home');
        await flushEvents();
        expect(subscription.id, 'home');

        await client.dispose();
      },
    );

    test('rejects duplicate IDs and subscriptions beyond 32', () async {
      final socket = FakeSubscriptionSocket()..completeReady();
      socket.onAdd = (message) {
        if (message['type'] == 'connect') {
          scheduleMicrotask(
            () => socket.emitConnected(bodyOf(message)['id']! as String),
          );
        }
      };
      final client = createSubscriptionClient([socket]);
      await client.connect();

      final first = await client.subscribeRaw(
        channel: 'homeTimeline',
        id: 'explicit',
      );
      await expectLater(
        client.subscribeRaw(channel: 'localTimeline', id: 'explicit'),
        throwsA(
          isA<MisskeyStreamingSubscriptionException>().having(
            (error) => error.context?['subscriptionId'],
            'duplicate ID',
            'explicit',
          ),
        ),
      );

      for (var index = 1; index < 32; index++) {
        await client.subscribeRaw(channel: 'channel-$index');
      }
      await expectLater(
        client.subscribeRaw(channel: 'over-limit'),
        throwsA(
          isA<MisskeyStreamingSubscriptionException>().having(
            (error) => error.context?['maximum'],
            'maximum',
            32,
          ),
        ),
      );

      expect(first.id, 'explicit');
      await client.dispose();
    });

    test(
      'fails a pending request and closes active streams on dispose',
      () async {
        final socket = FakeSubscriptionSocket()..completeReady();
        final client = createSubscriptionClient([socket]);
        await client.connect();

        final activeFuture = client.subscribeRaw(
          channel: 'homeTimeline',
          id: 'active',
        );
        socket.emitConnected('active');
        final active = await activeFuture;
        final activeDone = expectLater(active.messages, emitsDone);

        final pending = expectLater(
          client.subscribeRaw(channel: 'localTimeline', id: 'pending'),
          throwsA(isA<MisskeyStreamingSubscriptionException>()),
        );

        await client.dispose();

        await activeDone;
        await pending;
        expect(client.state, MisskeyStreamingConnectionState.disposed);
        await active.unsubscribe();
      },
    );
  });
}

MisskeyStreaming createSubscriptionClient(
  List<FakeSubscriptionSocket> sockets, {
  Duration subscriptionTimeout = const Duration(milliseconds: 100),
}) {
  var index = 0;
  return MisskeyStreaming.withConnector(
    baseUrl: Uri.parse('https://misskey.example'),
    config: MisskeyStreamingConfig(
      enableAutoReconnect: false,
      connectTimeout: const Duration(milliseconds: 100),
      subscriptionTimeout: subscriptionTimeout,
    ),
    connector: (_) => sockets[index++],
  );
}

Map<String, Object?> bodyOf(Map<String, Object?> message) =>
    (message['body']! as Map<Object?, Object?>).cast<String, Object?>();

Future<void> flushEvents() => Future<void>.delayed(Duration.zero);

final class FakeSubscriptionSocket implements StreamingSocket {
  final Completer<void> _ready = Completer<void>();
  final StreamController<Object?> _messages = StreamController<Object?>();
  final List<Map<String, Object?>> sent = [];
  void Function(Map<String, Object?> message)? onAdd;
  int closeCalls = 0;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  Future<void> get ready => _ready.future;

  @override
  Stream<Object?> get stream => _messages.stream;

  @override
  void add(String data) {
    final decoded = jsonDecode(data)! as Map<Object?, Object?>;
    final message = decoded.cast<String, Object?>();
    sent.add(message);
    onAdd?.call(message);
  }

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    closeCalls++;
  }

  void completeReady() {
    if (!_ready.isCompleted) {
      _ready.complete();
    }
  }

  void emitConnected(String id) {
    _messages.add(
      jsonEncode({
        'type': 'connected',
        'body': {'id': id},
      }),
    );
  }
}
