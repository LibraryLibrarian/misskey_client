import 'dart:async';
import 'dart:convert';

import 'package:misskey_client/src/streaming/internal/streaming_socket.dart';

/// Controls acknowledgement of channel connect frames.
enum StreamingAckMode { automatic, manual, never }

/// A ready socket with recorded frames and controllable channel events.
final class FakeStreamingSocket implements StreamingSocket {
  FakeStreamingSocket({this.ackMode = StreamingAckMode.automatic});

  final StreamingAckMode ackMode;
  final List<Map<String, dynamic>> sentFrames = [];
  final StreamController<Object?> _controller = StreamController<Object?>();

  @override
  Future<void> get ready => Future<void>.value();

  @override
  Stream<Object?> get stream => _controller.stream;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  void add(String data) {
    final frame = jsonDecode(data) as Map<String, dynamic>;
    sentFrames.add(frame);
    if (frame['type'] == 'connect' && ackMode == StreamingAckMode.automatic) {
      acknowledge((frame['body'] as Map)['id'] as String);
    }
  }

  /// Acknowledges a subscription unless acknowledgements are disabled.
  void acknowledge(String subscriptionId) {
    if (ackMode == StreamingAckMode.never) return;
    _controller.add(
      jsonEncode({
        'type': 'connected',
        'body': {'id': subscriptionId},
      }),
    );
  }

  /// Emits a channel event in the server wire format.
  void emitChannel(String subscriptionId, String type, Object? body) {
    _controller.add(
      jsonEncode({
        'type': 'channel',
        'body': {'id': subscriptionId, 'type': type, 'body': body},
      }),
    );
  }

  @override
  Future<void> close([int? closeCode, String? closeReason]) =>
      _controller.close();
}

/// Supplies sockets in order and records connection URIs.
final class FakeStreamingConnector {
  FakeStreamingConnector(this.sockets);

  final List<FakeStreamingSocket> sockets;
  final List<Uri> uris = [];

  StreamingSocket call(Uri uri) {
    final socket = sockets[uris.length];
    uris.add(uri);
    return socket;
  }
}
