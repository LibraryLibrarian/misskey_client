import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyStreamingEvent', () {
    late MisskeyNote note;
    late MisskeyNotification notification;

    setUpAll(() {
      final noteJson =
          jsonDecode(File('test/fixtures/notes_show.json').readAsStringSync())
              as Map<String, dynamic>;
      note = MisskeyNote.fromJson(noteJson);

      final notificationJson =
          jsonDecode(
                File('test/fixtures/notifications.json').readAsStringSync(),
              )
              as List<dynamic>;
      notification = MisskeyNotification.fromJson(
        notificationJson.first as Map<String, dynamic>,
      );
    });

    test('carries typed note and notification payloads', () {
      final noteEvent = MisskeyNoteEvent(type: 'note', note: note);
      final notificationEvent = MisskeyNotificationEvent(
        type: 'notification',
        notification: notification,
      );

      expect(noteEvent, isA<MisskeyStreamingEvent>());
      expect(noteEvent.type, 'note');
      expect(noteEvent.note, same(note));
      expect(notificationEvent, isA<MisskeyStreamingEvent>());
      expect(notificationEvent.type, 'notification');
      expect(notificationEvent.notification, same(notification));
    });

    test('represents every captured note update payload', () {
      const emoji = MisskeyStreamingReactionEmoji(
        name: 'party_parrot@.',
        url: 'https://misskey.example/emoji/party_parrot.webp',
      );
      const reacted = MisskeyNoteReactedEvent(
        noteId: 'note-1',
        reaction: ':party_parrot@.:',
        emoji: emoji,
        userId: 'user-1',
      );
      const unreacted = MisskeyNoteUnreactedEvent(
        noteId: 'note-1',
        reaction: ':party_parrot@.:',
        userId: 'user-1',
      );
      final deletedAt = DateTime.utc(2026, 8, 15, 1, 2, 3);
      final deleted = MisskeyNoteDeletedEvent(
        noteId: 'note-1',
        deletedAt: deletedAt,
      );
      const pollVoted = MisskeyNotePollVotedEvent(
        noteId: 'note-1',
        choice: 2,
        userId: 'user-2',
      );

      expect(reacted, isA<MisskeyNoteUpdatedEvent>());
      expect(reacted.type, 'reacted');
      expect(reacted.noteId, 'note-1');
      expect(reacted.reaction, ':party_parrot@.:');
      expect(reacted.emoji, same(emoji));
      expect(reacted.emoji!.name, 'party_parrot@.');
      expect(
        reacted.emoji!.url,
        'https://misskey.example/emoji/party_parrot.webp',
      );
      expect(reacted.userId, 'user-1');

      expect(unreacted, isA<MisskeyNoteUpdatedEvent>());
      expect(unreacted.type, 'unreacted');
      expect(unreacted.noteId, 'note-1');
      expect(unreacted.reaction, ':party_parrot@.:');
      expect(unreacted.userId, 'user-1');

      expect(deleted, isA<MisskeyNoteUpdatedEvent>());
      expect(deleted.type, 'deleted');
      expect(deleted.noteId, 'note-1');
      expect(deleted.deletedAt, same(deletedAt));

      expect(pollVoted, isA<MisskeyNoteUpdatedEvent>());
      expect(pollVoted.type, 'pollVoted');
      expect(pollVoted.noteId, 'note-1');
      expect(pollVoted.choice, 2);
      expect(pollVoted.userId, 'user-2');
    });

    test('preserves unknown payloads and decode errors safely', () {
      final rawEnvelope = <String, Object?>{
        'type': 'futureEvent',
        'body': {'value': 1},
      };
      final rawMessage = MisskeyStreamingMessage(
        type: 'futureEvent',
        body: rawEnvelope['body'],
        raw: rawEnvelope,
      );
      final decodeError = FormatException('future payload');
      final event = MisskeyUnknownEvent(
        type: rawMessage.type,
        body: rawMessage.body,
        raw: rawMessage,
        decodeError: decodeError,
      );
      rawEnvelope['type'] = 'changed';

      expect(event, isA<MisskeyStreamingEvent>());
      expect(event.type, 'futureEvent');
      expect(event.body, {'value': 1});
      expect(event.raw, same(rawMessage));
      expect(event.raw.raw['type'], 'futureEvent');
      expect(event.decodeError, same(decodeError));
      expect(() => event.raw.raw['new'] = true, throwsUnsupportedError);
    });
  });
}
