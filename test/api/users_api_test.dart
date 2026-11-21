import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/scripted_http_adapter.dart';

void main() {
  group('UsersApi.relation', () {
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

    Map<String, dynamic> relationJson() {
      final file = File('test/fixtures/user_relation.json');
      final list = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      return list.single as Map<String, dynamic>;
    }

    test('unwraps the single-element array returned for one userId', () async {
      adapter.enqueue(
        '/users/relation',
        ScriptedResponse.json(<Object?>[relationJson()]),
      );

      final relation = await client.users.relation(userId: 'ak3qbtu5rt4w0009');

      expect(adapter.requests.single.jsonBody, {'userId': 'ak3qbtu5rt4w0009'});
      expect(relation.id, 'ak3qbtu5rt4w0009');
      expect(relation.isFollowing, isTrue);
    });

    test('accepts a single object from servers before 2024.5.0', () async {
      adapter.enqueue('/users/relation', ScriptedResponse.json(relationJson()));

      final relation = await client.users.relation(userId: 'ak3qbtu5rt4w0009');

      expect(relation.id, 'ak3qbtu5rt4w0009');
    });

    test('throws FormatException for an empty array', () async {
      adapter.enqueue('/users/relation', ScriptedResponse.json(<Object?>[]));

      await expectLater(
        client.users.relation(userId: 'ak3qbtu5rt4w0009'),
        throwsFormatException,
      );
    });
  });
}
