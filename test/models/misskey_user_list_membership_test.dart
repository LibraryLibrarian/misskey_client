import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyUserListMembership.fromJson', () {
    late MisskeyUserListMembership membership;

    setUp(() {
      final file = File('test/fixtures/user_list_memberships.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      membership = MisskeyUserListMembership.fromJson(
          jsonList.first as Map<String, dynamic>);
    });

    test('deserializes without error', () {
      expect(membership, isNotNull);
    });

    test('id is correct', () {
      expect(membership.id, 'ak6nhbx9rt4w000y');
    });

    test('userId is correct', () {
      expect(membership.userId, 'ak3qbtu5rt4w0009');
    });

    test('withReplies is false', () {
      expect(membership.withReplies, isFalse);
    });

    test('user is deserialized', () {
      expect(membership.user, isNotNull);
      expect(membership.user!.username, 'testuser2');
    });

    test('createdAt is deserialized', () {
      expect(membership.createdAt, isNotNull);
    });
  });
}
