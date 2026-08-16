import 'package:meta/meta.dart';

import '../../models/misskey_note.dart';
import '../../models/misskey_notification.dart';
import '../streaming_event.dart';
import '../streaming_message.dart';

const Set<String> _noteChannelNames = {
  'homeTimeline',
  'localTimeline',
  'hybridTimeline',
  'globalTimeline',
  'userList',
  'hashtag',
  'roleTimeline',
  'antenna',
  'channel',
};

/// Decodes one normalized subscription message into a typed event.
@internal
MisskeyStreamingEvent decodeStreamingEvent({
  required String channelName,
  required MisskeyStreamingMessage message,
}) {
  try {
    if (message.raw['type'] == 'noteUpdated') {
      return _decodeNoteUpdated(message);
    }
    if (_noteChannelNames.contains(channelName) && message.type == 'note') {
      return MisskeyNoteEvent(
        type: message.type,
        note: MisskeyNote.fromJson(_requireMap(message.body)),
      );
    }
    if (channelName == 'main') {
      switch (message.type) {
        case 'mention':
        case 'reply':
        case 'renote':
          return MisskeyNoteEvent(
            type: message.type,
            note: MisskeyNote.fromJson(_requireMap(message.body)),
          );
        case 'notification':
        case 'unreadNotification':
          return MisskeyNotificationEvent(
            type: message.type,
            notification: MisskeyNotification.fromJson(
              _requireMap(message.body),
            ),
          );
      }
    }
  } on Object catch (error) {
    return _unknown(message, decodeError: error);
  }
  return _unknown(message);
}

MisskeyStreamingEvent _decodeNoteUpdated(MisskeyStreamingMessage message) {
  if (message.type != 'reacted' &&
      message.type != 'unreacted' &&
      message.type != 'deleted' &&
      message.type != 'pollVoted') {
    return _unknown(message);
  }
  final envelope = _requireMap(message.raw['body']);
  final noteId = _requireString(envelope, 'id');
  final body = _requireMap(message.body);
  switch (message.type) {
    case 'reacted':
      final emojiValue = body['emoji'];
      final MisskeyStreamingReactionEmoji? emoji;
      if (emojiValue == null) {
        emoji = null;
      } else {
        final emojiBody = _requireMap(emojiValue);
        emoji = MisskeyStreamingReactionEmoji(
          name: _requireString(emojiBody, 'name'),
          url: _requireString(emojiBody, 'url'),
        );
      }
      return MisskeyNoteReactedEvent(
        noteId: noteId,
        reaction: _requireString(body, 'reaction'),
        emoji: emoji,
        userId: _requireString(body, 'userId'),
      );
    case 'unreacted':
      return MisskeyNoteUnreactedEvent(
        noteId: noteId,
        reaction: _requireString(body, 'reaction'),
        userId: _requireString(body, 'userId'),
      );
    case 'deleted':
      return MisskeyNoteDeletedEvent(
        noteId: noteId,
        deletedAt: DateTime.parse(_requireString(body, 'deletedAt')),
      );
    case 'pollVoted':
      final choice = body['choice'];
      if (choice is! int) {
        throw const FormatException('noteUpdated choice must be an integer');
      }
      return MisskeyNotePollVotedEvent(
        noteId: noteId,
        choice: choice,
        userId: _requireString(body, 'userId'),
      );
    default:
      return _unknown(message);
  }
}

MisskeyUnknownEvent _unknown(
  MisskeyStreamingMessage message, {
  Object? decodeError,
}) => MisskeyUnknownEvent(
  type: message.type,
  body: message.body,
  raw: message,
  decodeError: decodeError,
);

Map<String, Object?> _requireMap(Object? value) {
  if (value is! Map<Object?, Object?>) {
    throw const FormatException('Streaming event body must be an object');
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    final key = entry.key;
    if (key is! String) {
      throw const FormatException('Streaming event keys must be strings');
    }
    result[key] = entry.value;
  }
  return result;
}

String _requireString(Map<String, Object?> body, String key) {
  final value = body[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Streaming event $key must be a non-empty string');
  }
  return value;
}
