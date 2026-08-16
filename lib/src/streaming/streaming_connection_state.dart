/// The lifecycle state of a Misskey Streaming API connection.
enum MisskeyStreamingConnectionState {
  /// No WebSocket connection is active.
  disconnected,

  /// The initial WebSocket connection is being established.
  connecting,

  /// The WebSocket connection is open and ready for messages.
  connected,

  /// A replacement connection is being established after a disconnection.
  reconnecting,

  /// The streaming client has released its resources and cannot be reused.
  disposed,
}
