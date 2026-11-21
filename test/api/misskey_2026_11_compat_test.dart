import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('SwApi.unregister', () {
    for (final token in <String?>[null, 'access-token']) {
      test('sends optional subscription keys with token=$token', () async {
        final adapter = _RecordingAdapter();
        final client = _createClient(adapter, token: token);
        addTearDown(client.dispose);

        for (final keys in <Map<String, String>>[
          {},
          {'auth': 'auth-secret'},
          {'publickey': 'public-key'},
          {'auth': 'auth-secret', 'publickey': 'public-key'},
        ]) {
          await client.sw.unregister(
            endpoint: 'https://push.example.com/subscription',
            auth: keys['auth'],
            publickey: keys['publickey'],
          );

          expect(adapter.path, '/api/sw/unregister');
          expect(adapter.body, {
            'endpoint': 'https://push.example.com/subscription',
            ...keys,
            'i': ?token,
          });
          expect(adapter.extra?['authMode'], 'optional');
        }
      });
    }

    test('keeps idempotent retries enabled', () async {
      final adapter = _RecordingAdapter(initialFailures: 1);
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.sw.unregister(
        endpoint: 'https://push.example.com/subscription',
      );

      expect(adapter.requestCount, 2);
      expect(adapter.body, {
        'endpoint': 'https://push.example.com/subscription',
      });
    });
  });

  group('SwApi.showRegistration', () {
    test('parses the registration when it exists', () async {
      final adapter = _RecordingAdapter(
        response: {
          'userId': 'user1',
          'endpoint': 'https://push.example.com/subscription',
          'sendReadMessage': true,
        },
      );
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      final result = await client.sw.showRegistration(
        endpoint: 'https://push.example.com/subscription',
      );

      expect(result?.endpoint, 'https://push.example.com/subscription');
      expect(result?.sendReadMessage, isTrue);
    });
  });

  final nullableLookups =
      <String, ({String path, Future<Object?> Function(MisskeyClient) call})>{
        'NotesApi.translate': (
          path: '/api/notes/translate',
          call: (client) =>
              client.notes.translate(noteId: 'note-id', targetLang: 'en'),
        ),
        'SwApi.showRegistration': (
          path: '/api/sw/show-registration',
          call: (client) => client.sw.showRegistration(
            endpoint: 'https://push.example.com/subscription',
          ),
        ),
        'MetaApi.getEndpoint': (
          path: '/api/endpoint',
          call: (client) =>
              client.meta.getEndpoint(endpoint: 'missing-endpoint'),
        ),
        'FederationApi.showInstance': (
          path: '/api/federation/show-instance',
          call: (client) =>
              client.federation.showInstance(host: 'unknown.example.com'),
        ),
      };

  for (final lookup in nullableLookups.entries) {
    group('${lookup.key} nullable response', () {
      test(
        'returns null for HTTP 204 without Content-Type or a body',
        () async {
          // null/undefined に対する Misskey の実際の空応答を再現する
          final adapter = _RecordingAdapter(
            rawBody: '',
            statusCode: 204,
            headers: const {},
          );
          final client = _createClient(adapter);
          addTearDown(client.dispose);

          expect(await lookup.value.call(client), isNull);
          expect(adapter.path, lookup.value.path);
        },
      );

      test('returns null for JSON null', () async {
        final adapter = _RecordingAdapter();
        final client = _createClient(adapter);
        addTearDown(client.dispose);

        expect(await lookup.value.call(client), isNull);
      });

      for (final invalid in <Object>['unexpected response', <dynamic>[]]) {
        test(
          'rejects a JSON ${invalid is String ? 'string' : 'array'}',
          () async {
            final adapter = _RecordingAdapter(response: invalid);
            final client = _createClient(adapter);
            addTearDown(client.dispose);

            await expectLater(lookup.value.call(client), throwsFormatException);
          },
        );
      }
    });
  }

  test('MetaApi.getEndpoint parses an existing endpoint object', () async {
    final adapter = _RecordingAdapter(
      response: {
        'params': [
          {'name': 'endpoint', 'type': 'String'},
        ],
      },
    );
    final client = _createClient(adapter);
    addTearDown(client.dispose);

    final result = await client.meta.getEndpoint(endpoint: 'endpoint');

    expect(result?.params.single.name, 'endpoint');
    expect(result?.params.single.type, 'String');
  });

  test(
    'FederationApi.showInstance parses an existing instance object',
    () async {
      final adapter = _RecordingAdapter(
        response: {
          'id': 'instance-id',
          'host': 'known.example.com',
          'firstRetrievedAt': '2026-11-01T00:00:00.000Z',
        },
      );
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      final result = await client.federation.showInstance(
        host: 'known.example.com',
      );

      expect(result?.id, 'instance-id');
      expect(result?.host, 'known.example.com');
      expect(result?.firstRetrievedAt, DateTime.utc(2026, 11, 1));
    },
  );

  test('NotesApi.translate parses a translation object', () async {
    final adapter = _RecordingAdapter(
      response: {'sourceLang': 'JA', 'text': 'Hello'},
    );
    final client = _createClient(adapter);
    addTearDown(client.dispose);

    final MisskeyNoteTranslation? result = await client.notes.translate(
      noteId: 'note-id',
      targetLang: 'en',
    );

    expect(
      result,
      const MisskeyNoteTranslation(sourceLang: 'JA', text: 'Hello'),
    );
    expect(adapter.body, {'noteId': 'note-id', 'targetLang': 'en'});
  });

  test('MisskeyHttp.send preserves HTTP 204 data by default', () async {
    final adapter = _RecordingAdapter(
      rawBody: '',
      statusCode: 204,
      headers: const {},
    );
    final client = _createClient(adapter);
    addTearDown(client.dispose);

    expect(
      await client.http.send<Object?>(
        '/i/registry/get',
        body: const <String, dynamic>{'key': 'setting'},
      ),
      '',
    );
  });

  group('RegistryApi.get', () {
    test('returns null for HTTP 204 without Content-Type or a body', () async {
      final adapter = _RecordingAdapter(
        rawBody: '',
        statusCode: 204,
        headers: const {},
      );
      final client = _createClient(adapter, token: 'access-token');
      addTearDown(client.dispose);

      expect(
        await client.account.registry.get(
          key: 'setting',
          scope: ['my-app'],
          domain: 'example.com',
        ),
        isNull,
      );
      expect(adapter.path, '/api/i/registry/get');
      expect(adapter.body, {
        'key': 'setting',
        'scope': ['my-app'],
        'domain': 'example.com',
        'i': 'access-token',
      });
    });

    // Misskey は文字列を JSON.stringify して text/plain で返す
    // （ApiCallService.ts: reply.send(typeof x === 'string' ? JSON.stringify(x) : x)）
    const plainText = {
      Headers.contentTypeHeader: ['text/plain; charset=utf-8'],
    };
    for (final (raw, expected) in <(String, String)>[
      ('"dark"', 'dark'),
      ('""', ''),
      (r'"say \"hi\""', 'say "hi"'),
      (r'"line\nbreak"', 'line\nbreak'),
      (r'"\"quoted\""', '"quoted"'),
    ]) {
      test('unquotes the JSON text string $raw sent as text/plain', () async {
        final adapter = _RecordingAdapter(rawBody: raw, headers: plainText);
        final client = _createClient(adapter);
        addTearDown(client.dispose);

        expect(await client.account.registry.get(key: 'setting'), expected);
      });
    }

    test('leaves text that is not a quoted JSON string unchanged', () async {
      final adapter = _RecordingAdapter(rawBody: 'plain', headers: plainText);
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      expect(await client.account.registry.get(key: 'setting'), 'plain');
    });

    for (final value in <Object>[
      '',
      'dark',
      42,
      1.5,
      {'theme': 'dark'},
      true,
      false,
      <Object>[1, 'two'],
    ]) {
      test('preserves the JSON value $value for HTTP 200', () async {
        final adapter = _RecordingAdapter(response: value);
        final client = _createClient(adapter);
        addTearDown(client.dispose);

        expect(await client.account.registry.get(key: 'setting'), value);
      });
    }

    test('keeps idempotent retries enabled', () async {
      final adapter = _RecordingAdapter(
        initialFailures: 1,
        rawBody: '',
        statusCode: 204,
        headers: const {},
      );
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      expect(await client.account.registry.get(key: 'setting'), isNull);
      expect(adapter.requestCount, 2);
    });

    test('preserves converted HTTP errors', () async {
      final adapter = _RecordingAdapter(statusCode: 401);
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await expectLater(
        client.account.registry.get(key: 'setting'),
        throwsA(isA<MisskeyUnauthorizedException>()),
      );
    });
  });

  group('AdminAnnouncementsApi', () {
    test('create omits an unspecified autoArchiveAt', () async {
      final adapter = _RecordingAdapter(response: _announcement);
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.adminAnnouncements.create(title: 'News', text: 'Details');

      expect(adapter.path, '/api/admin/announcements/create');
      expect(adapter.body, {
        'title': 'News',
        'text': 'Details',
        'imageUrl': null,
      });
    });

    test('create sends autoArchiveAt', () async {
      final adapter = _RecordingAdapter(response: _announcement);
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.adminAnnouncements.create(
        title: 'News',
        text: 'Details',
        autoArchiveAt: 1796083200000,
      );

      expect(adapter.path, '/api/admin/announcements/create');
      expect(adapter.body, {
        'title': 'News',
        'text': 'Details',
        'imageUrl': null,
        'autoArchiveAt': 1796083200000,
      });
    });

    for (final schedule in <Optional<int>?>[
      null,
      const Optional(1796083200000),
      const Optional(0),
      const Optional.null_(),
    ]) {
      test('update preserves the Optional state $schedule', () async {
        final adapter = _RecordingAdapter();
        final client = _createClient(adapter);
        addTearDown(client.dispose);

        await client.adminAnnouncements.update(
          id: 'announcement-id',
          autoArchiveAt: schedule,
        );

        expect(adapter.path, '/api/admin/announcements/update');
        expect(adapter.body, {
          'id': 'announcement-id',
          if (schedule case Some<int>(:final value)) 'autoArchiveAt': value,
        });
      });
    }

    test(
      'list parses scheduled, null, and older announcement responses',
      () async {
        final adapter = _RecordingAdapter(
          response: [
            {..._announcement, 'autoArchiveAt': '2026-12-01T00:00:00.000Z'},
            {..._announcement, 'autoArchiveAt': null},
            _announcement,
          ],
        );
        final client = _createClient(adapter);
        addTearDown(client.dispose);

        final announcements = await client.adminAnnouncements.list();

        expect(adapter.path, '/api/admin/announcements/list');
        expect(
          announcements.map((announcement) => announcement.autoArchiveAt),
          [DateTime.utc(2026, 12, 1), null, null],
        );
      },
    );
  });

  group('AccountApi.update follow approval', () {
    test('omits both settings when unspecified', () async {
      final adapter = _RecordingAdapter(response: _user);
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.account.update();

      expect(adapter.path, '/api/i/update');
      expect(adapter.body, isEmpty);
    });

    test('sends and parses zero and the 30-day boundary', () async {
      final adapter = _RecordingAdapter(
        response: {
          ..._user,
          'followApprovalLocalSeconds': 0,
          'followApprovalRemoteSeconds': 2592000,
        },
      );
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      final user = await client.account.update(
        followApprovalLocalSeconds: const Optional(0),
        followApprovalRemoteSeconds: const Optional(2592000),
      );

      expect(adapter.body, {
        'followApprovalLocalSeconds': 0,
        'followApprovalRemoteSeconds': 2592000,
      });
      expect(user.followApprovalLocalSeconds, 0);
      expect(user.followApprovalRemoteSeconds, 2592000);
    });

    test('clears both settings with explicit null', () async {
      final adapter = _RecordingAdapter(response: _user);
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.account.update(
        followApprovalLocalSeconds: const Optional.null_(),
        followApprovalRemoteSeconds: const Optional.null_(),
      );

      expect(adapter.body, {
        'followApprovalLocalSeconds': null,
        'followApprovalRemoteSeconds': null,
      });
    });

    test('updates local and remote settings independently', () async {
      final adapter = _RecordingAdapter(response: _user);
      final client = _createClient(adapter);
      addTearDown(client.dispose);

      await client.account.update(
        followApprovalLocalSeconds: const Optional(3600),
      );
      expect(adapter.body, {'followApprovalLocalSeconds': 3600});

      await client.account.update(
        followApprovalRemoteSeconds: const Optional(7200),
      );
      expect(adapter.body, {'followApprovalRemoteSeconds': 7200});

      await client.account.update(
        followApprovalLocalSeconds: const Optional.null_(),
      );
      expect(adapter.body, {'followApprovalLocalSeconds': null});

      await client.account.update(
        followApprovalRemoteSeconds: const Optional.null_(),
      );
      expect(adapter.body, {'followApprovalRemoteSeconds': null});
    });
  });
}

const _announcement = {
  'id': 'announcement-id',
  'title': 'News',
  'text': 'Details',
};
const _user = {'id': 'user-id', 'username': 'alice'};

MisskeyClient _createClient(_RecordingAdapter adapter, {String? token}) =>
    MisskeyClient(
      config: MisskeyClientConfig(
        baseUrl: Uri.parse('https://misskey.example.com'),
      ),
      tokenProvider: token == null ? null : () => token,
      httpClientAdapter: adapter,
    );

final class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter({
    this.response,
    this.rawBody,
    this.initialFailures = 0,
    this.statusCode = 200,
    this.headers = const {
      Headers.contentTypeHeader: ['application/json'],
    },
  });

  final Object? response;

  // 指定すると JSON エンコードせずにそのまま本文として返す（空の本文など）
  final String? rawBody;
  final int initialFailures;
  final int statusCode;
  final Map<String, List<String>> headers;
  int requestCount = 0;
  String? path;
  Map<String, dynamic>? body;
  Map<String, dynamic>? extra;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    path = options.uri.path;
    body = Map<String, dynamic>.from(options.data as Map<String, dynamic>);
    extra = options.extra;
    return ResponseBody.fromString(
      rawBody ?? jsonEncode(response),
      requestCount <= initialFailures ? 503 : statusCode,
      headers: headers,
    );
  }

  @override
  void close({bool force = false}) {}
}
