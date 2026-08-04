import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('AvatarDecoration.fromJson', () {
    late List<AvatarDecoration> decorations;

    setUp(() {
      final file = File('test/fixtures/avatar_decorations.json');
      final json = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      decorations = json
          .cast<Map<String, dynamic>>()
          .map(AvatarDecoration.fromJson)
          .toList();
    });

    test('deserializes a non-empty list', () {
      expect(decorations, isNotEmpty);
    });

    test('first item has expected id', () {
      expect(decorations[0].id, '01HQB67090AX5HRJAVSXKKJT0Z');
    });

    test('first item has expected name', () {
      expect(decorations[0].name, '三段重ねホットケーキ');
    });

    test('first item has a non-empty description', () {
      expect(decorations[0].description, isNotEmpty);
    });

    test('first item has a valid url', () {
      expect(decorations[0].url, startsWith('https://'));
    });

    test('first item roleIdsThatCanBeUsedThisDecoration is a list', () {
      expect(
        decorations[0].roleIdsThatCanBeUsedThisDecoration,
        isA<List<String>>(),
      );
    });

    test('second item has expected id', () {
      expect(decorations[1].id, '01HP1MGFEYX9SKD33JMJYAD7PZ');
    });

    test('all items have non-empty id and url', () {
      for (final decoration in decorations) {
        expect(decoration.id, isNotEmpty);
        expect(decoration.url, isNotEmpty);
      }
    });
  });
}
