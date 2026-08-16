import 'dart:async';
import 'dart:convert';

import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/streaming/internal/streaming_socket.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyStreaming connection lifecycle', () {
    test('waits for socket ready before becoming connected', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final client = createClient(connector);
      final states = <MisskeyStreamingConnectionState>[];
      final stateSubscription = client.stateChanges.listen(states.add);

      final connecting = client.connect();
      await connector.nextConnection;

      expect(client.state, MisskeyStreamingConnectionState.connecting);
      expect(client.isConnected, isFalse);

      socket.completeReady();
      await connecting;
      await flushEvents();

      expect(client.state, MisskeyStreamingConnectionState.connected);
      expect(states, [
        MisskeyStreamingConnectionState.connecting,
        MisskeyStreamingConnectionState.connected,
      ]);

      await client.dispose();
      await stateSubscription.cancel();
    });

    test('concurrent connect calls share one socket attempt', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final client = createClient(connector);

      final first = client.connect();
      final second = client.connect();
      await connector.nextConnection;
      expect(connector.callCount, 1);

      socket.completeReady();
      await Future.wait([first, second]);
      expect(connector.callCount, 1);

      await client.dispose();
    });

    test('times out ready and ignores a late completion', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final client = createClient(
        connector,
        config: MisskeyStreamingConfig(
          connectTimeout: const Duration(milliseconds: 5),
        ),
      );

      await expectLater(
        client.connect(),
        throwsA(isA<MisskeyStreamingTimeoutException>()),
      );
      await flushEvents();
      expect(client.state, MisskeyStreamingConnectionState.disconnected);
      expect(socket.closeCalls, 1);

      socket.completeReady();
      await flushEvents();
      expect(client.state, MisskeyStreamingConnectionState.disconnected);
      expect(connector.callCount, 1);

      await client.dispose();
    });

    test('does not connect anonymously when tokenProvider fails', () async {
      final connector = FakeConnector([]);
      final logger = RecordingLogger();
      final client = createClient(
        connector,
        tokenProvider: () => throw StateError('token unavailable'),
        logger: logger,
      );

      await expectLater(
        client.connect(),
        throwsA(
          isA<MisskeyStreamingConnectionException>().having(
            (exception) => exception.cause,
            'cause',
            isA<StateError>(),
          ),
        ),
      );

      expect(connector.callCount, 0);
      expect(client.state, MisskeyStreamingConnectionState.disconnected);
      expect(logger.messages.join('\n'), isNot(contains('token unavailable')));

      await client.dispose();
    });

    test(
      'does not create a socket when disconnected during token lookup',
      () async {
        final token = Completer<String?>();
        final connector = FakeConnector([]);
        final client = createClient(
          connector,
          tokenProvider: () => token.future,
        );

        final connecting = client.connect();
        await flushEvents();
        await client.disconnect();
        token.complete('secret');
        await connecting;

        expect(connector.callCount, 0);
        expect(client.state, MisskeyStreamingConnectionState.disconnected);

        await client.dispose();
      },
    );

    test(
      'disconnect during ready prevents late connection and reconnect',
      () async {
        final socket = FakeStreamingSocket();
        final connector = FakeConnector([socket]);
        final client = createClient(connector);

        final connecting = client.connect();
        await connector.nextConnection;
        await client.disconnect();
        socket.completeReady();
        await connecting;
        await flushEvents();

        expect(client.state, MisskeyStreamingConnectionState.disconnected);
        expect(socket.closeCalls, 1);
        expect(connector.callCount, 1);

        await client.dispose();
      },
    );

    test('onError followed by onDone schedules one reconnect', () async {
      final firstSocket = FakeStreamingSocket();
      final secondSocket = FakeStreamingSocket();
      final connector = FakeConnector([firstSocket, secondSocket]);
      final client = createClient(connector, config: reconnectConfig());

      final initial = client.connect();
      await connector.nextConnection;
      firstSocket.completeReady();
      await initial;

      firstSocket.addError(StateError('network failed'));
      await firstSocket.finish();
      await connector.connectionCount(2);
      secondSocket.completeReady();
      await waitForState(client, MisskeyStreamingConnectionState.connected);

      expect(connector.callCount, 2);

      await client.dispose();
    });

    test(
      'retries failed automatic attempts with capped exponential delay',
      () async {
        final firstSocket = FakeStreamingSocket();
        final secondSocket = FakeStreamingSocket();
        final thirdSocket = FakeStreamingSocket();
        final connector = FakeConnector([
          firstSocket,
          secondSocket,
          thirdSocket,
        ]);
        final logger = RecordingLogger();
        final client = createClient(
          connector,
          config: MisskeyStreamingConfig(
            connectTimeout: const Duration(milliseconds: 100),
            reconnectInitialDelay: const Duration(milliseconds: 2),
            reconnectMaxDelay: const Duration(milliseconds: 4),
            maxReconnectAttempts: 2,
          ),
          logger: logger,
          enableLog: true,
        );

        final initial = client.connect();
        await connector.nextConnection;
        firstSocket.completeReady();
        await initial;

        await firstSocket.finish();
        await connector.connectionCount(2);
        secondSocket.failReady(StateError('reconnect failed'));
        await connector.connectionCount(3);
        thirdSocket.completeReady();
        await waitForState(client, MisskeyStreamingConnectionState.connected);

        expect(connector.callCount, 3);
        expect(logger.messages, contains(contains('in 2ms (attempt 1)')));
        expect(logger.messages, contains(contains('in 4ms (attempt 2)')));

        await client.dispose();
      },
    );

    test('ignores callbacks from a superseded socket generation', () async {
      final firstSocket = FakeStreamingSocket();
      final secondSocket = FakeStreamingSocket();
      final connector = FakeConnector([firstSocket, secondSocket]);
      var tokenCalls = 0;
      final client = createClient(
        connector,
        tokenProvider: () => 'token-${++tokenCalls}',
      );

      final initial = client.connect();
      await connector.nextConnection;
      firstSocket.completeReady();
      await initial;

      final reconnecting = client.reconnect();
      await connector.connectionCount(2);
      secondSocket.completeReady();
      await reconnecting;
      await firstSocket.finish();
      await flushEvents();

      expect(client.state, MisskeyStreamingConnectionState.connected);
      expect(connector.callCount, 2);
      expect(tokenCalls, 2);
      expect(connector.uris[0].queryParameters['i'], 'token-1');
      expect(connector.uris[1].queryParameters['i'], 'token-2');

      await client.dispose();
    });

    test('disconnect cancels a pending reconnect timer', () async {
      final firstSocket = FakeStreamingSocket();
      final secondSocket = FakeStreamingSocket();
      final connector = FakeConnector([firstSocket, secondSocket]);
      final client = createClient(
        connector,
        config: MisskeyStreamingConfig(
          reconnectInitialDelay: const Duration(milliseconds: 50),
          reconnectMaxDelay: const Duration(milliseconds: 50),
        ),
      );

      final initial = client.connect();
      await connector.nextConnection;
      firstSocket.completeReady();
      await initial;
      firstSocket.addError(StateError('network failed'));
      await flushEvents();
      await client.disconnect();
      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(connector.callCount, 1);
      expect(client.state, MisskeyStreamingConnectionState.disconnected);

      await client.dispose();
    });

    test('does not retry an explicit initial connection failure', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final client = createClient(connector, config: reconnectConfig());

      final connecting = client.connect();
      await connector.nextConnection;
      socket.failReady(StateError('handshake failed'));

      await expectLater(
        connecting,
        throwsA(isA<MisskeyStreamingConnectionException>()),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(connector.callCount, 1);

      await client.dispose();
    });

    test('handles ready error, stream error, and done only once', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final client = createClient(connector, config: reconnectConfig());
      final errors = <MisskeyStreamingException>[];
      final errorSubscription = client.errors.listen(errors.add);

      final connecting = client.connect();
      await connector.nextConnection;
      final connectionFailure = expectLater(
        connecting,
        throwsA(isA<MisskeyStreamingConnectionException>()),
      );
      final failure = StateError('handshake failed');
      socket
        ..failReady(failure)
        ..addError(failure);
      await socket.finish();

      await connectionFailure;
      await flushEvents();
      expect(errors, hasLength(1));
      expect(socket.closeCalls, 1);
      expect(connector.callCount, 1);

      await errorSubscription.cancel();
      await client.dispose();
    });

    test('honors a zero automatic reconnect limit', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final client = createClient(
        connector,
        config: MisskeyStreamingConfig(maxReconnectAttempts: 0),
      );
      final errors = <MisskeyStreamingException>[];
      final errorSubscription = client.errors.listen(errors.add);

      final connecting = client.connect();
      await connector.nextConnection;
      socket.completeReady();
      await connecting;
      await socket.finish();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(connector.callCount, 1);
      expect(client.state, MisskeyStreamingConnectionState.disconnected);
      expect(errors, hasLength(1));
      expect(errors.single.operation, 'reconnect');

      await errorSubscription.cancel();
      await client.dispose();
    });

    test('dispose is idempotent and prevents later operations', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final client = createClient(connector);
      final states = <MisskeyStreamingConnectionState>[];
      final stateDone = Completer<void>();
      client.stateChanges.listen(states.add, onDone: stateDone.complete);

      final connecting = client.connect();
      await connector.nextConnection;
      socket.completeReady();
      await connecting;

      final firstDispose = client.dispose();
      final secondDispose = client.dispose();
      expect(identical(firstDispose, secondDispose), isTrue);
      await Future.wait([firstDispose, secondDispose]);
      await client.dispose();
      await stateDone.future;

      expect(socket.closeCalls, 1);
      expect(client.state, MisskeyStreamingConnectionState.disposed);
      expect(states.last, MisskeyStreamingConnectionState.disposed);
      expect(client.connect, throwsStateError);
      expect(client.reconnect, throwsStateError);
    });
  });

  group('MisskeyStreaming messages and logging', () {
    test('does not call the logger when logging is disabled', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final logger = RecordingLogger();
      final client = createClient(connector, logger: logger);

      final connecting = client.connect();
      await connector.nextConnection;
      socket.completeReady();
      await connecting;
      socket.addMessage('not-json');
      await flushEvents();
      await client.dispose();

      expect(logger.messages, isEmpty);
    });

    test('decodes text and binary JSON without logging payloads', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final logger = RecordingLogger();
      final client = createClient(connector, logger: logger, enableLog: true);
      final messages = <MisskeyStreamingMessage>[];
      final subscription = client.messages.listen(messages.add);

      final connecting = client.connect();
      await connector.nextConnection;
      socket.completeReady();
      await connecting;
      socket
        ..addMessage('{"type":"pong"}')
        ..addMessage(utf8.encode('{"type":"deleted","body":"secret-id"}'));
      await flushEvents();

      expect(messages.map((message) => message.type), ['pong', 'deleted']);
      expect(messages.last.body, 'secret-id');
      expect(logger.messages.join('\n'), isNot(contains('secret-id')));

      await subscription.cancel();
      await client.dispose();
    });

    test('reports malformed messages without closing the socket', () async {
      final socket = FakeStreamingSocket();
      final connector = FakeConnector([socket]);
      final logger = RecordingLogger();
      final client = createClient(connector, logger: logger, enableLog: true);
      final errors = <MisskeyStreamingException>[];
      final subscription = client.errors.listen(errors.add);

      final connecting = client.connect();
      await connector.nextConnection;
      socket.completeReady();
      await connecting;
      socket
        ..addMessage('not-json-private-payload')
        ..addMessage('{"type":"pong"}');
      await flushEvents();

      expect(errors.single, isA<MisskeyStreamingProtocolException>());
      expect(client.state, MisskeyStreamingConnectionState.connected);
      expect(
        logger.messages.join('\n'),
        isNot(contains('not-json-private-payload')),
      );

      await subscription.cancel();
      await client.dispose();
    });

    test('never includes the token or token-bearing errors in logs', () async {
      const token = 'super-secret-token';
      final logger = RecordingLogger();
      final connector = ThrowingConnector(
        (uri) => StateError('Could not open $uri'),
      );
      final client = MisskeyStreaming.withConnector(
        baseUrl: Uri.parse('https://user:password@misskey.example/sub'),
        tokenProvider: () => token,
        config: reconnectConfig(),
        logger: logger,
        enableLog: true,
        connector: connector.call,
        jitterSource: () => 0.5,
      );

      await expectLater(
        client.connect(),
        throwsA(isA<MisskeyStreamingConnectionException>()),
      );

      final logs = logger.messages.join('\n');
      expect(logs, isNot(contains(token)));
      expect(logs, isNot(contains('password')));
      expect(logs, isNot(contains('?i=')));
      expect(connector.uri?.queryParameters['i'], token);

      await client.dispose();
    });
  });
}

MisskeyStreaming createClient(
  FakeConnector connector, {
  TokenProvider? tokenProvider,
  MisskeyStreamingConfig? config,
  Logger? logger,
  bool enableLog = false,
}) => MisskeyStreaming.withConnector(
  baseUrl: Uri.parse('https://misskey.example'),
  tokenProvider: tokenProvider,
  config: config,
  logger: logger ?? RecordingLogger(),
  enableLog: enableLog,
  connector: connector.call,
  jitterSource: () => 0.5,
);

MisskeyStreamingConfig reconnectConfig() => MisskeyStreamingConfig(
  connectTimeout: const Duration(milliseconds: 100),
  reconnectInitialDelay: const Duration(milliseconds: 1),
  reconnectMaxDelay: const Duration(milliseconds: 1),
);

Future<void> flushEvents() => Future<void>.delayed(Duration.zero);

Future<void> waitForState(
  MisskeyStreaming client,
  MisskeyStreamingConnectionState expected,
) async {
  if (client.state == expected) {
    return;
  }
  await client.stateChanges
      .firstWhere((state) => state == expected)
      .timeout(const Duration(seconds: 1));
}

final class FakeConnector {
  FakeConnector(this._sockets);

  final List<FakeStreamingSocket> _sockets;
  final List<Uri> uris = [];
  final StreamController<int> _connections = StreamController<int>.broadcast(
    sync: true,
  );
  int callCount = 0;

  Future<void> get nextConnection => connectionCount(callCount + 1);

  Future<void> connectionCount(int expected) {
    if (callCount >= expected) {
      return Future<void>.value();
    }
    return _connections.stream
        .firstWhere((count) => count >= expected)
        .timeout(const Duration(seconds: 1));
  }

  StreamingSocket call(Uri uri) {
    uris.add(uri);
    final index = callCount++;
    _connections.add(callCount);
    if (index >= _sockets.length) {
      throw StateError('No fake socket configured for call $callCount');
    }
    return _sockets[index];
  }
}

final class ThrowingConnector {
  ThrowingConnector(this._errorFactory);

  final Object Function(Uri uri) _errorFactory;
  Uri? uri;

  StreamingSocket call(Uri uri) {
    this.uri = uri;
    throw _errorFactory(uri);
  }
}

final class FakeStreamingSocket implements StreamingSocket {
  final Completer<void> _ready = Completer<void>();
  final StreamController<Object?> _streamController =
      StreamController<Object?>();
  int closeCalls = 0;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  Future<void> get ready => _ready.future;

  @override
  Stream<Object?> get stream => _streamController.stream;

  @override
  void add(String data) {}

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    closeCalls++;
  }

  void completeReady() {
    if (!_ready.isCompleted) {
      _ready.complete();
    }
  }

  void failReady(Object error) {
    if (!_ready.isCompleted) {
      _ready.completeError(error, StackTrace.current);
    }
  }

  void addMessage(Object? message) => _streamController.add(message);

  void addError(Object error) =>
      _streamController.addError(error, StackTrace.current);

  Future<void> finish() async {
    if (!_streamController.isClosed) {
      await _streamController.close();
    }
  }
}

final class RecordingLogger implements Logger {
  final List<String> messages = [];

  @override
  void debug(String message) => messages.add('debug:$message');

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    messages.add('error:$message');
  }

  @override
  void info(String message) => messages.add('info:$message');

  @override
  void warn(String message) => messages.add('warn:$message');
}
