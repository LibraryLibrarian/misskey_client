import 'dart:async';

import 'package:meta/meta.dart';

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
    required Future<void> Function() onUnsubscribe,
  }) : params = Map.unmodifiable(params),
       _messages = messages,
       _onUnsubscribe = onUnsubscribe;

  /// The connection-local identifier used to route channel messages.
  final String id;

  /// The raw Misskey Streaming API channel name.
  final String channel;

  /// The parameters sent when connecting to [channel].
  final Map<String, Object?> params;

  final Stream<MisskeyStreamingMessage> _messages;
  final Future<void> Function() _onUnsubscribe;
  Future<void>? _unsubscribeFuture;

  /// Raw messages routed to this subscription.
  Stream<MisskeyStreamingMessage> get messages => _messages;

  /// Removes this subscription and releases its local resources.
  ///
  /// Calling this method concurrently or repeatedly is safe.
  Future<void> unsubscribe() => _unsubscribeFuture ??= _onUnsubscribe();
}
