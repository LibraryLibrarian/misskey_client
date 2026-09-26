import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  test('listV2 sends nested filters and pagination parameters', () async {
    final response =
        jsonDecode(
              File('test/fixtures/admin_emoji_list_v2.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    final adapter = _EmojiV2Adapter(response);
    final client = MisskeyClient(
      config: MisskeyClientConfig(
        baseUrl: Uri.parse('https://misskey.example.com'),
      ),
      httpClientAdapter: adapter,
    );
    addTearDown(client.dispose);

    final result = await client.adminEmoji.listV2(
      query: const MisskeyAdminEmojiListQuery(
        updatedAtFrom: '2026-01-01T00:00:00.000Z',
        updatedAtTo: '2026-12-31T23:59:59.999Z',
        name: 'party',
        host: 'remote.example',
        uri: 'https://remote.example/emoji/party',
        publicUrl: 'https://cdn.example/party',
        originalUrl: 'https://origin.example/party',
        type: 'image/webp',
        aliases: 'blob',
        category: 'reactions',
        license: 'CC0',
        isSensitive: false,
        localOnly: false,
        hostType: 'all',
        roleIds: ['role-1'],
      ),
      sinceId: 'since-id',
      untilId: 'until-id',
      sinceDate: 1767225600000,
      untilDate: 1798761599999,
      limit: 25,
      page: 2,
      sortKeys: const ['+name', '-updatedAt'],
    );

    expect(result.emojis.single.name, 'party_blob');
    expect(adapter.path, '/api/v2/admin/emoji/list');
    expect(adapter.body, {
      'query': {
        'updatedAtFrom': '2026-01-01T00:00:00.000Z',
        'updatedAtTo': '2026-12-31T23:59:59.999Z',
        'name': 'party',
        'host': 'remote.example',
        'uri': 'https://remote.example/emoji/party',
        'publicUrl': 'https://cdn.example/party',
        'originalUrl': 'https://origin.example/party',
        'type': 'image/webp',
        'aliases': 'blob',
        'category': 'reactions',
        'license': 'CC0',
        'isSensitive': false,
        'localOnly': false,
        'hostType': 'all',
        'roleIds': ['role-1'],
      },
      'sinceId': 'since-id',
      'untilId': 'until-id',
      'sinceDate': 1767225600000,
      'untilDate': 1798761599999,
      'limit': 25,
      'page': 2,
      'sortKeys': ['+name', '-updatedAt'],
    });
  });

  test(
    'listV2 omits every optional key when no arguments are supplied',
    () async {
      final response =
          jsonDecode(
                File(
                  'test/fixtures/admin_emoji_list_v2.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      final adapter = _EmojiV2Adapter(response);
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
        httpClientAdapter: adapter,
      );
      addTearDown(client.dispose);

      await client.adminEmoji.listV2();

      expect(adapter.path, '/api/v2/admin/emoji/list');
      expect(adapter.body, isEmpty);
    },
  );
}

final class _EmojiV2Adapter implements HttpClientAdapter {
  _EmojiV2Adapter(this.response);

  final Map<String, dynamic> response;
  String? path;
  Map<String, dynamic>? body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    path = options.uri.path;
    body = Map<String, dynamic>.from(options.data as Map<String, dynamic>);
    return ResponseBody.fromString(
      jsonEncode(response),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
