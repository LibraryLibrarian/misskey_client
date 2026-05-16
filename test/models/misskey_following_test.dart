import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyFollowing.fromJson', () {
    late MisskeyFollowing following;

    setUp(() {
      final file = File('test/fixtures/users_following.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      following =
          MisskeyFollowing.fromJson(jsonList.first as Map<String, dynamic>);
    });

    test('deserializes without error', () {
      expect(following, isNotNull);
    });

    test('has id and createdAt', () {
      expect(following.id, isNotEmpty);
      expect(following.createdAt, isA<DateTime>());
    });

    test('followeeId is correct', () {
      expect(following.followeeId, 'ak3po4qort4w0001');
    });

    test('followerId is correct', () {
      expect(following.followerId, 'ak3qbtu5rt4w0009');
    });

    test('followee is not null and has correct username', () {
      expect(following.followee, isNotNull);
      expect(following.followee!.username, 'testadmin');
    });

    test('follower is null', () {
      // fixtures/users_following.jsonにはfollowerフィールドがない
      expect(following.follower, isNull);
    });
  });
}
