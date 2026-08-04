import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('EmojiDetailed.fromJson', () {
    late EmojiDetailed emoji;

    setUp(() {
      final file = File('test/fixtures/emoji_detailed.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      emoji = EmojiDetailed.fromJson(json);
    });

    test('deserializes without error', () {
      expect(emoji, isNotNull);
    });

    test('name is correct', () {
      expect(emoji.name, 'e2e_world');
    });

    test('has id and url', () {
      expect(emoji.id, isNotEmpty);
      expect(emoji.url, isNotEmpty);
    });

    test('aliases contains testemoji', () {
      expect(emoji.aliases, contains('testemoji'));
    });

    test('isSensitive is false', () {
      expect(emoji.isSensitive, isFalse);
    });

    test('localOnly is false', () {
      expect(emoji.localOnly, isFalse);
    });

    test('category is correct', () {
      expect(emoji.category, 'e2e');
    });

    test('license is correct', () {
      expect(emoji.license, 'CC0');
    });
  });
}
