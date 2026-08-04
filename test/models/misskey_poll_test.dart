import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyNote with poll', () {
    late MisskeyNote note;

    setUp(() {
      final file = File('test/fixtures/notes_show_poll.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      note = MisskeyNote.fromJson(json);
    });

    test('deserializes note with poll not null', () {
      expect(note.poll, isNotNull);
    });

    test('poll has 3 choices', () {
      expect(note.poll!.choices, hasLength(3));
    });

    test('choices[0] has correct text, votes, and isVoted', () {
      final choice = note.poll!.choices[0];
      expect(choice.text, 'Dart');
      expect(choice.votes, greaterThanOrEqualTo(1));
      expect(choice.isVoted, isFalse);
    });

    test('poll.multiple is false', () {
      expect(note.poll!.multiple, isFalse);
    });

    test('poll.expiresAt is a DateTime', () {
      expect(note.poll!.expiresAt, isA<DateTime>());
    });
  });
}
