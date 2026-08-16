import 'package:meta/meta.dart';

import '../models/misskey_note.dart';
import '../models/misskey_notification.dart';
import 'streaming_message.dart';

/// A typed event decoded from a Misskey Streaming API message.
@immutable
sealed class MisskeyStreamingEvent {
  /// Creates a typed Streaming API event.
  const MisskeyStreamingEvent({required this.type});

  /// The normalized Streaming API event type.
  final String type;
}

/// A Streaming API event whose payload is a note.
@immutable
final class MisskeyNoteEvent extends MisskeyStreamingEvent {
  /// Creates a note event.
  const MisskeyNoteEvent({required super.type, required this.note});

  /// The note carried by the event.
  final MisskeyNote note;
}

/// A Streaming API event whose payload is a notification.
@immutable
final class MisskeyNotificationEvent extends MisskeyStreamingEvent {
  /// Creates a notification event.
  const MisskeyNotificationEvent({
    required super.type,
    required this.notification,
  });

  /// The notification carried by the event.
  final MisskeyNotification notification;
}

/// A typed event for a captured note update.
@immutable
sealed class MisskeyNoteUpdatedEvent extends MisskeyStreamingEvent {
  /// Creates a captured note update event.
  const MisskeyNoteUpdatedEvent({required super.type, required this.noteId});

  /// The identifier of the updated note.
  final String noteId;
}

/// Custom emoji information attached to a reaction event.
@immutable
final class MisskeyStreamingReactionEmoji {
  /// Creates custom emoji information.
  const MisskeyStreamingReactionEmoji({required this.name, required this.url});

  /// The emoji name, including its host suffix when applicable.
  final String name;

  /// The public URL of the emoji image.
  final String url;
}

/// A reaction added to a captured note.
@immutable
final class MisskeyNoteReactedEvent extends MisskeyNoteUpdatedEvent {
  /// Creates a captured note reaction event.
  const MisskeyNoteReactedEvent({
    required super.noteId,
    required this.reaction,
    required this.userId,
    this.emoji,
  }) : super(type: 'reacted');

  /// The reaction string.
  final String reaction;

  /// The custom emoji information, if the reaction uses one.
  final MisskeyStreamingReactionEmoji? emoji;

  /// The identifier of the user who reacted.
  final String userId;
}

/// A reaction removed from a captured note.
@immutable
final class MisskeyNoteUnreactedEvent extends MisskeyNoteUpdatedEvent {
  /// Creates a captured note reaction removal event.
  const MisskeyNoteUnreactedEvent({
    required super.noteId,
    required this.reaction,
    required this.userId,
  }) : super(type: 'unreacted');

  /// The reaction string.
  final String reaction;

  /// The identifier of the user who removed the reaction.
  final String userId;
}

/// A captured note that was deleted.
@immutable
final class MisskeyNoteDeletedEvent extends MisskeyNoteUpdatedEvent {
  /// Creates a captured note deletion event.
  const MisskeyNoteDeletedEvent({
    required super.noteId,
    required this.deletedAt,
  }) : super(type: 'deleted');

  /// The date and time when the note was deleted.
  final DateTime deletedAt;
}

/// A vote added to a poll on a captured note.
@immutable
final class MisskeyNotePollVotedEvent extends MisskeyNoteUpdatedEvent {
  /// Creates a captured note poll vote event.
  const MisskeyNotePollVotedEvent({
    required super.noteId,
    required this.choice,
    required this.userId,
  }) : super(type: 'pollVoted');

  /// The zero-based index of the selected poll choice.
  final int choice;

  /// The identifier of the user who voted.
  final String userId;
}

/// An unsupported event or an event whose typed payload could not be decoded.
@immutable
final class MisskeyUnknownEvent extends MisskeyStreamingEvent {
  /// Creates an event that preserves its undecoded data.
  const MisskeyUnknownEvent({
    required super.type,
    required this.body,
    required this.raw,
    this.decodeError,
  });

  /// The undecoded event payload.
  final Object? body;

  /// The source Streaming API message.
  final MisskeyStreamingMessage raw;

  /// The error that prevented typed decoding, if any.
  final Object? decodeError;
}
