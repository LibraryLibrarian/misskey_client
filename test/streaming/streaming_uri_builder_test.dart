import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/streaming/internal/streaming_uri_builder.dart';
import 'package:test/test.dart';

void main() {
  group('buildStreamingUri', () {
    test('converts HTTP schemes to WebSocket schemes', () {
      expect(
        buildStreamingUri(Uri.parse('https://misskey.example')),
        Uri.parse('wss://misskey.example/streaming'),
      );
      expect(
        buildStreamingUri(Uri.parse('http://localhost:3000')),
        Uri.parse('ws://localhost:3000/streaming'),
      );
    });

    test('removes a trailing api segment with or without a slash', () {
      expect(
        buildStreamingUri(Uri.parse('https://misskey.example/api')),
        Uri.parse('wss://misskey.example/streaming'),
      );
      expect(
        buildStreamingUri(Uri.parse('https://misskey.example/api/')),
        Uri.parse('wss://misskey.example/streaming'),
      );
    });

    test('preserves subpaths and only removes a final api segment', () {
      expect(
        buildStreamingUri(Uri.parse('https://misskey.example/sub/api/')),
        Uri.parse('wss://misskey.example/sub/streaming'),
      );
      expect(
        buildStreamingUri(Uri.parse('https://misskey.example/api/sub')),
        Uri.parse('wss://misskey.example/api/sub/streaming'),
      );
    });

    test('discards source query parameters and fragments', () {
      final uri = buildStreamingUri(
        Uri.parse('https://misskey.example/sub?existing=value#fragment'),
      );

      expect(uri, Uri.parse('wss://misskey.example/sub/streaming'));
      expect(uri.hasQuery, isFalse);
      expect(uri.hasFragment, isFalse);
    });

    test('encodes a non-empty token as the i query parameter', () {
      const token = 'a token&with=special/characters';
      final uri = buildStreamingUri(
        Uri.parse('https://misskey.example'),
        token: token,
      );

      expect(uri.queryParameters, {'i': token});
      expect(uri.toString(), isNot(contains('a token')));
      expect(uri.toString(), isNot(contains('&with=')));
    });

    test('omits the i query parameter for null and empty tokens', () {
      expect(
        buildStreamingUri(Uri.parse('https://misskey.example')).hasQuery,
        isFalse,
      );
      expect(
        buildStreamingUri(
          Uri.parse('https://misskey.example'),
          token: '',
        ).hasQuery,
        isFalse,
      );
    });

    test('rejects unsupported schemes with structured context', () {
      expect(
        () => buildStreamingUri(Uri.parse('ftp://misskey.example')),
        throwsA(
          isA<MisskeyStreamingConnectionException>()
              .having(
                (error) => error.operation,
                'operation',
                'buildStreamingUri',
              )
              .having(
                (error) => error.context?['scheme'],
                'scheme context',
                'ftp',
              ),
        ),
      );
    });
  });
}
