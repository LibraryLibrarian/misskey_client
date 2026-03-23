import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyNoteState.fromJson', () {
    late MisskeyNoteState state;

    setUp(() {
      final file = File('test/fixtures/notes_state.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      state = MisskeyNoteState.fromJson(json);
    });

    test('deserializes without error', () {
      expect(state, isNotNull);
    });

    test('isFavorited is true', () {
      expect(state.isFavorited, isTrue);
    });

    test('isMutedThread is false', () {
      expect(state.isMutedThread, isFalse);
    });
  });
}
