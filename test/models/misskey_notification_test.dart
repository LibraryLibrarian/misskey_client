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

    test('deserializes all 3 notifications without error', () {
      expect(notifications, hasLength(3));
    });

    group('mention notification', () {
      late MisskeyNotification mention;

      setUp(() => mention = notifications[0]);

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

      test('note text contains @testadmin', () {
        expect(mention.note, isNotNull);
        expect(mention.note!.text, contains('@testadmin'));
      });
    });

    group('reaction notification', () {
      late MisskeyNotification reaction;

      setUp(() => reaction = notifications[1]);

      test('has id and createdAt', () {
        expect(reaction.id, isNotEmpty);
        expect(reaction.createdAt, isA<DateTime>());
      });

      test('type is reaction', () {
        expect(reaction.type, MisskeyNotificationType.reaction);
      });

      test('reaction string is correct', () {
        expect(reaction.reaction, '👍');
      });

      test('has note', () {
        expect(reaction.note, isNotNull);
      });

      test('has userId and user', () {
        expect(reaction.userId, isNotNull);
        expect(reaction.user, isNotNull);
      });
    });

    group('follow notification', () {
      late MisskeyNotification follow;

      setUp(() => follow = notifications[2]);

      test('has id and createdAt', () {
        expect(follow.id, isNotEmpty);
        expect(follow.createdAt, isA<DateTime>());
      });

      test('type is follow', () {
        expect(follow.type, MisskeyNotificationType.follow);
      });

      test('has userId and user', () {
        expect(follow.userId, isNotNull);
        expect(follow.user, isNotNull);
      });

      test('note is null', () {
        expect(follow.note, isNull);
      });
    });
  });
}
