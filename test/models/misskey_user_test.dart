import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyUser.fromJson', () {
    test('deserializes full user detail (users/show)', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.id, 'ak3po4qort4w0001');
      expect(user.username, 'testadmin');
      expect(user.host, isNull);
    });

    test('deserializes authenticated user (i)', () {
      final file = File('test/fixtures/i.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.id, 'ak3po4qort4w0001');
      expect(user.username, 'testadmin');
    });

    test('parses DateTime fields correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.createdAt, isA<DateTime>());
      expect(user.updatedAt, isA<DateTime>());
      expect(user.lastFetchedAt, isNull);
    });

    test('parses profile fields correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      // name フィールドは @JsonKey(defaultValue: '') により null → '' になる
      expect(user.name, '');
      expect(user.description, isNull);
      expect(user.location, isNull);
      expect(user.birthday, isNull);
    });

    test('parses counts correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.followersCount, 0);
      expect(user.followingCount, 0);
      expect(user.notesCount, 1);
    });

    test('parses boolean flags correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.isBot, false);
      expect(user.isCat, false);
      expect(user.isLocked, false);
      expect(user.isSilenced, false);
      expect(user.isSuspended, false);
    });

    test('parses empty collections correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.fields, isEmpty);
      expect(user.pinnedNotes, isEmpty);
      expect(user.avatarDecorations, isEmpty);
    });

    test('parses avatarUrl correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.avatarUrl, contains('identicon'));
    });

    test('deserializes inline UserLite from note', () {
      final file = File('test/fixtures/notes_show.json');
      final noteJson =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final userJson = noteJson['user'] as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(userJson);

      expect(user.id, 'ak3po4qort4w0001');
      expect(user.username, 'testadmin');
      // UserLite にはカウントフィールドがないが @JsonKey(defaultValue: 0) により 0 になる
      expect(user.followersCount, 0);
      expect(user.notesCount, 0);
    });
  });
}
