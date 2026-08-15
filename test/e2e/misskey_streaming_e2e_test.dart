@Tags(['e2e'])
library;

import 'dart:async';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/streaming/internal/streaming_socket.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';

import 'e2e_env.dart';

void main() {
  final env = E2eEnv.tryLoad();
  if (env == null) {
    test('misskey streaming e2e', () {}, skip: E2eEnv.skipReason);
    return;
  }

  test(
    'connects, subscribes, receives a note, and captures its deletion',
    () async {
      final client = env.createMisskeyClient();
      final streaming = MisskeyStreaming.withConnector(
        baseUrl: Uri.parse(env.misskeyBaseUrl),
        tokenProvider: () => env.misskeyUserToken,
        config: MisskeyStreamingConfig(enableAutoReconnect: false),
        connector: (uri) =>
            _connectWithRootCa(uri: uri, rootCaPath: env.rootCaPath),
      );
      final streamingErrors = <MisskeyStreamingException>[];
      final errorSubscription = streaming.errors.listen(streamingErrors.add);
      MisskeyStreamingSubscription? timeline;
      MisskeyStreamingSubscription? captureBarrier;
      String? noteId;
      var noteDeleted = false;

      try {
        await streaming.connect();
        expect(streaming.state, MisskeyStreamingConnectionState.connected);

        // subscribeの完了はserverのconnected ACKを待つ。
        timeline = await streaming.subscribe(
          const MisskeyStreamingChannel.homeTimeline(),
        );
        expect(timeline.isActive, isTrue);

        final marker = 'e2e streaming ${DateTime.now().microsecondsSinceEpoch}';
        final streamedNoteFuture = timeline.notes
            .firstWhere((note) => note.text == marker)
            .timeout(const Duration(seconds: 30));
        final created = await client.notes.create(text: marker);
        noteId = created.id;

        final streamedNote = await streamedNoteFuture;
        expect(streamedNote.id, created.id);
        expect(streamedNote.text, marker);

        timeline.captureNote(created.id);

        // subNoteにはACKがないため、同一socketの後続connected ACKを
        // capture登録完了の順序barrierとして利用する。
        captureBarrier = await streaming.subscribe(
          const MisskeyStreamingChannel.localTimeline(),
        );

        final deletedEventFuture = timeline.events
            .where((event) => event is MisskeyNoteDeletedEvent)
            .cast<MisskeyNoteDeletedEvent>()
            .firstWhere((event) => event.noteId == created.id)
            .timeout(const Duration(seconds: 30));
        await client.notes.delete(noteId: created.id);
        noteDeleted = true;

        final deletedEvent = await deletedEventFuture;
        expect(deletedEvent.noteId, created.id);
        expect(deletedEvent.deletedAt, isNotNull);

        timeline.uncaptureNote(created.id);
        await captureBarrier.unsubscribe();
        await timeline.unsubscribe();
        expect(captureBarrier.isActive, isFalse);
        expect(timeline.isActive, isFalse);

        await streaming.disconnect();
        expect(streaming.state, MisskeyStreamingConnectionState.disconnected);
        expect(streamingErrors, isEmpty);
      } finally {
        if (!noteDeleted && noteId != null) {
          try {
            await client.notes.delete(noteId: noteId);
          } on MisskeyNotFoundException {
            // 削除要求が成功した後に応答だけ失敗した場合は既に存在しない。
          } on MisskeyRateLimitException {
            // E2E環境のrate limit時は既存cleanup規約に合わせて許容する。
          }
        }
        await errorSubscription.cancel();
        try {
          await streaming.dispose();
        } finally {
          await client.dispose();
        }
      }
    },
  );
}

StreamingSocket _connectWithRootCa({
  required Uri uri,
  required String rootCaPath,
}) {
  final context = SecurityContext(withTrustedRoots: true)
    ..setTrustedCertificates(rootCaPath);
  final httpClient = HttpClient(context: context);
  final channel = IOWebSocketChannel.connect(uri, customClient: httpClient);
  return _OwnedHttpClientStreamingSocket(
    WebSocketChannelStreamingSocket(channel),
    httpClient,
  );
}

final class _OwnedHttpClientStreamingSocket implements StreamingSocket {
  _OwnedHttpClientStreamingSocket(this._socket, this._httpClient);

  final WebSocketChannelStreamingSocket _socket;
  final HttpClient _httpClient;
  bool _isClosed = false;

  @override
  Future<void> get ready => _socket.ready;

  @override
  Stream<Object?> get stream => _socket.stream;

  @override
  int? get closeCode => _socket.closeCode;

  @override
  String? get closeReason => _socket.closeReason;

  @override
  void add(String data) => _socket.add(data);

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    if (_isClosed) return;
    _isClosed = true;
    try {
      await _socket.close(closeCode, closeReason);
    } finally {
      _httpClient.close(force: true);
    }
  }
}
