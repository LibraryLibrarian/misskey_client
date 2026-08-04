import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyBirthdayUser.fromJson', () {
    late MisskeyBirthdayUser birthdayUser;

    setUp(() {
      final file = File('test/fixtures/birthday_users.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      birthdayUser =
          MisskeyBirthdayUser.fromJson(jsonList.first as Map<String, dynamic>);
    });

    test('deserializes without error', () {
      expect(birthdayUser, isNotNull);
    });

    test('id is correct', () {
      expect(birthdayUser.id, 'ak3qbtu5rt4w0009');
    });

    test('birthday is correct', () {
      expect(birthdayUser.birthday, '2026-03-23');
    });

    test('user is deserialized', () {
      expect(birthdayUser.user, isNotNull);
      expect(birthdayUser.user!.username, 'testuser2');
    });
  });
}
