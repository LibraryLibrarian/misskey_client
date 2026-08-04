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
      expect(role.name, 'E2E World Role');
      expect(role.description, isNotEmpty);
    });

    test('color is correct', () {
      expect(role.color, '#86b300');
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

    test('usersCount is positive (role assigned to a world account)', () {
      expect(role.usersCount, 1);
    });

    test('displayOrder is 0', () {
      expect(role.displayOrder, 0);
    });

    test('isAdministrator is false', () {
      expect(role.isAdministrator, false);
    });

    test('isModerator is false', () {
      expect(role.isModerator, false);
    });

    test('policies is not null and is a Map', () {
      expect(role.policies, isNotNull);
      expect(role.policies, isA<Map<String, dynamic>>());
    });

    test('condFormula is not null', () {
      expect(role.condFormula, isNotNull);
    });

    test('preserveAssignmentOnMoveAccount is false', () {
      expect(role.preserveAssignmentOnMoveAccount, false);
    });
  });
}
