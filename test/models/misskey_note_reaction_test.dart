import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyNoteReaction.fromJson', () {
    late List<MisskeyNoteReaction> reactions;

    setUp(() {
      final file = File('test/fixtures/notes_reactions.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      reactions = jsonList
          .map((e) => MisskeyNoteReaction.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list of 2 reactions', () {
      expect(reactions, hasLength(2));
    });

    test('first reaction has correct id, createdAt, type, and user', () {
      final first = reactions[0];
      expect(first.id, isNotEmpty);
      expect(first.createdAt, isA<DateTime>());
      expect(first.type, '🎉');
      expect(first.user, isNotNull);
    });

    // 2件目はカスタム絵文字リアクション(`:name@host:` 形式)
    test('second reaction is a custom emoji reaction', () {
      expect(reactions[1].type, startsWith(':'));
      expect(reactions[1].type, endsWith(':'));
    });

    test('each reaction user has id and username', () {
      expect(reactions[0].user.id, isNotEmpty);
      expect(reactions[0].user.username, 'mk_ann');
      expect(reactions[1].user.id, isNotEmpty);
      expect(reactions[1].user.username, 'mk_ben');
    });
  });
}
