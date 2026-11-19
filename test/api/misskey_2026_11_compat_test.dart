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

    test(
      'create sends autoArchiveAt and parses the scheduled response',
      () async {
        final adapter = _RecordingAdapter(
          response: {
            ..._announcement,
            'autoArchiveAt': '2026-12-01T00:00:00.000Z',
          },
        );
        final client = _createClient(adapter);
        addTearDown(client.dispose);

        final announcement = await client.adminAnnouncements.create(
          title: 'News',
          text: 'Details',
          autoArchiveAt: 1796083200000,
        );

        expect(adapter.body, {
          'title': 'News',
          'text': 'Details',
          'imageUrl': null,
          'autoArchiveAt': 1796083200000,
        });
        expect(announcement.autoArchiveAt, DateTime.utc(2026, 12, 1));
      },
    );

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
  _RecordingAdapter({this.response, this.initialFailures = 0});

  final Object? response;
  final int initialFailures;
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
      jsonEncode(response),
      requestCount <= initialFailures ? 503 : 200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
