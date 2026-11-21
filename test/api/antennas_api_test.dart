import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/scripted_http_adapter.dart';

void main() {
  group('AntennasApi.removeNote', () {
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

    test('sends the antenna and note IDs', () async {
      adapter.enqueue('/antennas/remove-note', ScriptedResponse.noContent());

      await client.antennas.removeNote(antennaId: 'antenna1', noteId: 'note1');

      expect(adapter.requests.single.path, '/antennas/remove-note');
      expect(adapter.requests.single.jsonBody, {
        'antennaId': 'antenna1',
        'noteId': 'note1',
      });
    });

    test('surfaces NO_SUCH_ANTENNA as an API exception', () async {
      adapter.enqueue(
        '/antennas/remove-note',
        ScriptedResponse.error(400, code: 'NO_SUCH_ANTENNA'),
      );

      await expectLater(
        client.antennas.removeNote(antennaId: 'missing', noteId: 'note1'),
        throwsA(
          isA<MisskeyApiException>().having(
            (e) => e.code,
            'code',
            'NO_SUCH_ANTENNA',
          ),
        ),
      );
    });
  });
}
