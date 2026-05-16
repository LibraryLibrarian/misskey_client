import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyUserList.fromJson', () {
    late List<MisskeyUserList> list;

    setUp(() {
      final file = File('test/fixtures/user_lists.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map((e) => MisskeyUserList.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list', () {
      expect(list, isNotEmpty);
    });

    test('first item has correct name and id', () {
      final first = list[0];
      expect(first.name, 'Test List');
      expect(first.id, 'ak6nh8wnrt4w000x');
    });

    test('userIds contains testuser2 id', () {
      expect(list[0].userIds, contains('ak3qbtu5rt4w0009'));
    });

    test('isPublic is false', () {
      expect(list[0].isPublic, isFalse);
    });
  });
}
