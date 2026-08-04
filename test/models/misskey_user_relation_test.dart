import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyUserRelation.fromJson', () {
    late MisskeyUserRelation relation;

    setUp(() {
      final file = File('test/fixtures/user_relation.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      relation = MisskeyUserRelation.fromJson(
        jsonList[0] as Map<String, dynamic>,
      );
    });

    test('deserializes id correctly', () {
      expect(relation.id, 'ak3qbtu5rt4w0009');
    });

    test('isFollowing is true', () {
      expect(relation.isFollowing, true);
    });

    test('isFollowed is false', () {
      expect(relation.isFollowed, false);
    });

    test('hasPendingFollowRequestFromYou is false', () {
      expect(relation.hasPendingFollowRequestFromYou, false);
    });

    test('hasPendingFollowRequestToYou is false', () {
      expect(relation.hasPendingFollowRequestToYou, false);
    });

    test('isBlocking is false', () {
      expect(relation.isBlocking, false);
    });

    test('isBlocked is false', () {
      expect(relation.isBlocked, false);
    });

    test('isMuted is false', () {
      expect(relation.isMuted, false);
    });

    test('isRenoteMuted is false', () {
      expect(relation.isRenoteMuted, false);
    });
  });
}
