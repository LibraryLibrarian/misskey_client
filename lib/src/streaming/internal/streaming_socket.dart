import 'package:web_socket_channel/web_socket_channel.dart';

/// A minimal WebSocket abstraction used by the streaming transport.
abstract interface class StreamingSocket {
  /// Completes when the WebSocket handshake has finished.
  Future<void> get ready;

  /// Messages and transport errors received from the server.
  Stream<Object?> get stream;

  /// The close code received from the server, when available.
  int? get closeCode;

  /// The close reason received from the server, when available.
  String? get closeReason;

  /// Sends a text frame.
  void add(String data);

  /// Starts closing the socket.
  Future<void> close([int? closeCode, String? closeReason]);
}

/// Creates a streaming socket for [uri].
typedef StreamingSocketConnector = StreamingSocket Function(Uri uri);

/// Creates the package's default WebSocket transport.
StreamingSocket connectStreamingSocket(Uri uri) =>
    WebSocketChannelStreamingSocket(WebSocketChannel.connect(uri));

/// Adapts a [WebSocketChannel] to [StreamingSocket].
final class WebSocketChannelStreamingSocket implements StreamingSocket {
  /// Creates an adapter around [channel].
  WebSocketChannelStreamingSocket(this.channel);

  /// The wrapped WebSocket channel.
  final WebSocketChannel channel;

  @override
  Future<void> get ready => channel.ready;

  @override
  Stream<Object?> get stream => channel.stream.cast<Object?>();

  @override
  int? get closeCode => channel.closeCode;

  @override
  String? get closeReason => channel.closeReason;

  @override
  void add(String data) => channel.sink.add(data);

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    await channel.sink.close(closeCode, closeReason);
  }
}
