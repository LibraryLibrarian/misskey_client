import 'dart:async';
import 'dart:convert';

import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/streaming/internal/streaming_socket.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyStreaming subscription routing', () {
    test('preserves global envelopes and flattens handle events', () async {
      final socket = FakeRoutingSocket()..completeReady();
      final client = createRoutingClient([socket]);
      await client.connect();

      final subscriptionFuture = client.subscribeRaw(
        channel: 'homeTimeline',
        id: 'home',
      );
      socket.emitConnected('home');
      final subscription = await subscriptionFuture;
      final handleEvent = subscription.messages.first;
      final globalEvent = client.messages.firstWhere(
        (message) => message.type == 'channel',
      );

      final envelope = {
        'type': 'channel',
        'body': {
          'id': 'home',
          'type': 'note',
          'body': {'id': 'note-1', 'text': 'hello'},
        },
      };
      socket.emit(envelope);

      final global = await globalEvent;
      expect(global.type, 'channel');
      expect(global.body, envelope['body']);
      expect(global.raw, envelope);
      expect(global.subscriptionId, isNull);

      final routed = await handleEvent;
      expect(routed.type, 'note');
      expect(routed.body, {'id': 'note-1', 'text': 'hello'});
      expect(routed.raw, envelope);
      expect(routed.subscriptionId, 'home');

      await client.dispose();
    });

    test('reports malformed routing without closing the socket', () async {
      final socket = FakeRoutingSocket()..completeReady();
      final client = createRoutingClient([socket]);
      await client.connect();
      final errorFuture = client.errors.first;

      socket.emit({
        'type': 'channel',
        'body': {'id': 'home', 'body': null},
      });

      final error = await errorFuture;
      expect(error, isA<MisskeyStreamingProtocolException>());
      expect(error.operation, 'routeMessage');
      expect(client.isConnected, isTrue);
      expect(socket.closeCalls, 0);

      await client.dispose();
    });

    test('reference-counts captures and routes noteUpdated events', () async {
      final socket = FakeRoutingSocket()..completeReady();
      final client = createRoutingClient([socket]);
      await client.connect();
      final first = await subscribeAndAcknowledge(client, socket, 'first');
      final second = await subscribeAndAcknowledge(client, socket, 'second');

      first.captureNote('note-1');
      first.captureNote('note-1');
      second.captureNote('note-1');
      expect(messagesOfType(socket, 'subNote'), [
        {
          'type': 'subNote',
          'body': {'id': 'note-1'},
        },
      ]);

      final firstEvent = first.messages.first;
      final secondEvent = second.messages.first;
      final envelope = {
        'type': 'noteUpdated',
        'body': {
          'id': 'note-1',
          'type': 'futureEvent',
          'body': {'value': 1},
        },
      };
      socket.emit(envelope);

      expect(
        await firstEvent,
        isA<MisskeyStreamingMessage>()
            .having((message) => message.type, 'type', 'futureEvent')
            .having((message) => message.body, 'body', {'value': 1})
            .having(
              (message) => message.subscriptionId,
              'subscriptionId',
              'first',
            ),
      );
      expect(
        await secondEvent,
        isA<MisskeyStreamingMessage>().having(
          (message) => message.subscriptionId,
          'subscriptionId',
          'second',
        ),
      );

      first.uncaptureNote('note-1');
      expect(messagesOfType(socket, 'unsubNote'), isEmpty);
      second.uncaptureNote('note-1');
      second.uncaptureNote('note-1');
      expect(messagesOfType(socket, 'unsubNote'), [
        {
          'type': 'unsubNote',
          'body': {'id': 'note-1'},
        },
      ]);

      await client.dispose();
    });

    test(
      'cleans captures and exposes ID and channel unsubscribe APIs',
      () async {
        final socket = FakeRoutingSocket()..completeReady();
        final client = createRoutingClient([socket]);
        await client.connect();
        final first = await subscribeAndAcknowledge(
          client,
          socket,
          'first',
          channel: 'homeTimeline',
        );
        final second = await subscribeAndAcknowledge(
          client,
          socket,
          'second',
          channel: 'homeTimeline',
        );
        final third = await subscribeAndAcknowledge(
          client,
          socket,
          'third',
          channel: 'localTimeline',
        );
        first.captureNote('shared-note');
        second.captureNote('shared-note');
        first.captureNote('first-only');

        expect(await client.unsubscribe('first'), isTrue);
        expect(await client.unsubscribe('first'), isFalse);
        expect(first.isActive, isFalse);
        expect(second.isActive, isTrue);
        expect(messagesOfType(socket, 'unsubNote'), [
          {
            'type': 'unsubNote',
            'body': {'id': 'first-only'},
          },
        ]);
        expect(
          () => first.captureNote('late-note'),
          throwsA(isA<MisskeyStreamingSubscriptionException>()),
        );
        await expectLater(
          client.subscribeRaw(channel: 'homeTimeline', id: 'first'),
          throwsA(isA<MisskeyStreamingSubscriptionException>()),
        );

        expect(await client.unsubscribeChannel('homeTimeline'), 1);
        expect(await client.unsubscribeChannel('missing'), 0);
        expect(second.isActive, isFalse);
        expect(third.isActive, isTrue);
        expect(messagesOfType(socket, 'unsubNote'), [
          {
            'type': 'unsubNote',
            'body': {'id': 'first-only'},
          },
          {
            'type': 'unsubNote',
            'body': {'id': 'shared-note'},
          },
        ]);

        await client.dispose();
      },
    );

    test('top-level unsubscribe completes a pending subscription', () async {
      final socket = FakeRoutingSocket()..completeReady();
      final client = createRoutingClient([socket]);
      await client.connect();

      final pending = client.subscribeRaw(
        channel: 'homeTimeline',
        id: 'pending',
      );
      final pendingError = expectLater(
        pending,
        throwsA(
          isA<MisskeyStreamingSubscriptionException>().having(
            (error) => error.operation,
            'operation',
            'unsubscribe',
          ),
        ),
      );
      expect(await client.unsubscribe('pending'), isTrue);
      await pendingError;
      expect(await client.unsubscribe('pending'), isFalse);

      await client.dispose();
    });

    test(
      'restores subscriptions and unique captures before connected',
      () async {
        final firstSocket = FakeRoutingSocket()..completeReady();
        final secondSocket = FakeRoutingSocket()..completeReady();
        final client = createRoutingClient([firstSocket, secondSocket]);
        await client.connect();
        final first = await subscribeAndAcknowledge(
          client,
          firstSocket,
          'first',
        );
        final second = await subscribeAndAcknowledge(
          client,
          firstSocket,
          'second',
        );
        first.captureNote('note-1');
        second.captureNote('note-1');
        second.captureNote('note-2');

        await client.disconnect();
        final connectedState = client.stateChanges.firstWhere(
          (state) => state == MisskeyStreamingConnectionState.connected,
        );
        await client.connect();
        await connectedState;

        expect(secondSocket.sent.map((message) => message['type']), [
          'connect',
          'connect',
          'subNote',
          'subNote',
        ]);
        expect(
          messagesOfType(
            secondSocket,
            'subNote',
          ).map((message) => bodyOf(message)['id']),
          ['note-1', 'note-2'],
        );

        secondSocket.emitConnected('first');
        secondSocket.emitConnected('second');
        await client.dispose();
      },
    );
  });
}

Future<MisskeyStreamingSubscription> subscribeAndAcknowledge(
  MisskeyStreaming client,
  FakeRoutingSocket socket,
  String id, {
  String channel = 'homeTimeline',
}) async {
  final future = client.subscribeRaw(channel: channel, id: id);
  socket.emitConnected(id);
  return future;
}

MisskeyStreaming createRoutingClient(List<FakeRoutingSocket> sockets) {
  var index = 0;
  return MisskeyStreaming.withConnector(
    baseUrl: Uri.parse('https://misskey.example'),
    config: MisskeyStreamingConfig(
      enableAutoReconnect: false,
      connectTimeout: const Duration(milliseconds: 100),
      subscriptionTimeout: const Duration(milliseconds: 100),
    ),
    connector: (_) => sockets[index++],
  );
}

List<Map<String, Object?>> messagesOfType(
  FakeRoutingSocket socket,
  String type,
) => socket.sent.where((message) => message['type'] == type).toList();

Map<String, Object?> bodyOf(Map<String, Object?> message) =>
    (message['body']! as Map<Object?, Object?>).cast<String, Object?>();

final class FakeRoutingSocket implements StreamingSocket {
  final Completer<void> _ready = Completer<void>();
  final StreamController<Object?> _messages = StreamController<Object?>();
  final List<Map<String, Object?>> sent = [];
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
    sent.add(decoded.cast<String, Object?>());
  }

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    closeCalls++;
  }

  void completeReady() => _ready.complete();

  void emit(Map<String, Object?> message) => _messages.add(jsonEncode(message));

  void emitConnected(String id) {
    emit({
      'type': 'connected',
      'body': {'id': id},
    });
  }
}
