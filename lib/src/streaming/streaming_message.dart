import 'package:meta/meta.dart';

import '../exception/misskey_client_exception.dart';

/// A raw message received from the Misskey Streaming API.
@immutable
class MisskeyStreamingMessage {
  /// Creates a decoded Streaming API message.
  MisskeyStreamingMessage({
    required this.type,
    required this.body,
    required Map<String, Object?> raw,
  }) : raw = Map.unmodifiable(raw);

  /// Decodes a Streaming API message envelope.
  factory MisskeyStreamingMessage.fromJson(Map<String, Object?> json) {
    final type = json['type'];
    if (type is! String || type.isEmpty) {
      throw MisskeyStreamingProtocolException(
        message: 'Streaming message type must be a non-empty string',
        operation: 'decodeMessage',
        context: {'raw': json},
      );
    }

    return MisskeyStreamingMessage(type: type, body: json['body'], raw: json);
  }

  /// The top-level Streaming API message type.
  final String type;

  /// The message payload.
  ///
  /// Depending on the event this may be a map, list, scalar value, or `null`.
  final Object? body;

  /// The complete decoded message envelope.
  final Map<String, Object?> raw;
}
