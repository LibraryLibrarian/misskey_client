import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyClip.fromJson', () {
    test('deserializes clip from list', () {
      final file = File('test/fixtures/clips_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final clip = MisskeyClip.fromJson(jsonList.first as Map<String, dynamic>);

      expect(clip.id, 'ak3px5fqrt4w0007');
      expect(clip.name, 'Test Clip');
      expect(clip.userId, 'ak3po4qort4w0001');
      expect(clip.createdAt, isA<DateTime>());
      expect(clip.isPublic, false);
      expect(clip.favoritedCount, 0);
    });

    test('parses nullable description', () {
      final file = File('test/fixtures/clips_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final clip = MisskeyClip.fromJson(jsonList.first as Map<String, dynamic>);

      expect(clip.description, isNull);
    });

    test('includes embedded user', () {
      final file = File('test/fixtures/clips_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final clip = MisskeyClip.fromJson(jsonList.first as Map<String, dynamic>);

      expect(clip.user, isNotNull);
      expect(clip.user?.username, 'testadmin');
    });

    test('parses notesCount', () {
      final file = File('test/fixtures/clips_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final clip = MisskeyClip.fromJson(jsonList.first as Map<String, dynamic>);

      expect(clip.notesCount, 1);
    });

    test('notesCount is null when the field is absent', () {
      final file = File('test/fixtures/clips_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final json = (jsonList.first as Map<String, dynamic>)
        ..remove('notesCount');

      final clip = MisskeyClip.fromJson(json);

      expect(clip.notesCount, isNull);
    });
  });
}
