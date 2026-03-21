import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyRole.fromJson', () {
    late MisskeyRole role;

    setUp(() {
      final file = File('test/fixtures/roles_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      role = MisskeyRole.fromJson(jsonList.first as Map<String, dynamic>);
    });

    test('deserializes without error', () {
      expect(role, isNotNull);
    });

    test('name and description are correct', () {
      expect(role.name, 'Test Role');
      expect(role.description, 'A test role');
    });

    test('color is correct', () {
      expect(role.color, '#ff0000');
    });

    test('iconUrl is null', () {
      expect(role.iconUrl, isNull);
    });

    test('public flags are correct', () {
      expect(role.isPublic, isTrue);
      expect(role.isExplorable, isTrue);
      expect(role.asBadge, isTrue);
    });

    test('target is correct', () {
      expect(role.target, 'manual');
    });

    test('usersCount is 0', () {
      expect(role.usersCount, 0);
    });

    test('displayOrder is 0', () {
      expect(role.displayOrder, 0);
    });
  });
}
