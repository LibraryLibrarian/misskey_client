import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyRoleUser.fromJson', () {
    late List<MisskeyRoleUser> list;

    setUp(() {
      final file = File('test/fixtures/role_users.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map((e) => MisskeyRoleUser.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list', () {
      expect(list, isNotEmpty);
    });

    test('first item has correct id', () {
      expect(list[0].id, 'ak6o87lcrt4w0019');
    });

    test('user is not null and has correct username', () {
      final user = list[0].user;
      expect(user.id, 'ak3qbtu5rt4w0009');
      expect(user.username, 'testuser2');
    });
  });
}
