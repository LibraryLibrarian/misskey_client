import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('AccountApi.update', () {
    test(
      'sends word-mute conditions in the Misskey JSON union shape',
      () async {
        final adapter = _RecordingHttpClientAdapter();
        final client = MisskeyClient(
          config: MisskeyClientConfig(
            baseUrl: Uri.parse('https://misskey.example.com'),
          ),
          httpClientAdapter: adapter,
        );
        addTearDown(client.dispose);

        await client.account.update(
          mutedWords: const [
            MutedWordKeywords(keywords: ['misskey', 'client']),
            MutedWordRegex(pattern: '/spam/i'),
          ],
          hardMutedWords: const [
            MutedWordRegex(pattern: '/spoiler/i'),
            MutedWordKeywords(keywords: ['hard', 'mute']),
          ],
        );

        expect(adapter.path, '/api/i/update');
        expect(adapter.body, {
          'mutedWords': [
            ['misskey', 'client'],
            '/spam/i',
          ],
          'hardMutedWords': [
            '/spoiler/i',
            ['hard', 'mute'],
          ],
        });
      },
    );

    test('preserves empty word-mute values in the request body', () async {
      final adapter = _RecordingHttpClientAdapter();
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
        httpClientAdapter: adapter,
      );
      addTearDown(client.dispose);

      await client.account.update(
        mutedWords: const [],
        hardMutedWords: const [
          MutedWordKeywords(keywords: []),
          MutedWordKeywords(keywords: ['']),
          MutedWordRegex(pattern: ''),
        ],
      );

      expect(adapter.body, {
        'mutedWords': <dynamic>[],
        'hardMutedWords': [
          <String>[],
          [''],
          '',
        ],
      });
    });
  });

  group('AccountApi.i', () {
    test('parses mixed word-mute conditions from the API response', () async {
      final response =
          jsonDecode(File('test/fixtures/i.json').readAsStringSync())
              as Map<String, dynamic>;
      final adapter = _RecordingHttpClientAdapter(response: response);
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
        httpClientAdapter: adapter,
      );
      addTearDown(client.dispose);

      final user = await client.account.i();

      expect(adapter.path, '/api/i');
      expect(user.mutedWords, [
        isA<MutedWordKeywords>(),
        isA<MutedWordRegex>(),
      ]);
      expect(user.hardMutedWords, [
        isA<MutedWordRegex>(),
        isA<MutedWordKeywords>(),
      ]);
    });
  });
}

final class _RecordingHttpClientAdapter implements HttpClientAdapter {
  _RecordingHttpClientAdapter({this.response});

  final Map<String, dynamic>? response;
  String? path;
  Map<String, dynamic>? body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    path = options.uri.path;
    body = options.data as Map<String, dynamic>;
    return ResponseBody.fromString(
      jsonEncode(response ?? {'id': 'user-id', 'username': 'alice'}),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
