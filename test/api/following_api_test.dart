import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/scripted_http_adapter.dart';

void main() {
  group('FollowingApi.list', () {
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

    test('sends the notification filter and pagination cursors', () async {
      adapter.enqueue('/following/list', ScriptedResponse.json(<Object?>[]));

      await client.following.list(
        notification: true,
        limit: 30,
        sinceId: 'since',
        untilId: 'until',
        sinceDate: 1767225600123,
        untilDate: 1767312000456,
      );

      expect(adapter.requests.single.path, '/following/list');
      expect(adapter.requests.single.jsonBody, {
        'notification': true,
        'limit': 30,
        'sinceId': 'since',
        'untilId': 'until',
        'sinceDate': 1767225600123,
        'untilDate': 1767312000456,
      });
    });

    test('omits absent arguments', () async {
      adapter.enqueue('/following/list', ScriptedResponse.json(<Object?>[]));

      await client.following.list();

      expect(adapter.requests.single.jsonBody, <String, dynamic>{});
    });

    test('parses follow records with the populated followee', () async {
      final fixture = jsonDecode(
        File('test/fixtures/users_following.json').readAsStringSync(),
      );
      adapter.enqueue('/following/list', ScriptedResponse.json(fixture));

      final follows = await client.following.list();

      expect(follows, hasLength((fixture as List).length));
      expect(follows.first.followee?.id, follows.first.followeeId);
    });
  });
}
