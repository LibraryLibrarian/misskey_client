import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MetaApi endpoint capabilities', () {
    test('accepts the endpoint list captured from a real server', () async {
      final fixture = jsonDecode(
        File('test/fixtures/endpoints.json').readAsStringSync(),
      );
      final adapter = _QueuedHttpClientAdapter([_Response.ok(fixture)]);
      final client = _client(adapter);

      final endpoints = await client.meta.getEndpoints();

      expect(endpoints, contains('notes/drafts/create'));
      expect(
        await client.meta.isEndpointAvailable(
          endpoint: 'users/get-following-users-by-birthday',
        ),
        isTrue,
      );
      expect(adapter.requestCount, 1);

      await client.dispose();
    });

    test('caches a deduplicated and immutable endpoint list', () async {
      final adapter = _QueuedHttpClientAdapter([
        _Response.ok(['notes/create', 'notes/create', 'users/show']),
      ]);
      final client = _client(adapter);

      final first = await client.meta.getEndpoints();
      final second = await client.meta.getEndpoints();

      expect(first, ['notes/create', 'users/show']);
      expect(second, first);
      expect(adapter.requestCount, 1);
      expect(() => first.add('notes/delete'), throwsUnsupportedError);

      await client.dispose();
    });

    test('refresh replaces a completed cache entry', () async {
      final adapter = _QueuedHttpClientAdapter([
        _Response.ok(['notes/create']),
        _Response.ok(['notes/create', 'notes/drafts/create']),
      ]);
      final client = _client(adapter);

      expect(
        await client.meta.isEndpointAvailable(endpoint: 'notes/drafts/create'),
        isFalse,
      );
      expect(
        await client.meta.isEndpointAvailable(
          endpoint: 'notes/drafts/create',
          refresh: true,
        ),
        isTrue,
      );
      expect(adapter.requestCount, 2);

      await client.dispose();
    });

    test('shares one in-flight request between concurrent callers', () async {
      final gate = Completer<void>();
      final adapter = _QueuedHttpClientAdapter([
        _Response.ok(['notes/create']),
      ], gate: gate);
      final client = _client(adapter);

      final first = client.meta.getEndpoints();
      final second = client.meta.getEndpoints(refresh: true);
      await adapter.started.future;

      expect(adapter.requestCount, 1);
      gate.complete();
      expect(await first, ['notes/create']);
      expect(await second, ['notes/create']);

      await client.dispose();
    });

    test(
      'regular caller shares an in-flight refresh instead of stale cache',
      () async {
        final adapter = _QueuedHttpClientAdapter([
          _Response.ok(['notes/create']),
          _Response.ok(['notes/create', 'notes/drafts/create']),
        ]);
        final client = _client(adapter);
        expect(await client.meta.getEndpoints(), ['notes/create']);

        final refreshGate = Completer<void>();
        final refreshStarted = Completer<void>();
        adapter
          ..gate = refreshGate
          ..nextStarted = refreshStarted;

        final refresh = client.meta.getEndpoints(refresh: true);
        await refreshStarted.future;
        final regular = client.meta.getEndpoints();

        expect(adapter.requestCount, 2);
        refreshGate.complete();
        expect(await refresh, ['notes/create', 'notes/drafts/create']);
        expect(await regular, ['notes/create', 'notes/drafts/create']);

        await client.dispose();
      },
    );

    test(
      'failed refresh propagates and preserves the previous cache',
      () async {
        final adapter = _QueuedHttpClientAdapter([
          _Response.ok(['notes/create']),
          const _Response(statusCode: 500, body: {'error': 'temporary'}),
        ]);
        final client = _client(adapter);

        expect(await client.meta.getEndpoints(), ['notes/create']);
        await expectLater(
          client.meta.getEndpoints(refresh: true),
          throwsA(isA<MisskeyServerException>()),
        );
        expect(await client.meta.getEndpoints(), ['notes/create']);
        expect(adapter.requestCount, 2);

        await client.dispose();
      },
    );

    test('failed initial request is not cached', () async {
      final adapter = _QueuedHttpClientAdapter([
        const _Response(statusCode: 500, body: {'error': 'temporary'}),
        _Response.ok(['notes/create']),
      ]);
      final client = _client(adapter);

      await expectLater(
        client.meta.getEndpoints(),
        throwsA(isA<MisskeyServerException>()),
      );
      expect(await client.meta.getEndpoints(), ['notes/create']);
      expect(adapter.requestCount, 2);

      await client.dispose();
    });

    test('does not turn an unavailable enumeration API into false', () async {
      final adapter = _QueuedHttpClientAdapter([
        const _Response(statusCode: 404, body: {'error': 'not found'}),
      ]);
      final client = _client(adapter);

      await expectLater(
        client.meta.isEndpointAvailable(endpoint: 'notes/drafts/create'),
        throwsA(isA<MisskeyNotFoundException>()),
      );
      expect(adapter.requestCount, 1);

      await client.dispose();
    });

    test('rejects malformed endpoint names from the server', () async {
      final adapter = _QueuedHttpClientAdapter([
        _Response.ok(['notes/create', '']),
      ]);
      final client = _client(adapter);

      await expectLater(
        client.meta.getEndpoints(),
        throwsA(isA<FormatException>()),
      );

      await client.dispose();
    });

    test('rejects non-canonical lookup input without a request', () async {
      final adapter = _QueuedHttpClientAdapter([]);
      final client = _client(adapter);

      for (final endpoint in [
        '',
        ' notes/create',
        '/notes/create',
        'notes/create/',
        'notes//create',
        'notes/create?draft=true',
      ]) {
        await expectLater(
          client.meta.isEndpointAvailable(endpoint: endpoint),
          throwsArgumentError,
        );
      }
      expect(adapter.requestCount, 0);

      await client.dispose();
    });
  });

  group('MetaApi metadata key presence', () {
    test('does not interpret a false value as unsupported', () async {
      final meta = jsonDecode(
        File('test/fixtures/meta.json').readAsStringSync(),
      );
      final adapter = _QueuedHttpClientAdapter([_Response.ok(meta)]);
      final client = _client(adapter);

      expect(client.meta.hasMetaKey('features.registration'), isFalse);
      await client.meta.getMeta();
      expect(client.meta.hasMetaKey('features.registration'), isTrue);
      expect(client.meta.hasMetaKey('features.missing'), isFalse);
      expect(client.meta.hasMetaKey('features..registration'), isFalse);

      await client.dispose();
    });
  });
}

MisskeyClient _client(HttpClientAdapter adapter) {
  return MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
      maxRetries: 1,
    ),
    httpClientAdapter: adapter,
  );
}

final class _QueuedHttpClientAdapter implements HttpClientAdapter {
  _QueuedHttpClientAdapter(this.responses, {this.gate});

  final List<_Response> responses;
  Completer<void>? gate;
  Completer<void>? nextStarted;
  final Completer<void> started = Completer<void>();
  int requestCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    if (!started.isCompleted) started.complete();
    nextStarted?.complete();
    nextStarted = null;
    final requestGate = gate;
    await requestGate?.future;
    if (responses.isEmpty) {
      throw StateError('No queued response for ${options.uri.path}');
    }
    final response = responses.removeAt(0);
    return ResponseBody.fromString(
      jsonEncode(response.body),
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

final class _Response {
  const _Response({required this.statusCode, required this.body});

  _Response.ok(Object? body) : this(statusCode: 200, body: body);

  final int statusCode;
  final Object? body;
}
