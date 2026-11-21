import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/scripted_http_adapter.dart';

void main() {
  group('NotesApi.search', () {
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

    test('sends the posting-period conditions', () async {
      adapter.enqueue('/notes/search', ScriptedResponse.json(<Object?>[]));

      await client.notes.search(
        query: 'misskey',
        rangeStartAt: 1767225600000,
        rangeEndAt: 1767311999999,
      );

      expect(adapter.requests.single.path, '/notes/search');
      expect(adapter.requests.single.jsonBody, {
        'query': 'misskey',
        'rangeStartAt': 1767225600000,
        'rangeEndAt': 1767311999999,
      });
    });

    test('omits absent posting-period conditions', () async {
      adapter.enqueue('/notes/search', ScriptedResponse.json(<Object?>[]));

      await client.notes.search(query: 'misskey');

      expect(adapter.requests.single.jsonBody, {'query': 'misskey'});
    });
  });
}
