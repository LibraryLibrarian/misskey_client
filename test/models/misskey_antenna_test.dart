import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyAntenna.fromJson', () {
    late MisskeyAntenna antenna;

    setUp(() {
      final file = File('test/fixtures/antennas_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      antenna =
          MisskeyAntenna.fromJson(jsonList.first as Map<String, dynamic>);
    });

    test('deserializes without error', () {
      expect(antenna, isNotNull);
    });

    test('id is not empty', () {
      expect(antenna.id, isNotEmpty);
    });

    test('name is correct', () {
      expect(antenna.name, 'Test Antenna');
    });

    test('keywords are correct', () {
      expect(antenna.keywords, [
        ['test']
      ]);
    });

    test('excludeKeywords contains one empty list', () {
      expect(antenna.excludeKeywords, hasLength(1));
      expect(antenna.excludeKeywords.first, isEmpty);
    });

    test('src is correct', () {
      expect(antenna.src, 'all');
    });

    test('boolean flags are correct', () {
      expect(antenna.caseSensitive, isFalse);
      expect(antenna.localOnly, isFalse);
      expect(antenna.withReplies, isTrue);
      expect(antenna.withFile, isFalse);
      expect(antenna.excludeBots, isFalse);
    });

    test('isActive is true', () {
      expect(antenna.isActive, isTrue);
    });

    test('hasUnreadNote is false', () {
      expect(antenna.hasUnreadNote, isFalse);
    });

    test('userListId is null', () {
      expect(antenna.userListId, isNull);
    });
  });
}
