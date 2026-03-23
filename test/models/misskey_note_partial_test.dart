import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyNotePartial.fromJson', () {
    late MisskeyNotePartial partial;

    setUp(() {
      final file = File('test/fixtures/notes_partial.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      partial = MisskeyNotePartial.fromJson(
        jsonList[0] as Map<String, dynamic>,
      );
    });

    test('id matches expected value', () {
      expect(partial.id, 'ak3pobcjrt4w0002');
    });

    test('reactions map has entries', () {
      expect(partial.reactions, isNotNull);
      expect(partial.reactions, isNotEmpty);
    });

    test('reactions contains heart emoji with count 1', () {
      expect(partial.reactions!['❤'], 1);
    });

    test('reactions contains thumbs-up emoji with count 1', () {
      expect(partial.reactions!['👍'], 1);
    });
  });
}
