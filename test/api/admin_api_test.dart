import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('AdminApi.updateMeta', () {
    test('sends typed and untyped instance settings', () async {
      final adapter = _RecordingHttpClientAdapter();
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.admin.updateMeta(
        extra: const {
          'objectStorageBaseUrl': 'https://storage.example.com',
          'enableFanoutTimeline': true,
        },
        disableRegistration: false,
        blockedHosts: const [],
      );

      expect(adapter.path, '/api/admin/update-meta');
      expect(adapter.body, {
        'objectStorageBaseUrl': 'https://storage.example.com',
        'enableFanoutTimeline': true,
        'disableRegistration': false,
        'blockedHosts': <String>[],
      });
    });

    test('omits visitor visibility when it is not supplied', () async {
      final adapter = _RecordingHttpClientAdapter();
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.admin.updateMeta(disableRegistration: true);

      expect(adapter.body, {'disableRegistration': true});
    });

    for (final visibility in ['all', 'local', 'none']) {
      test('sends visitor visibility $visibility when supplied', () async {
        final adapter = _RecordingHttpClientAdapter();
        final client = _createClient(adapter);
        addTearDown(client.dispose);

        await client.admin.updateMeta(ugcVisibilityForVisitor: visibility);

        expect(adapter.path, '/api/admin/update-meta');
        expect(adapter.body, {'ugcVisibilityForVisitor': visibility});
      });
    }

    test('typed parameters take precedence over extra settings', () async {
      final adapter = _RecordingHttpClientAdapter();
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.admin.updateMeta(
        extra: const {
          'description': 'from extra',
          'enableEmail': false,
          'ugcVisibilityForVisitor': 'all',
          'maintainerEmail': 'extra@example.com',
        },
        description: const Optional('typed description'),
        enableEmail: true,
        ugcVisibilityForVisitor: 'local',
      );

      expect(adapter.body, {
        'description': 'typed description',
        'enableEmail': true,
        'ugcVisibilityForVisitor': 'local',
        'maintainerEmail': 'extra@example.com',
      });
    });

    test('Optional.null_ sends an explicit null over extra', () async {
      final adapter = _RecordingHttpClientAdapter();
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.admin.updateMeta(
        extra: const {'description': 'from extra'},
        description: const Optional.null_(),
      );

      expect(adapter.body, {'description': null});
    });

    test('does not send an empty update', () async {
      final adapter = _RecordingHttpClientAdapter();
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.admin.updateMeta();
      await client.admin.updateMeta(extra: const {});

      expect(adapter.requestCount, 0);
    });

    test(
      'passes proxyAccountId only when explicitly supplied through extra',
      () async {
        final adapter = _RecordingHttpClientAdapter();
        final client = _createClient(adapter);
        addTearDown(client.dispose);

        await client.admin.updateMeta(
          extra: const {'proxyAccountId': 'compatible-proxy-account'},
        );

        expect(adapter.requestCount, 1);
        expect(adapter.body, {'proxyAccountId': 'compatible-proxy-account'});
      },
    );

    test('rejects the reserved authentication key in extra', () async {
      final adapter = _RecordingHttpClientAdapter();
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await expectLater(
        client.admin.updateMeta(extra: const {'i': 'other-token'}),
        throwsArgumentError,
      );

      expect(adapter.requestCount, 0);
    });
  });

  group('AdminApi.unsetMfa', () {
    test('sends the target user ID', () async {
      final adapter = _RecordingHttpClientAdapter();
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.admin.unsetMfa(userId: 'user1');

      expect(adapter.path, '/api/admin/unset-mfa');
      expect(adapter.body, {'userId': 'user1'});
    });
  });
}

MisskeyClient _createClient(_RecordingHttpClientAdapter adapter) =>
    MisskeyClient(
      config: MisskeyClientConfig(
        baseUrl: Uri.parse('https://misskey.example.com'),
      ),
      httpClientAdapter: adapter,
    );

final class _RecordingHttpClientAdapter implements HttpClientAdapter {
  String? path;
  Map<String, dynamic>? body;
  int requestCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    path = options.uri.path;
    body = options.data as Map<String, dynamic>;
    return ResponseBody.fromString(
      jsonEncode(null),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
