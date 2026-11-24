import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/scripted_http_adapter.dart';

void main() {
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

  // 「どちらか一方が必須」の引数は、リリースビルドでも送信前に検査する
  test('NotesApi.searchByTag requires tag or queryTags', () async {
    await expectLater(client.notes.searchByTag(), throwsArgumentError);
    expect(adapter.requests, isEmpty);
  });

  test('UsersApi.searchByUsernameAndHost requires username or host', () async {
    await expectLater(
      client.users.searchByUsernameAndHost(limit: 10),
      throwsArgumentError,
    );
    expect(adapter.requests, isEmpty);
  });

  test('AdminDriveApi.showFile requires fileId or url', () async {
    await expectLater(client.adminDrive.showFile(), throwsArgumentError);
    expect(adapter.requests, isEmpty);
  });

  test('AdminEmojiApi.update requires id or name', () async {
    await expectLater(
      client.adminEmoji.update(isSensitive: true),
      throwsArgumentError,
    );
    expect(adapter.requests, isEmpty);
  });

  test('sends the request when one of the pair is given', () async {
    adapter
      ..enqueue('/notes/search-by-tag', ScriptedResponse.json(<Object?>[]))
      ..enqueue(
        '/users/search-by-username-and-host',
        ScriptedResponse.json(<Object?>[]),
      );

    await client.notes.searchByTag(tag: 'misskey');
    await client.users.searchByUsernameAndHost(host: 'misskey.example.com');

    expect(adapter.requests.map((r) => r.jsonBody), [
      {'tag': 'misskey'},
      {'host': 'misskey.example.com'},
    ]);
  });
}
