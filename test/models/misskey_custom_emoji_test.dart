import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyCustomEmoji.fromJson', () {
    late MisskeyCustomEmoji emoji;

    setUp(() {
      final file = File('test/fixtures/emojis.json');
      final jsonMap =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      // フィクスチャは {"emojis": [...]} の形式で包まれている
      final jsonList = jsonMap['emojis'] as List<dynamic>;
      emoji = MisskeyCustomEmoji.fromJson(
        jsonList.first as Map<String, dynamic>,
      );
    });

    test('deserializes without error', () {
      expect(emoji, isNotNull);
    });

    test('shortcode is correct', () {
      expect(emoji.shortcode, 'test_emoji');
    });

    test('category is correct', () {
      expect(emoji.category, 'test');
    });

    test('aliases are correct', () {
      expect(emoji.aliases, ['testemoji']);
    });

    test('url contains localhost:3000', () {
      expect(emoji.url, contains('localhost:3000'));
    });
  });
}
