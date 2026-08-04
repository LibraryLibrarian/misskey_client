import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyNote.fromJson', () {
    test('deserializes a simple note', () {
      final file = File('test/fixtures/notes_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final note = MisskeyNote.fromJson(json);

      expect(note.id, isNotEmpty);
      expect(note.text, isNotEmpty);
      expect(note.userId, isNotEmpty);
      expect(note.visibility, MisskeyNoteVisibility.public);
      expect(note.createdAt, isA<DateTime>());
    });

    test('deserializes embedded user (UserLite)', () {
      final file = File('test/fixtures/notes_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final note = MisskeyNote.fromJson(json);

      expect(note.user.id, note.userId);
      expect(note.user.username, isNotEmpty);
      expect(note.user.host, isNull);
    });

    test('deserializes note with reply (nested self-reference)', () {
      final file = File('test/fixtures/notes_show_reply.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final note = MisskeyNote.fromJson(json);

      expect(note.id, 'ak3pwzjvrt4w0006');
      expect(note.replyId, 'ak3pobcjrt4w0002');
      expect(note.reply, isNotNull);
      expect(note.reply!.id, 'ak3pobcjrt4w0002');
      expect(note.reply!.text, 'Hello, this is a test note for API testing!');
      expect(note.reply!.user.username, 'testadmin');
    });

    test('deserializes note list (timeline)', () {
      final file = File('test/fixtures/notes_timeline.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final notes = jsonList
          .map((e) => MisskeyNote.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(notes, isNotEmpty);
      expect(notes.first.id, isNotEmpty);
    });

    test('handles null optional fields correctly', () {
      final file = File('test/fixtures/notes_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final note = MisskeyNote.fromJson(json);

      expect(note.cw, isNull);
      expect(note.replyId, isNull);
      expect(note.renoteId, isNull);
      expect(note.reply, isNull);
      expect(note.renote, isNull);
      expect(note.reactionAcceptance, isNull);
    });

    test('handles empty collections correctly', () {
      final file = File('test/fixtures/notes_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final note = MisskeyNote.fromJson(json);

      expect(note.fileIds, isEmpty);
      expect(note.files, isEmpty);
      expect(note.reactions, isEmpty);
    });

    test('parses counts correctly', () {
      final file = File('test/fixtures/notes_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final note = MisskeyNote.fromJson(json);

      expect(note.renoteCount, 0);
      expect(note.repliesCount, 0);
      expect(note.reactionCount, 0);
    });

    test(
        'visibility falls back to public for a value not yet known to '
        'this client', () {
      final file = File('test/fixtures/notes_show.json');
      final json = (jsonDecode(file.readAsStringSync()) as Map<String, dynamic>)
        ..['visibility'] = 'someFutureVisibilityNotInEnum';

      final note = MisskeyNote.fromJson(json);

      // MisskeyNoteVisibility には専用のunknown値が無く、
      // 実装上はpublicへフォールバックする
      expect(note.visibility, MisskeyNoteVisibility.public);
    });

    test(
        'reactionAcceptance falls back to unknown for a value not yet '
        'known to this client', () {
      final file = File('test/fixtures/notes_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      json['reactionAcceptance'] = 'someFutureValueNotInEnum';

      final note = MisskeyNote.fromJson(json);

      expect(note.reactionAcceptance, MisskeyReactionAcceptance.unknown);
    });

    test('reactionAcceptance is null when the field is absent', () {
      final file = File('test/fixtures/notes_show.json');
      final json = (jsonDecode(file.readAsStringSync()) as Map<String, dynamic>)
        ..remove('reactionAcceptance');

      final note = MisskeyNote.fromJson(json);

      expect(note.reactionAcceptance, isNull);
    });
  });
}
