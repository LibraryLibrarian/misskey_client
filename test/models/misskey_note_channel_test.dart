import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyNoteChannel (notes_show_channel)', () {
    late MisskeyNote note;

    setUp(() {
      final file = File('test/fixtures/notes_show_channel.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      note = MisskeyNote.fromJson(json);
    });

    test('note deserializes with channel not null', () {
      expect(note.channel, isNotNull);
    });

    test('channel has expected id', () {
      expect(note.channel!.id, 'ak6ng5n1rt4w000u');
    });

    test('channel has name "Test Channel"', () {
      expect(note.channel!.name, 'Test Channel');
    });

    test('channel has color', () {
      expect(note.channel!.color, '#86b300');
    });

    test('channel isSensitive is false', () {
      expect(note.channel!.isSensitive, false);
    });

    test('channel allowRenoteToExternal is true', () {
      expect(note.channel!.allowRenoteToExternal, true);
    });

    test('channel has userId', () {
      expect(note.channel!.userId, isNotNull);
      expect(note.channel!.userId, isNotEmpty);
    });

    test('note channelId matches channel id', () {
      expect(note.channelId, note.channel!.id);
    });
  });
}
