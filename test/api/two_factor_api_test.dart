import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/scripted_http_adapter.dart';

void main() {
  group('TwoFactorApi.updateKey', () {
    test('sends the credential ID and the required name', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..enqueue('/i/2fa/update-key', ScriptedResponse.noContent());
      final client = MisskeyClient(
        config: MisskeyClientConfig(
          baseUrl: Uri.parse('https://misskey.example.com'),
        ),
        httpClientAdapter: adapter,
      );
      addTearDown(client.dispose);

      await client.account.twoFactor.updateKey(
        credentialId: 'credential1',
        name: 'Laptop',
      );

      expect(adapter.requests.single.jsonBody, {
        'credentialId': 'credential1',
        'name': 'Laptop',
      });
    });
  });
}
