import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/scripted_http_adapter.dart';

void main() {
  group('AdminQueueApi pause / resume', () {
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

    test('pause sends the queue name', () async {
      adapter.enqueue('/admin/queue/pause', ScriptedResponse.noContent());

      await client.adminQueue.pause(queue: 'deliver');

      expect(adapter.requests.single.path, '/admin/queue/pause');
      expect(adapter.requests.single.jsonBody, {'queue': 'deliver'});
    });

    test('resume sends the queue name', () async {
      adapter.enqueue('/admin/queue/resume', ScriptedResponse.noContent());

      await client.adminQueue.resume(queue: 'deliver');

      expect(adapter.requests.single.path, '/admin/queue/resume');
      expect(adapter.requests.single.jsonBody, {'queue': 'deliver'});
    });
  });
}
