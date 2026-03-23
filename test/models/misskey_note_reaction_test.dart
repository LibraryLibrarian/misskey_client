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
      expect(first.id, 'ak6nei91rt4w000t');
      expect(first.createdAt, isA<DateTime>());
      expect(first.type, '❤');
      expect(first.user, isNotNull);
    });

    test('second reaction has correct type', () {
      expect(reactions[1].type, '👍');
    });

    test('each reaction user has id and username', () {
      expect(reactions[0].user.id, 'ak3po4qort4w0001');
      expect(reactions[0].user.username, 'testadmin');
      expect(reactions[1].user.id, 'ak3qbtu5rt4w0009');
      expect(reactions[1].user.username, 'testuser2');
    });
  });
}
