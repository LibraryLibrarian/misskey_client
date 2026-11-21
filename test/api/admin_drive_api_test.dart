import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/scripted_http_adapter.dart';

void main() {
  group('AdminDriveApi.showFile', () {
    late ScriptedHttpClientAdapter adapter;
    late MisskeyClient client;

    setUp(() {
      adapter = ScriptedHttpClientAdapter();
      client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
        httpClientAdapter: adapter,
      );
      addTearDown(client.dispose);
    });

    test('parses file metadata and moderation details', () async {
      adapter.enqueue(
        '/admin/drive/show-file',
        ScriptedResponse.json({
          ..._fileJson(),
          'userId': 'user-id',
          'userHost': 'remote.example.com',
          'comment': 'A picture',
          'blurhash': 'blurhash',
          'properties': {
            'width': 640,
            'height': 480,
            'orientation': 1,
            'avgColor': 'rgb(100,100,100)',
          },
          'storedInternal': true,
          'url': 'https://example.com/file.png',
          'thumbnailUrl': 'https://example.com/thumbnail.png',
          'webpublicUrl': 'https://example.com/public.webp',
          'webpublicType': 'image/webp',
          'accessKey': 'original-key',
          'thumbnailAccessKey': 'thumbnail-key',
          'webpublicAccessKey': 'public-key',
          'uri': 'https://remote.example.com/file',
          'src': 'https://remote.example.com/file.png',
          'folderId': 'folder-id',
          'requestIp': '192.0.2.1',
          'requestHeaders': {'user-agent': 'Test uploader'},
        }),
      );

      final MisskeyAdminDriveFile file = await client.adminDrive.showFile(
        fileId: 'file-id',
      );

      expect(file.id, 'file-id');
      expect(file.createdAt, DateTime.utc(2026, 5, 1, 12));
      expect(file.name, 'file.png');
      expect(file.type, 'image/png');
      expect(file.size, 512);
      expect(file.md5, '15eca7fba0480996e2245f5185bf39f2');
      expect(file.isSensitive, isFalse);
      expect(file.isLink, isTrue);
      expect(file.maybeSensitive, isTrue);
      expect(file.maybePorn, isFalse);
      expect(file.userId, 'user-id');
      expect(file.userHost, 'remote.example.com');
      expect(file.comment, 'A picture');
      expect(file.blurhash, 'blurhash');
      expect(file.properties.width, 640);
      expect(file.properties.height, 480);
      expect(file.properties.orientation, 1);
      expect(file.properties.avgColor, 'rgb(100,100,100)');
      expect(file.storedInternal, isTrue);
      expect(file.url, 'https://example.com/file.png');
      expect(file.thumbnailUrl, 'https://example.com/thumbnail.png');
      expect(file.webpublicUrl, 'https://example.com/public.webp');
      expect(file.webpublicType, 'image/webp');
      expect(file.accessKey, 'original-key');
      expect(file.thumbnailAccessKey, 'thumbnail-key');
      expect(file.webpublicAccessKey, 'public-key');
      expect(file.uri, 'https://remote.example.com/file');
      expect(file.src, 'https://remote.example.com/file.png');
      expect(file.folderId, 'folder-id');
      expect(file.requestIp, '192.0.2.1');
      expect(file.requestHeaders, {'user-agent': 'Test uploader'});
      expect(adapter.requests.single.jsonBody, {'fileId': 'file-id'});
    });

    test(
      'accepts nullable fields and omitted optional image properties',
      () async {
        adapter.enqueue(
          '/admin/drive/show-file',
          ScriptedResponse.json(_fileJson()),
        );

        final file = await client.adminDrive.showFile(
          url: 'https://example.com/file.png',
        );

        expect(file.properties.width, isNull);
        expect(file.properties.height, isNull);
        expect(file.properties.orientation, isNull);
        expect(file.properties.avgColor, isNull);
        expect(file.userId, isNull);
        expect(file.userHost, isNull);
        expect(file.comment, isNull);
        expect(file.blurhash, isNull);
        expect(file.storedInternal, isNull);
        expect(file.url, isNull);
        expect(file.thumbnailUrl, isNull);
        expect(file.webpublicUrl, isNull);
        expect(file.webpublicType, isNull);
        expect(file.accessKey, isNull);
        expect(file.thumbnailAccessKey, isNull);
        expect(file.webpublicAccessKey, isNull);
        expect(file.uri, isNull);
        expect(file.src, isNull);
        expect(file.folderId, isNull);
        expect(file.requestIp, isNull);
        expect(file.requestHeaders, isNull);
        expect(adapter.requests.single.jsonBody, {
          'url': 'https://example.com/file.png',
        });
      },
    );
  });
}

Map<String, dynamic> _fileJson() => {
  'id': 'file-id',
  'createdAt': '2026-05-01T12:00:00.000Z',
  'md5': '15eca7fba0480996e2245f5185bf39f2',
  'name': 'file.png',
  'type': 'image/png',
  'size': 512,
  'properties': <String, dynamic>{},
  'isSensitive': false,
  'isLink': true,
  'maybeSensitive': true,
  'maybePorn': false,
  'userId': null,
  'userHost': null,
  'comment': null,
  'blurhash': null,
  'storedInternal': null,
  'url': null,
  'thumbnailUrl': null,
  'webpublicUrl': null,
  'webpublicType': null,
  'accessKey': null,
  'thumbnailAccessKey': null,
  'webpublicAccessKey': null,
  'uri': null,
  'src': null,
  'folderId': null,
  'requestIp': null,
  'requestHeaders': null,
};
