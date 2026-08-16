import 'dart:async';
import 'dart:convert';

import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/streaming/internal/streaming_socket.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyStreamingChannel', () {
    test('maps all official channels to protocol names and parameters', () {
      final channels = <MisskeyStreamingChannel>[
        const MisskeyStreamingChannel.main(),
        const MisskeyStreamingChannel.homeTimeline(
          withRenotes: true,
          withFiles: false,
        ),
        const MisskeyStreamingChannel.localTimeline(
          withRenotes: true,
          withReplies: false,
          withFiles: true,
        ),
        const MisskeyStreamingChannel.hybridTimeline(
          withRenotes: false,
          withReplies: true,
          withFiles: false,
        ),
        const MisskeyStreamingChannel.globalTimeline(withFiles: true),
        const MisskeyStreamingChannel.userList(
          listId: 'list-id',
          withFiles: false,
          withRenotes: true,
        ),
        const MisskeyStreamingChannel.hashtag(
          q: [
            ['dart', 'flutter'],
          ],
        ),
        const MisskeyStreamingChannel.roleTimeline(roleId: 'role-id'),
        const MisskeyStreamingChannel.antenna(antennaId: 'antenna-id'),
        const MisskeyStreamingChannel.channel(channelId: 'channel-id'),
        const MisskeyStreamingChannel.drive(),
        const MisskeyStreamingChannel.serverStats(),
        const MisskeyStreamingChannel.queueStats(),
        const MisskeyStreamingChannel.admin(),
        const MisskeyStreamingChannel.reversi(),
        const MisskeyStreamingChannel.reversiGame(gameId: 'game-id'),
        const MisskeyStreamingChannel.chatUser(otherId: 'other-id'),
        const MisskeyStreamingChannel.chatRoom(roomId: 'room-id'),
      ];

      expect(channels.map((channel) => channel.name), [
        'main',
        'homeTimeline',
        'localTimeline',
        'hybridTimeline',
        'globalTimeline',
        'userList',
        'hashtag',
        'roleTimeline',
        'antenna',
        'channel',
        'drive',
        'serverStats',
        'queueStats',
        'admin',
        'reversi',
        'reversiGame',
        'chatUser',
        'chatRoom',
      ]);
      expect(channels[1].params, {'withRenotes': true, 'withFiles': false});
      expect(channels[2].params, {
        'withRenotes': true,
        'withReplies': false,
        'withFiles': true,
      });
      expect(channels[3].params, {
        'withRenotes': false,
        'withReplies': true,
        'withFiles': false,
      });
      expect(channels[4].params, {'withFiles': true});
      expect(channels[5].params, {
        'listId': 'list-id',
        'withFiles': false,
        'withRenotes': true,
      });
      expect(channels[6].params, {
        'q': [
          ['dart', 'flutter'],
        ],
      });
      expect(channels[7].params, {'roleId': 'role-id'});
      expect(channels[8].params, {'antennaId': 'antenna-id'});
      expect(channels[9].params, {'channelId': 'channel-id'});
      expect(channels[15].params, {'gameId': 'game-id'});
      expect(channels[16].params, {'otherId': 'other-id'});
      expect(channels[17].params, {'roomId': 'room-id'});
    });

    test('omits every optional null parameter', () {
      expect(const MisskeyStreamingChannel.homeTimeline().params, isEmpty);
      expect(const MisskeyStreamingChannel.localTimeline().params, isEmpty);
      expect(const MisskeyStreamingChannel.hybridTimeline().params, isEmpty);
      expect(const MisskeyStreamingChannel.globalTimeline().params, isEmpty);
      expect(const MisskeyStreamingChannel.userList(listId: 'list-id').params, {
        'listId': 'list-id',
      });
    });

    test('rejects empty required IDs and hashtag conditions', () async {
      final client = createClient(FakeChannelSocket()..completeReady());

      for (final channel in <MisskeyStreamingChannel>[
        const MisskeyStreamingChannel.userList(listId: ''),
        const MisskeyStreamingChannel.roleTimeline(roleId: ' '),
        const MisskeyStreamingChannel.antenna(antennaId: ''),
        const MisskeyStreamingChannel.channel(channelId: ''),
        const MisskeyStreamingChannel.reversiGame(gameId: ''),
        const MisskeyStreamingChannel.chatUser(otherId: ''),
        const MisskeyStreamingChannel.chatRoom(roomId: ''),
        const MisskeyStreamingChannel.hashtag(q: []),
        const MisskeyStreamingChannel.hashtag(q: [[]]),
        const MisskeyStreamingChannel.hashtag(
          q: [
            [''],
          ],
        ),
      ]) {
        await expectLater(
          client.subscribe(channel),
          throwsA(isA<MisskeyStreamingSubscriptionException>()),
        );
      }

      await client.dispose();
    });

    test('typed subscribe sends the official channel payload', () async {
      final socket = FakeChannelSocket()..completeReady();
      socket.onAdd = (message) {
        if (message['type'] == 'connect') {
          scheduleMicrotask(
            () => socket.emitConnected(bodyOf(message)['id']! as String),
          );
        }
      };
      final client = createClient(socket);
      await client.connect();

      final subscription = await client.subscribe(
        const MisskeyStreamingChannel.localTimeline(withReplies: true),
      );

      expect(socket.sent.single, {
        'type': 'connect',
        'body': {
          'channel': 'localTimeline',
          'id': subscription.id,
          'params': {'withReplies': true},
          'pong': true,
        },
      });

      await client.dispose();
    });

    test('rejects typed duplicates only for the six shared channels', () async {
      final socket = FakeChannelSocket()..completeReady();
      socket.onAdd = (message) {
        if (message['type'] == 'connect') {
          scheduleMicrotask(
            () => socket.emitConnected(bodyOf(message)['id']! as String),
          );
        }
      };
      final client = createClient(socket);
      await client.connect();

      final sharedChannels = <MisskeyStreamingChannel>[
        const MisskeyStreamingChannel.main(),
        const MisskeyStreamingChannel.drive(),
        const MisskeyStreamingChannel.serverStats(),
        const MisskeyStreamingChannel.queueStats(),
        const MisskeyStreamingChannel.admin(),
        const MisskeyStreamingChannel.reversi(),
      ];
      for (final channel in sharedChannels) {
        await client.subscribe(channel);
        await expectLater(
          client.subscribe(channel),
          throwsA(
            isA<MisskeyStreamingSubscriptionException>().having(
              (error) => error.context?['channel'],
              'channel',
              channel.name,
            ),
          ),
        );
      }

      await client.subscribe(const MisskeyStreamingChannel.homeTimeline());
      await client.subscribe(const MisskeyStreamingChannel.homeTimeline());

      await client.dispose();
    });

    test('keeps raw channels as a forward-compatible escape hatch', () async {
      final socket = FakeChannelSocket()..completeReady();
      socket.onAdd = (message) {
        if (message['type'] == 'connect') {
          scheduleMicrotask(
            () => socket.emitConnected(bodyOf(message)['id']! as String),
          );
        }
      };
      final client = createClient(socket);
      await client.connect();

      await client.subscribeRaw(channel: 'main');
      await client.subscribeRaw(channel: 'main');
      await client.subscribeRaw(
        channel: 'futureChannel',
        params: const {'futureParameter': true},
      );

      await client.dispose();
    });
  });
}

MisskeyStreaming createClient(FakeChannelSocket socket) =>
    MisskeyStreaming.withConnector(
      baseUrl: Uri.parse('https://misskey.example'),
      config: MisskeyStreamingConfig(enableAutoReconnect: false),
      connector: (_) => socket,
    );

Map<String, Object?> bodyOf(Map<String, Object?> message) =>
    (message['body']! as Map<Object?, Object?>).cast<String, Object?>();

final class FakeChannelSocket implements StreamingSocket {
  final Completer<void> _ready = Completer<void>();
  final StreamController<Object?> _messages = StreamController<Object?>();
  final List<Map<String, Object?>> sent = [];
  void Function(Map<String, Object?> message)? onAdd;

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
  Future<void> close([int? closeCode, String? closeReason]) async {}

  void completeReady() => _ready.complete();

  void emitConnected(String id) {
    _messages.add(
      jsonEncode({
        'type': 'connected',
        'body': {'id': id},
      }),
    );
  }
}
