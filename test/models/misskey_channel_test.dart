import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyChannel.fromJson', () {
    late MisskeyChannel channel;

    setUp(() {
      final file = File('test/fixtures/channels_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      channel = MisskeyChannel.fromJson(json);
    });

    test('deserializes without error', () {
      expect(channel, isNotNull);
    });

    test('name is correct', () {
      expect(channel.name, 'Test Channel');
    });

    test('description is correct', () {
      expect(channel.description, 'A test channel for API testing');
    });

    test('has id and createdAt', () {
      expect(channel.id, 'ak6ng5n1rt4w000u');
      expect(channel.createdAt, isA<DateTime>());
    });

    test('usersCount and notesCount are 0', () {
      expect(channel.usersCount, 0);
      expect(channel.notesCount, 0);
    });

    test('isArchived is false', () {
      expect(channel.isArchived, isFalse);
    });

    test('isSensitive is false', () {
      expect(channel.isSensitive, isFalse);
    });

    test('allowRenoteToExternal is true', () {
      expect(channel.allowRenoteToExternal, isTrue);
    });

    test('isMuting is false', () {
      expect(channel.isMuting, isFalse);
    });
  });
}
