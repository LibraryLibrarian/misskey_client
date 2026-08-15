import 'dart:async';

import 'package:meta/meta.dart';

import '../models/misskey_note.dart';
import '../models/misskey_notification.dart';
import 'streaming_event.dart';
import 'streaming_message.dart';

/// A handle for a Misskey Streaming API channel subscription.
class MisskeyStreamingSubscription {
  /// Creates a subscription handle managed by the streaming client.
  @internal
  MisskeyStreamingSubscription({
    required this.id,
    required this.channel,
    required Map<String, Object?> params,
    required Stream<MisskeyStreamingMessage> messages,
    required Stream<MisskeyStreamingEvent> events,
    required Future<void> Function() onUnsubscribe,
    required bool Function() onIsActive,
    required void Function(String noteId) onCaptureNote,
    required void Function(String noteId) onUncaptureNote,
  }) : params = Map.unmodifiable(params),
       _messages = messages,
       _events = events,
       _notes = events
           .where((event) => event is MisskeyNoteEvent)
           .map((event) => (event as MisskeyNoteEvent).note),
       _notifications = events
           .where((event) => event is MisskeyNotificationEvent)
           .map((event) => (event as MisskeyNotificationEvent).notification),
       _onUnsubscribe = onUnsubscribe,
       _onIsActive = onIsActive,
       _onCaptureNote = onCaptureNote,
       _onUncaptureNote = onUncaptureNote;

  /// The connection-local identifier used to route channel messages.
  final String id;

  /// The raw Misskey Streaming API channel name.
  final String channel;

  /// The raw Misskey Streaming API channel name.
  String get channelName => channel;

  /// The parameters sent when connecting to [channel].
  final Map<String, Object?> params;

  final Stream<MisskeyStreamingMessage> _messages;
  final Stream<MisskeyStreamingEvent> _events;
  final Stream<MisskeyNote> _notes;
  final Stream<MisskeyNotification> _notifications;
  final Future<void> Function() _onUnsubscribe;
  final bool Function() _onIsActive;
  final void Function(String noteId) _onCaptureNote;
  final void Function(String noteId) _onUncaptureNote;
  Future<void>? _unsubscribeFuture;

  /// Inner channel and captured note events routed to this subscription.
  Stream<MisskeyStreamingMessage> get messages => _messages;

  /// Typed events decoded from [messages].
  Stream<MisskeyStreamingEvent> get events => _events;

  /// Notes extracted from [events].
  Stream<MisskeyNote> get notes => _notes;

  /// Notifications extracted from [events].
  Stream<MisskeyNotification> get notifications => _notifications;

  /// Whether this subscription is still registered with the client.
  bool get isActive => _onIsActive();

  /// Starts receiving `noteUpdated` events for [noteId].
  ///
  /// Repeated calls for the same note and subscription are idempotent.
  void captureNote(String noteId) => _onCaptureNote(noteId);

  /// Stops receiving `noteUpdated` events for [noteId].
  ///
  /// Repeated calls for a note that is not captured are idempotent.
  void uncaptureNote(String noteId) => _onUncaptureNote(noteId);

  /// Removes this subscription and releases its local resources.
  ///
  /// Calling this method concurrently or repeatedly is safe.
  Future<void> unsubscribe() => _unsubscribeFuture ??= _onUnsubscribe();
}
