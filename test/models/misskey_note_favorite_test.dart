import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyNoteFavorite.fromJson', () {
    late List<MisskeyNoteFavorite> list;

    setUp(() {
      final file = File('test/fixtures/note_favorites.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map((e) => MisskeyNoteFavorite.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list', () {
      expect(list, isNotEmpty);
    });

    test('first item has correct id and createdAt', () {
      final first = list[0];
      expect(first.id, 'ak6njq9frt4w0010');
      expect(first.createdAt, isA<DateTime>());
    });

    test('note is not null', () {
      expect(list[0].note, isNotNull);
    });

    test('note.id matches noteId', () {
      final favorite = list[0];
      expect(favorite.note!.id, favorite.noteId);
      expect(favorite.note!.id, 'ak3pobcjrt4w0002');
    });
  });
}
