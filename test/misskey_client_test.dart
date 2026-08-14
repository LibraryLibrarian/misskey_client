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
}
