import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyNotification.fromJson', () {
    late List<MisskeyNotification> notifications;

    setUp(() {
      final file = File('test/fixtures/notifications.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      notifications = jsonList
          .map((e) => MisskeyNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes all notifications without error', () {
      expect(notifications, isNotEmpty);
    });

    group('mention notification', () {
      late MisskeyNotification mention;

      setUp(
        () => mention = notifications.firstWhere(
          (n) => n.type == MisskeyNotificationType.mention,
        ),
      );

      test('has id and createdAt', () {
        expect(mention.id, isNotEmpty);
        expect(mention.createdAt, isA<DateTime>());
      });

      test('type is mention', () {
        expect(mention.type, MisskeyNotificationType.mention);
      });

      test('has userId and user', () {
        expect(mention.userId, isNotNull);
        expect(mention.user, isNotNull);
      });

      test('note contains a mention to the recipient', () {
        expect(mention.note, isNotNull);
        expect(mention.note!.text, contains('@'));
      });
    });

    group('reaction notification', () {
      late MisskeyNotification reaction;

      setUp(
        () => reaction = notifications.firstWhere(
          (n) => n.type == MisskeyNotificationType.reaction,
        ),
      );

      test('has id and createdAt', () {
        expect(reaction.id, isNotEmpty);
        expect(reaction.createdAt, isA<DateTime>());
      });

      test('type is reaction', () {
        expect(reaction.type, MisskeyNotificationType.reaction);
      });

      test('reaction string is not empty', () {
        expect(reaction.reaction, isNotEmpty);
      });

      test('has note', () {
        expect(reaction.note, isNotNull);
      });

      test('has userId and user', () {
        expect(reaction.userId, isNotNull);
        expect(reaction.user, isNotNull);
      });
    });

    group('renote notification', () {
      late MisskeyNotification renote;

      setUp(
        () => renote = notifications.firstWhere(
          (n) => n.type == MisskeyNotificationType.renote,
        ),
      );

      test('has id and createdAt', () {
        expect(renote.id, isNotEmpty);
        expect(renote.createdAt, isA<DateTime>());
      });

      test('type is renote', () {
        expect(renote.type, MisskeyNotificationType.renote);
      });

      test('has userId and user', () {
        expect(renote.userId, isNotNull);
        expect(renote.user, isNotNull);
      });
    });
  });
}
