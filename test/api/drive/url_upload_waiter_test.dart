import 'dart:async';

import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/client/misskey_http.dart';
import 'package:test/test.dart';

import '../../support/drive_fixtures.dart';
import '../../support/fake_streaming_socket.dart';
import '../../support/scripted_http_adapter.dart';

void main() {
  const path = '/drive/files/upload-from-url';
  const url = 'https://private.example/file?secret=value';
  late ScriptedHttpClientAdapter adapter;
  late MisskeyHttp http;
  late FakeStreamingSocket socket;
  late MisskeyStreaming streaming;
  late DriveApi drive;
  late MisskeyStreamingSubscription mainSub;
  late int providerCalls;

  setUp(() async {
    adapter = ScriptedHttpClientAdapter();
    http = MisskeyHttp(
      config: MisskeyClientConfig(
        baseUrl: Uri.parse('https://misskey.example'),
      ),
      httpClientAdapter: adapter,
    );
    socket = FakeStreamingSocket();
    streaming = MisskeyStreaming.withConnector(
      baseUrl: http.baseUrl,
      connector: FakeStreamingConnector([socket]).call,
    );
    providerCalls = 0;
    drive = DriveApi(
      http: http,
      streaming: () {
        providerCalls++;
        return streaming;
      },
    );
    await streaming.connect();
    mainSub = await streaming.subscribe(MisskeyStreamingChannel.main());
  });

  tearDown(() async {
    await streaming.dispose();
    http.close();
  });

  void emit(String marker, String id, {String? subscriptionId}) {
    socket.emitChannel(subscriptionId ?? mainSub.id, 'urlUploadFinished', {
      'marker': marker,
      'file': driveFileJson(id: id),
    });
  }

  test(
    'reuses main, catches events during HTTP, and forwards arguments',
    () async {
      adapter.on(path, (request) async {
        expect(request.jsonBody, {
          'url': url,
          'folderId': 'folder',
          'isSensitive': true,
          'comment': 'comment',
          'force': true,
          'marker': 'Custom Marker',
        });
        emit('Custom Marker', 'file');
        await Future<void>.delayed(Duration.zero);
        return ScriptedResponse.noContent();
      });
      final file = await drive.uploadFromUrlAndWait(
        url: url,
        folderId: 'folder',
        isSensitive: true,
        comment: 'comment',
        force: true,
        marker: 'Custom Marker',
      );
      expect(file.id, 'file');
      expect(providerCalls, 1);
      expect(socket.sentFrames.map((frame) => frame['type']), ['connect']);
      expect(mainSub.isActive, isTrue);
    },
  );

  test(
    'uses explicit subscription rather than first registered main',
    () async {
      final second = await streaming.subscribeRaw(channel: 'main');
      adapter.on(path, (request) {
        emit('explicit', 'second', subscriptionId: second.id);
        return ScriptedResponse.noContent();
      });
      expect(
        (await drive.uploadFromUrlAndWait(
          url: url,
          marker: 'explicit',
          mainSubscription: second,
        )).id,
        'second',
      );
    },
  );

  test(
    'generates lowercase secure marker and ignores unrelated events',
    () async {
      adapter.on(path, (request) {
        final marker = request.jsonBody!['marker'] as String;
        expect(marker, matches(RegExp(r'^[0-9a-f]{32}$')));
        emit('other-marker', 'wrong');
        socket.emitChannel(mainSub.id, 'otherType', {'marker': marker});
        socket.emitChannel(mainSub.id, 'urlUploadFinished', null);
        emit(marker, 'right');
        return ScriptedResponse.noContent();
      });
      expect((await drive.uploadFromUrlAndWait(url: url)).id, 'right');
    },
  );

  test('timeout contains marker but not URL', () async {
    adapter.enqueue(path, ScriptedResponse.noContent());
    const timeout = Duration(milliseconds: 10);
    await expectLater(
      drive.uploadFromUrlAndWait(url: url, marker: 'timeout', timeout: timeout),
      throwsA(
        isA<MisskeyStreamingTimeoutException>()
            .having((e) => e.operation, 'operation', 'uploadFromUrlAndWait')
            .having((e) => e.timeout, 'timeout', timeout)
            .having((e) => e.context, 'context', {'marker': 'timeout'})
            .having((e) => e.toString(), 'description', isNot(contains(url))),
      ),
    );
  });

  test('concurrent uploads resolve their own markers', () async {
    final both = Completer<void>();
    adapter.on(path, (request) {
      if (adapter.requests.length == 2) both.complete();
      return ScriptedResponse.noContent();
    });
    final first = drive.uploadFromUrlAndWait(url: url, marker: 'one');
    final second = drive.uploadFromUrlAndWait(url: url, marker: 'two');
    await both.future;
    emit('two', 'file-two');
    emit('one', 'file-one');
    expect((await first).id, 'file-one');
    expect((await second).id, 'file-two');
  });

  test(
    'missing main and disconnected streaming send no HTTP request',
    () async {
      await mainSub.unsubscribe();
      await expectLater(
        drive.uploadFromUrlAndWait(url: url),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'guidance',
            contains(
              'subscribe to MisskeyStreamingChannel.main() and connect first',
            ),
          ),
        ),
      );
      expect(adapter.requests, isEmpty);
      mainSub = await streaming.subscribe(MisskeyStreamingChannel.main());
      await streaming.disconnect();
      await expectLater(drive.uploadFromUrlAndWait(url: url), throwsStateError);
      expect(adapter.requests, isEmpty);
    },
  );

  test(
    'explicit subscription checks its owner with or without a provider',
    () async {
      final other = MisskeyStreaming.withConnector(
        baseUrl: http.baseUrl,
        connector: FakeStreamingConnector([FakeStreamingSocket()]).call,
      );
      addTearDown(other.dispose);
      await other.connect();
      final disconnectedSub = await other.subscribe(
        MisskeyStreamingChannel.main(),
      );
      await other.disconnect();
      for (final api in [drive, DriveApi(http: http)]) {
        await expectLater(
          api.uploadFromUrlAndWait(url: url, mainSubscription: disconnectedSub),
          throwsStateError,
        );
      }
      expect(adapter.requests, isEmpty);

      adapter.on(path, (request) {
        emit(request.jsonBody!['marker'] as String, 'connected-owner');
        return ScriptedResponse.noContent();
      });
      final api = DriveApi(http: http, streaming: () => other);
      expect(
        (await api.uploadFromUrlAndWait(
          url: url,
          mainSubscription: mainSub,
        )).id,
        'connected-owner',
      );
    },
  );

  test('disposal after HTTP succeeds closes an outstanding wait', () async {
    final received = Completer<void>();
    adapter.on(path, (request) {
      received.complete();
      return ScriptedResponse.noContent();
    });
    final result = drive.uploadFromUrlAndWait(url: url);
    final assertion = expectLater(
      result,
      throwsA(isA<MisskeyStreamingSubscriptionException>()),
    );
    await received.future;
    // HTTP 応答処理のマイクロタスクが完了してから破棄する。
    await Future<void>.delayed(Duration.zero);
    expect(adapter.inFlight, 0);
    await streaming.dispose();
    await assertion;
  });

  test('missing provider and subscription sends no HTTP request', () async {
    await expectLater(
      DriveApi(http: http).uploadFromUrlAndWait(url: url),
      throwsStateError,
    );
    expect(adapter.requests, isEmpty);
  });

  test(
    'rejects wrong channel, inactive subscription, and empty marker',
    () async {
      final other = await streaming.subscribeRaw(channel: 'homeTimeline');
      await expectLater(
        drive.uploadFromUrlAndWait(url: url, mainSubscription: other),
        throwsArgumentError,
      );
      await other.unsubscribe();
      await expectLater(
        drive.uploadFromUrlAndWait(url: url, marker: ''),
        throwsArgumentError,
      );
      await mainSub.unsubscribe();
      await expectLater(
        drive.uploadFromUrlAndWait(url: url, mainSubscription: mainSub),
        throwsStateError,
      );
      expect(adapter.requests, isEmpty);
    },
  );

  test('subscription closed during HTTP is a typed error', () async {
    adapter.on(path, (request) async {
      await mainSub.unsubscribe();
      return ScriptedResponse.noContent();
    });
    await expectLater(
      drive.uploadFromUrlAndWait(url: url),
      throwsA(isA<MisskeyStreamingSubscriptionException>()),
    );
  });

  test('malformed matching file during HTTP is a protocol error', () async {
    adapter.on(path, (request) async {
      socket.emitChannel(mainSub.id, 'urlUploadFinished', {
        'marker': request.jsonBody!['marker'],
        'file': {},
      });
      await Future<void>.delayed(Duration.zero);
      return ScriptedResponse.noContent();
    });
    await expectLater(
      drive.uploadFromUrlAndWait(url: url),
      throwsA(isA<MisskeyStreamingProtocolException>()),
    );
  });

  test('HTTP 429 is rethrown and listener is cancelled', () async {
    var cancelled = false;
    final messages = StreamController<MisskeyStreamingMessage>.broadcast(
      onCancel: () => cancelled = true,
    );
    final sub = MisskeyStreamingSubscription(
      id: 'instrumented',
      channel: 'main',
      params: const {},
      messages: messages.stream,
      events: const Stream.empty(),
      onUnsubscribe: () async {},
      onIsActive: () => mainSub.isActive,
      onIsConnected: () => streaming.isConnected,
      onCaptureNote: (_) {},
      onUncaptureNote: (_) {},
    );
    adapter.on(path, (request) {
      expect(messages.hasListener, isTrue);
      return ScriptedResponse.error(429, code: 'RATE_LIMIT_EXCEEDED');
    });
    await expectLater(
      DriveApi(
        http: http,
      ).uploadFromUrlAndWait(url: url, mainSubscription: sub),
      throwsA(isA<MisskeyRateLimitException>()),
    );
    expect(cancelled, isTrue);
    expect(messages.hasListener, isFalse);
    expect(adapter.requests, hasLength(1));
    await messages.close();
  });

  test('MisskeyClient constructs and lazily supplies streaming', () async {
    final client = testClient(adapter);
    expect(client.drive, isA<DriveApi>());
    await expectLater(
      client.drive.uploadFromUrlAndWait(url: url),
      throwsStateError,
    );
    expect(client.streaming.subscriptions, isEmpty);
    expect(adapter.requests, isEmpty);
    await client.dispose();
  });
}
