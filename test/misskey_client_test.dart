import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  test('MisskeyClient can be instantiated', () {
    final client = MisskeyClient(
      config: MisskeyClientConfig(
        baseUrl: Uri.parse('https://misskey.example.com'),
      ),
    );
    expect(client, isNotNull);
  });

  group('baseUrl', () {
    test('returns the configured base URL as-is', () {
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
      );
      expect(client.baseUrl, Uri.parse('https://misskey.example.com'));
    });

    test('does not append the internal /api suffix', () {
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
      );
      expect(client.baseUrl.path, isNot(contains('/api')));
    });

    test('preserves a port and a sub path', () {
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('http://localhost:3000/instance'),
        ),
      );
      expect(client.baseUrl, Uri.parse('http://localhost:3000/instance'));
      expect(client.baseUrl.port, 3000);
    });

    test('keeps a base URL that already ends with /api unchanged', () {
      // 利用側が /api 付きのURLを渡した場合も、受け取った値をそのまま返す
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com/api'),
        ),
      );
      expect(client.baseUrl, Uri.parse('https://misskey.example.com/api'));
    });
  });

  group('streaming', () {
    test(
      'lazily reuses one instance with the supplied configuration',
      () async {
        final streamingConfig = MisskeyStreamingConfig(
          enableAutoReconnect: false,
          connectTimeout: const Duration(seconds: 3),
        );
        final client = MisskeyClient(
          config: MisskeyClientConfig(
            baseUrl: Uri.parse('https://misskey.example.com'),
            enableLog: true,
          ),
          tokenProvider: () => 'token',
          streamingConfig: streamingConfig,
        );

        final first = client.streaming;
        final second = client.streaming;

        expect(second, same(first));
        expect(first.config, same(streamingConfig));
        expect(first.state, MisskeyStreamingConnectionState.disconnected);

        await client.dispose();
      },
    );

    test('disposes an already created Streaming client', () async {
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
      );
      final streaming = client.streaming;

      await client.dispose();

      expect(streaming.state, MisskeyStreamingConnectionState.disposed);
      expect(() => client.streaming, throwsStateError);
      expect(streaming.connect, throwsStateError);
    });

    test(
      'shares the HTTP base URL, token provider, and logging settings',
      () async {
        var tokenCalls = 0;
        final logMessages = <String>[];
        final client = MisskeyClient(
          config: MisskeyClientConfig(
            baseUrl: Uri.parse('ftp://misskey.example.com/subpath'),
            enableLog: true,
          ),
          tokenProvider: () {
            tokenCalls++;
            return 'token';
          },
          logger: FunctionLogger(
            (level, message) => logMessages.add('$level: $message'),
          ),
        );

        await expectLater(
          client.streaming.connect(),
          throwsA(
            isA<MisskeyStreamingConnectionException>()
                .having(
                  (error) => error.operation,
                  'operation',
                  'buildStreamingUri',
                )
                .having(
                  (error) => error.context?['scheme'],
                  'base URL scheme',
                  'ftp',
                ),
          ),
        );

        expect(tokenCalls, 1);
        expect(
          logMessages,
          contains(contains('Misskey Streaming API operation failed')),
        );

        await client.dispose();
      },
    );
  });

  group('dispose', () {
    test(
      'does not create Streaming and force-closes the HTTP adapter',
      () async {
        final adapter = RecordingHttpClientAdapter();
        final client = MisskeyClient(
          config: MisskeyClientConfig(
            baseUrl: Uri.parse('https://misskey.example.com'),
          ),
          httpClientAdapter: adapter,
        );

        await client.dispose();

        expect(adapter.closeForces, [isTrue]);
        expect(() => client.streaming, throwsStateError);
      },
    );

    test('returns the same future for concurrent and repeated calls', () async {
      final adapter = RecordingHttpClientAdapter();
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
        httpClientAdapter: adapter,
      );
      final streaming = client.streaming;

      final first = client.dispose();
      final concurrent = client.dispose();

      expect(concurrent, same(first));
      expect(() => client.streaming, throwsStateError);

      await first;
      final repeated = client.dispose();

      expect(repeated, same(first));
      expect(adapter.closeForces, [isTrue]);
      expect(streaming.state, MisskeyStreamingConnectionState.disposed);
    });
  });
}

final class RecordingHttpClientAdapter implements HttpClientAdapter {
  final List<bool> closeForces = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => throw UnimplementedError('No HTTP request is expected in this test');

  @override
  void close({bool force = false}) => closeForces.add(force);
}
