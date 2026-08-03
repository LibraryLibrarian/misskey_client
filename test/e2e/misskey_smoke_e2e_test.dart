@Tags(['e2e'])
library;

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import 'e2e_env.dart';

/// fediverse_e2e 環境(misskey.test)に対する単一サーバーのスモークテスト
void main() {
  final env = E2eEnv.tryLoad();
  if (env == null) {
    test('misskey smoke e2e', () {}, skip: E2eEnv.skipReason);
    return;
  }

  late MisskeyClient client;

  setUpAll(() {
    client = env.createMisskeyClient();
  });

  group('meta', () {
    test('getMeta returns instance metadata', () async {
      final meta = await client.meta.getMeta();
      expect(meta.uri, env.misskeyBaseUrl);
      expect(meta.version, isNotNull);
    });

    test('ping succeeds', () async {
      final pong = await client.meta.ping();
      expect(pong, isPositive);
    });
  });

  group('notes', () {
    test('create -> show -> delete round trip', () async {
      final marker = 'e2e smoke ${DateTime.now().millisecondsSinceEpoch}';
      final created = await client.notes.create(text: marker);
      expect(created.text, marker);

      final shown = await client.notes.show(noteId: created.id);
      expect(shown.id, created.id);
      expect(shown.text, marker);

      await client.notes.delete(noteId: created.id);
    });

    test('home timeline returns notes', () async {
      final notes = await client.notes.timelineHome(limit: 5);

      // 世界構築で e2e_alice のホームTLには投稿が存在する
      expect(notes, isNotEmpty);
      expect(notes.length, lessThanOrEqualTo(5));
      for (final note in notes) {
        expect(note.id, isNotEmpty);
        expect(note.user.username, isNotEmpty);
      }
    });
  });

  group('users', () {
    test('account.i returns the authenticated user', () async {
      final me = await client.account.i();
      expect(me.username, 'e2e_alice');
    });
  });
}
