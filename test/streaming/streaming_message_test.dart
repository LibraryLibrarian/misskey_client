import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyStreamingMessage', () {
    test('decodes an envelope and preserves its raw fields', () {
      final message = MisskeyStreamingMessage.fromJson({
        'type': 'channel',
        'body': {
          'id': 'subscription-id',
          'type': 'note',
          'body': {'id': 'note-id'},
        },
        'extension': true,
      });

      expect(message.type, 'channel');
      expect(message.body, isA<Map<String, Object?>>());
      expect(message.raw['extension'], isTrue);
    });

    test('accepts scalar and null bodies', () {
      final scalar = MisskeyStreamingMessage.fromJson({
        'type': 'deleted',
        'body': 'file-id',
      });
      final withoutBody = MisskeyStreamingMessage.fromJson({'type': 'pong'});

      expect(scalar.body, 'file-id');
      expect(withoutBody.body, isNull);
    });

    test('exposes an unmodifiable raw envelope', () {
      final source = <String, Object?>{'type': 'pong'};
      final message = MisskeyStreamingMessage.fromJson(source);

      expect(
        () => message.raw['body'] = null,
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('rejects a missing, empty, or non-string message type', () {
      for (final raw in <Map<String, Object?>>[
        {},
        {'type': ''},
        {'type': 1},
      ]) {
        expect(
          () => MisskeyStreamingMessage.fromJson(raw),
          throwsA(
            isA<MisskeyStreamingProtocolException>()
                .having(
                  (error) => error.operation,
                  'operation',
                  'decodeMessage',
                )
                .having(
                  (error) => error.context?['raw'],
                  'raw context',
                  same(raw),
                ),
          ),
        );
      }
    });
  });
}
