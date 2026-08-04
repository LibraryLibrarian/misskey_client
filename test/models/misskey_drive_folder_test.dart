import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyDriveFolder.fromJson', () {
    late List<MisskeyDriveFolder> list;

    setUp(() {
      final file = File('test/fixtures/drive_folders.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map((e) => MisskeyDriveFolder.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list', () {
      expect(list, isNotEmpty);
    });

    test('first item has correct name, id, and createdAt', () {
      final first = list[0];
      expect(first.name, 'Test Folder');
      expect(first.id, 'ak6njjn8rt4w000z');
      expect(first.createdAt, isA<DateTime>());
    });

    test('parentId is null', () {
      expect(list[0].parentId, isNull);
    });

    test('parent is null', () {
      expect(list[0].parent, isNull);
    });
  });
}
