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

  group('MisskeyNotification.fromJson - unknown type', () {
    test('type falls back to unknown for a value not yet known to this '
        'client', () {
      final notification = MisskeyNotification.fromJson({
        'id': 'abc123',
        'createdAt': '2026-01-01T00:00:00.000Z',
        'type': 'someFutureNotificationTypeNotInEnum',
      });

      expect(notification.type, MisskeyNotificationType.unknown);
    });
  });

  group('MisskeyNotification.fromJson - required type payloads', () {
    late Map<String, dynamic> fixture;
    late List<MisskeyNotification> notifications;

    setUpAll(() {
      fixture =
          jsonDecode(
                File(
                  'test/fixtures/notifications_schema_examples.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      notifications = (fixture['notifications'] as List<dynamic>)
          .map((e) => MisskeyNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('fixture records its schema-derived, non-live provenance', () {
      final provenance = fixture['provenance'] as Map<String, dynamic>;

      expect(provenance['kind'], 'upstream-schema-derived-example');
      expect(provenance['liveServerCaptured'], isFalse);
      expect(
        provenance['upstreamCommit'],
        '0b49119a3fb93e7be3a611831d64a1fcbb78e44e',
      );
    });

    test('deserializes an export-completed payload', () {
      final notification = notifications.firstWhere(
        (value) => value.type == MisskeyNotificationType.exportCompleted,
      );

      expect(notification.type, MisskeyNotificationType.exportCompleted);
      expect(
        notification.exportedEntity,
        MisskeyUserExportableEntity.customEmoji,
      );
      expect(notification.fileId, 'file-export-1');
    });

    test(
      'falls back for a future export entity without losing the file ID',
      () {
        final notification = MisskeyNotification.fromJson({
          'id': 'notification-future-export',
          'createdAt': '2026-08-25T00:00:00.000Z',
          'type': 'exportCompleted',
          'exportedEntity': 'futureEntity',
          'fileId': 'file-2',
        });

        expect(
          notification.exportedEntity,
          MisskeyUserExportableEntity.unknown,
        );
        expect(notification.fileId, 'file-2');
      },
    );

    test('deserializes a chat-room invitation payload', () {
      final notification = notifications.firstWhere(
        (value) =>
            value.type == MisskeyNotificationType.chatRoomInvitationReceived,
      );

      expect(
        notification.type,
        MisskeyNotificationType.chatRoomInvitationReceived,
      );
      expect(notification.invitation?.id, 'invitation-1');
      expect(notification.invitation?.roomId, 'room-1');
      expect(notification.invitation?.user?.username, 'inviter');
      expect(notification.invitation?.room?.name, 'Schema example room');
    });

    test('deserializes a failed scheduled-note draft payload', () {
      final notification = notifications.firstWhere(
        (value) =>
            value.type == MisskeyNotificationType.scheduledNotePostFailed,
      );

      expect(
        notification.type,
        MisskeyNotificationType.scheduledNotePostFailed,
      );
      expect(notification.noteDraft?.id, 'draft-failed-1');
      expect(notification.noteDraft?.user?.username, 'author');
      expect(notification.noteDraft?.files, isEmpty);
    });

    test('round-trips every schema-derived notification payload', () {
      for (final notification in notifications) {
        expect(
          MisskeyNotification.fromJson(notification.toJson()),
          notification,
          reason: notification.type.name,
        );
      }
    });
  });
}
