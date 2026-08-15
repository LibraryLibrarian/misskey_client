import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  test('defines the complete reusable connection lifecycle', () {
    expect(MisskeyStreamingConnectionState.values, [
      MisskeyStreamingConnectionState.disconnected,
      MisskeyStreamingConnectionState.connecting,
      MisskeyStreamingConnectionState.connected,
      MisskeyStreamingConnectionState.reconnecting,
      MisskeyStreamingConnectionState.disposed,
    ]);
  });
}
