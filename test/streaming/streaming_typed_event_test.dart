import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/streaming/internal/streaming_socket.dart';
import 'package:test/test.dart';

void main() {
  late Map<String, Object?> noteJson;
  late Map<String, Object?> notificationJson;

  setUpAll(() {
    noteJson =
        (jsonDecode(File('test/fixtures/notes_show.json').readAsStringSync())!
                as Map<Object?, Object?>)
            .cast<String, Object?>();
    final notifications =
        jsonDecode(File('test/fixtures/notifications.json').readAsStringSync())!
            as List<Object?>;
    notificationJson = (notifications.first! as Map<Object?, Object?>)
        .cast<String, Object?>();
  });

  group('MisskeyStreaming typed events', () {
    test('decodes note events for every official timeline channel', () async {
      final socket = FakeTypedEventSocket()..completeReady();
      final client = createTypedEventClient([socket]);
      await client.connect();

      const channels = [
        'homeTimeline',
        'localTimeline',
        'hybridTimeline',
        'globalTimeline',
        'userList',
        'hashtag',
        'roleTimeline',
        'antenna',
        'channel',
      ];
      for (final channel in channels) {
        final subscription = await subscribeAndAcknowledge(
          client,
          socket,
          channel,
          channel: channel,
        );
        final eventFuture = subscription.events.first;
        final noteFuture = subscription.notes.first;

        socket.emitChannel(channel, 'note', noteJson);

        final event = await eventFuture;
        expect(event, isA<MisskeyNoteEvent>());
        expect(event.type, 'note');
        expect((event as MisskeyNoteEvent).note.id, noteJson['id']);
        expect((await noteFuture).id, noteJson['id']);
      }

      await client.dispose();
    });

    test('decodes the supported main note and notification events', () async {
      final socket = FakeTypedEventSocket()..completeReady();
      final client = createTypedEventClient([socket]);
      await client.connect();
      final subscription = await subscribeAndAcknowledge(
        client,
        socket,
        'main',
        channel: 'main',
      );

      for (final type in ['mention', 'reply', 'renote']) {
        final eventFuture = subscription.events.first;
        final noteFuture = subscription.notes.first;
        socket.emitChannel('main', type, noteJson);

        final event = await eventFuture;
        expect(event, isA<MisskeyNoteEvent>());
        expect(event.type, type);
        expect((await noteFuture).id, noteJson['id']);
      }

      for (final type in ['notification', 'unreadNotification']) {
        final eventFuture = subscription.events.first;
        final notificationFuture = subscription.notifications.first;
        socket.emitChannel('main', type, notificationJson);

        final event = await eventFuture;
        expect(event, isA<MisskeyNotificationEvent>());
        expect(event.type, type);
        expect((await notificationFuture).id, notificationJson['id']);
      }

      await client.dispose();
    });

    test('uses channel-aware decoding for colliding event names', () async {
      final socket = FakeTypedEventSocket()..completeReady();
      final client = createTypedEventClient([socket]);
      await client.connect();
      final fork = await subscribeAndAcknowledge(
        client,
        socket,
        'fork',
        channel: 'forkSpecificChannel',
      );
      final drive = await subscribeAndAcknowledge(
        client,
        socket,
        'drive',
        channel: 'drive',
      );
      final chat = await subscribeAndAcknowledge(
        client,
        socket,
        'chat',
        channel: 'chatUser',
      );

      final forkEvent = fork.events.first;
      socket.emitChannel('fork', 'note', noteJson);
      expect(await forkEvent, isA<MisskeyUnknownEvent>());

      final driveEvent = drive.events.first;
      socket.emitChannel('drive', 'deleted', 'file-id');
      expect(await driveEvent, isA<MisskeyUnknownEvent>());

      final chatEvent = chat.events.first;
      socket.emitChannel('chat', 'notification', notificationJson);
      expect(await chatEvent, isA<MisskeyUnknownEvent>());

      await client.dispose();
    });

    test('preserves unknown Map, scalar, List, and null bodies', () async {
      final socket = FakeTypedEventSocket()..completeReady();
      final client = createTypedEventClient([socket]);
      await client.connect();
      final subscription = await subscribeAndAcknowledge(
        client,
        socket,
        'fork',
        channel: 'forkSpecificChannel',
      );

      final bodies = <Object?>[
        {'value': 1},
        'scalar',
        [1, true, null],
        null,
      ];
      for (var index = 0; index < bodies.length; index++) {
        final eventFuture = subscription.events.first;
        final messageFuture = subscription.messages.first;
        socket.emitChannel('fork', 'future-$index', bodies[index]);

        final message = await messageFuture;
        final event = await eventFuture as MisskeyUnknownEvent;
        expect(event.type, 'future-$index');
        expect(event.body, bodies[index]);
        expect(event.decodeError, isNull);
        expect(event.raw, same(message));
        expect(event.raw.subscriptionId, 'fork');
      }

      await client.dispose();
    });

    test('decodes all captured noteUpdated payloads', () async {
      final socket = FakeTypedEventSocket()..completeReady();
      final client = createTypedEventClient([socket]);
      await client.connect();
      final first = await subscribeAndAcknowledge(client, socket, 'first');
      final second = await subscribeAndAcknowledge(client, socket, 'second');
      first.captureNote('note-1');
      second.captureNote('note-1');

      for (final emoji in <Object?>[
        const {'name': 'party@.', 'url': 'https://example/party.webp'},
        null,
        _missingEmoji,
      ]) {
        final firstEvent = first.events.first;
        final secondEvent = second.events.first;
        final body = <String, Object?>{
          'reaction': ':party@.:',
          'userId': 'user-1',
          if (!identical(emoji, _missingEmoji)) 'emoji': emoji,
        };
        socket.emitNoteUpdated('note-1', 'reacted', body);

        final reacted = await firstEvent as MisskeyNoteReactedEvent;
        expect(reacted.noteId, 'note-1');
        expect(reacted.reaction, ':party@.:');
        expect(reacted.userId, 'user-1');
        if (emoji is Map<String, String>) {
          expect(reacted.emoji?.name, emoji['name']);
          expect(reacted.emoji?.url, emoji['url']);
        } else {
          expect(reacted.emoji, isNull);
        }
        expect(await secondEvent, isA<MisskeyNoteReactedEvent>());
      }

      final unreactedFuture = first.events.first;
      socket.emitNoteUpdated('note-1', 'unreacted', {
        'reaction': '👍',
        'userId': 'user-1',
      });
      final unreacted = await unreactedFuture as MisskeyNoteUnreactedEvent;
      expect(unreacted.noteId, 'note-1');
      expect(unreacted.reaction, '👍');
      expect(unreacted.userId, 'user-1');

      final deletedFuture = first.events.first;
      socket.emitNoteUpdated('note-1', 'deleted', {
        'deletedAt': '2026-08-15T01:02:03.000Z',
      });
      final deleted = await deletedFuture as MisskeyNoteDeletedEvent;
      expect(deleted.noteId, 'note-1');
      expect(deleted.deletedAt, DateTime.utc(2026, 8, 15, 1, 2, 3));

      final votedFuture = first.events.first;
      socket.emitNoteUpdated('note-1', 'pollVoted', {
        'choice': 2,
        'userId': 'user-2',
      });
      final voted = await votedFuture as MisskeyNotePollVotedEvent;
      expect(voted.noteId, 'note-1');
      expect(voted.choice, 2);
      expect(voted.userId, 'user-2');

      final unknownFuture = first.events.first;
      socket.emitNoteUpdated('note-1', 'updated', 'future-payload');
      final unknown = await unknownFuture as MisskeyUnknownEvent;
      expect(unknown.type, 'updated');
      expect(unknown.body, 'future-payload');
      expect(unknown.decodeError, isNull);

      await client.dispose();
    });

    test('falls back on known decode failures and keeps streaming', () async {
      final socket = FakeTypedEventSocket()..completeReady();
      final client = createTypedEventClient([socket]);
      final errors = <MisskeyStreamingException>[];
      final errorSubscription = client.errors.listen(errors.add);
      await client.connect();
      final timeline = await subscribeAndAcknowledge(client, socket, 'home');
      final main = await subscribeAndAcknowledge(
        client,
        socket,
        'main',
        channel: 'main',
      );
      timeline.captureNote('note-1');

      final invalidNote = timeline.events.first;
      socket.emitChannel('home', 'note', {'id': 'incomplete'});
      expect(
        await invalidNote,
        isA<MisskeyUnknownEvent>().having(
          (event) => event.decodeError,
          'decodeError',
          isNotNull,
        ),
      );

      final invalidNotification = main.events.first;
      socket.emitChannel('main', 'notification', {'id': 'incomplete'});
      expect(
        await invalidNotification,
        isA<MisskeyUnknownEvent>().having(
          (event) => event.decodeError,
          'decodeError',
          isNotNull,
        ),
      );

      final invalidUpdate = timeline.events.first;
      socket.emitNoteUpdated('note-1', 'reacted', {
        'reaction': ':legacy:',
        'emoji': ':legacy:',
        'userId': 'user-1',
      });
      expect(
        await invalidUpdate,
        isA<MisskeyUnknownEvent>().having(
          (event) => event.decodeError,
          'decodeError',
          isNotNull,
        ),
      );

      final validEvent = timeline.events.first;
      socket.emitChannel('home', 'note', noteJson);
      expect(await validEvent, isA<MisskeyNoteEvent>());
      await flushEvents();
      expect(errors, isEmpty);
      expect(client.isConnected, isTrue);

      await errorSubscription.cancel();
      await client.dispose();
    });

    test('keeps streams broadcast across reconnect and closes all', () async {
      final firstSocket = FakeTypedEventSocket()..completeReady();
      final secondSocket = FakeTypedEventSocket()..completeReady();
      final client = createTypedEventClient([firstSocket, secondSocket]);
      await client.connect();
      final subscription = await subscribeAndAcknowledge(
        client,
        firstSocket,
        'home',
      );

      expect(subscription.messages.isBroadcast, isTrue);
      expect(subscription.events.isBroadcast, isTrue);
      expect(subscription.notes.isBroadcast, isTrue);
      expect(subscription.notifications.isBroadcast, isTrue);

      final done = List.generate(4, (_) => Completer<void>());
      subscription.messages.listen((_) {}, onDone: done[0].complete);
      subscription.events.listen((_) {}, onDone: done[1].complete);
      subscription.notes.listen((_) {}, onDone: done[2].complete);
      subscription.notifications.listen((_) {}, onDone: done[3].complete);

      await client.disconnect();
      await flushEvents();
      expect(done.every((completer) => !completer.isCompleted), isTrue);

      await client.connect();
      secondSocket.emitConnected('home');
      final firstListener = subscription.events.first;
      final secondListener = subscription.events.first;
      secondSocket.emitChannel('home', 'note', noteJson);
      expect(await firstListener, isA<MisskeyNoteEvent>());
      expect(await secondListener, isA<MisskeyNoteEvent>());

      await subscription.unsubscribe();
      await Future.wait(done.map((completer) => completer.future));
      expect(subscription.isActive, isFalse);

      await client.dispose();
    });

    test('closes every handle stream on client dispose', () async {
      final socket = FakeTypedEventSocket()..completeReady();
      final client = createTypedEventClient([socket]);
      await client.connect();
      final subscription = await subscribeAndAcknowledge(
        client,
        socket,
        'home',
      );

      final expectations = [
        expectLater(subscription.messages, emitsDone),
        expectLater(subscription.events, emitsDone),
        expectLater(subscription.notes, emitsDone),
        expectLater(subscription.notifications, emitsDone),
      ];
      await client.dispose();
      await Future.wait(expectations);
    });
  });
}

const Object _missingEmoji = Object();

Future<MisskeyStreamingSubscription> subscribeAndAcknowledge(
  MisskeyStreaming client,
  FakeTypedEventSocket socket,
  String id, {
  String channel = 'homeTimeline',
}) async {
  final future = client.subscribeRaw(channel: channel, id: id);
  socket.emitConnected(id);
  return future;
}

MisskeyStreaming createTypedEventClient(List<FakeTypedEventSocket> sockets) {
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

Future<void> flushEvents() => Future<void>.delayed(Duration.zero);

final class FakeTypedEventSocket implements StreamingSocket {
  final Completer<void> _ready = Completer<void>();
  final StreamController<Object?> _messages = StreamController<Object?>();
  final List<Map<String, Object?>> sent = [];

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
  Future<void> close([int? closeCode, String? closeReason]) async {}

  void completeReady() => _ready.complete();

  void emitConnected(String id) {
    _emit({
      'type': 'connected',
      'body': {'id': id},
    });
  }

  void emitChannel(String subscriptionId, String type, Object? body) {
    _emit({
      'type': 'channel',
      'body': {'id': subscriptionId, 'type': type, 'body': body},
    });
  }

  void emitNoteUpdated(String noteId, String type, Object? body) {
    _emit({
      'type': 'noteUpdated',
      'body': {'id': noteId, 'type': type, 'body': body},
    });
  }

  void _emit(Map<String, Object?> message) {
    _messages.add(jsonEncode(message));
  }
}
