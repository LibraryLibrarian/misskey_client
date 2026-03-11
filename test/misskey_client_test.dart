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
}
