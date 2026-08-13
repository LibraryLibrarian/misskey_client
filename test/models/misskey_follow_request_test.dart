import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyFollowRequest.fromJson', () {
    late List<MisskeyFollowRequest> list;

    setUp(() {
      final file = File('test/fixtures/follow_requests.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map((e) => MisskeyFollowRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list', () {
      expect(list, isNotEmpty);
    });

    test('first item has correct id', () {
      expect(list[0].id, 'ak6o74fert4w0016');
    });

    test('follower has correct id and username', () {
      final follower = list[0].follower;
      expect(follower.id, 'ak6o6rqkrt4w0015');
      expect(follower.username, 'testuser3');
    });

    test('followee has correct id and username', () {
      final followee = list[0].followee;
      expect(followee.id, 'ak3po4qort4w0001');
      expect(followee.username, 'testadmin');
    });
  });
}
