import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

const _adminListPaths = <String>[
  '/api/admin/abuse-user-reports',
  '/api/admin/ad/list',
  '/api/admin/announcements/list',
  '/api/admin/avatar-decorations/list',
  '/api/admin/drive/files',
  '/api/admin/emoji/list',
  '/api/admin/emoji/list-remote',
  '/api/admin/show-moderation-logs',
];

void main() {
  test(
    'all eight admin list APIs send Unix-millisecond date cursors',
    () async {
      const sinceDate = 1767225600123;
      const untilDate = 1767312000456;
      final adapter = _RecordingHttpClientAdapter();
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
        httpClientAdapter: adapter,
      );
      addTearDown(client.dispose);

      await _callAllAdminListMethods(
        client,
        sinceDate: sinceDate,
        untilDate: untilDate,
      );

      expect(adapter.requests, [
        for (final path in _adminListPaths)
          {
            'path': path,
            'body': {'sinceDate': sinceDate, 'untilDate': untilDate},
          },
      ]);
    },
  );

  test('all eight admin list APIs omit absent date cursors', () async {
    final adapter = _RecordingHttpClientAdapter();
    final client = MisskeyClient(
      config: MisskeyClientConfig(
        baseUrl: Uri.parse('https://misskey.example.com'),
      ),
      httpClientAdapter: adapter,
    );
    addTearDown(client.dispose);

    await _callAllAdminListMethods(client);

    expect(adapter.requests, [
      for (final path in _adminListPaths)
        {'path': path, 'body': <String, dynamic>{}},
    ]);
  });
}

Future<void> _callAllAdminListMethods(
  MisskeyClient client, {
  int? sinceDate,
  int? untilDate,
}) async {
  await client.adminAbuseReports.list(
    sinceDate: sinceDate,
    untilDate: untilDate,
  );
  await client.adminAd.list(sinceDate: sinceDate, untilDate: untilDate);
  await client.adminAnnouncements.list(
    sinceDate: sinceDate,
    untilDate: untilDate,
  );
  await client.adminAvatarDecorations.list(
    sinceDate: sinceDate,
    untilDate: untilDate,
  );
  await client.adminDrive.files(sinceDate: sinceDate, untilDate: untilDate);
  await client.adminEmoji.list(sinceDate: sinceDate, untilDate: untilDate);
  await client.adminEmoji.listRemote(
    sinceDate: sinceDate,
    untilDate: untilDate,
  );
  await client.admin.showModerationLogs(
    sinceDate: sinceDate,
    untilDate: untilDate,
  );
}

final class _RecordingHttpClientAdapter implements HttpClientAdapter {
  final List<Map<String, dynamic>> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add({
      'path': options.uri.path,
      'body': Map<String, dynamic>.from(options.data as Map<String, dynamic>),
    });
    return ResponseBody.fromString(
      jsonEncode(<dynamic>[]),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
