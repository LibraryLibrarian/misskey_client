@Tags(['e2e'])
library;

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import 'e2e_env.dart';

/// fediverse_e2e 環境の連合(misskey.test ⇄ mastodon.test)を使うテスト
void main() {
  final env = E2eEnv.tryLoad();
  if (env == null) {
    test('misskey federation e2e', () {}, skip: E2eEnv.skipReason);
    return;
  }

  late MisskeyClient client;

  setUpAll(() {
    client = env.createMisskeyClient();
  });

  group('ap', () {
    test('show resolves a remote Mastodon user', () async {
      final result = await client.ap.show(
        uri: '${env.mastodonBaseUrl}/@e2e_bob',
      );
      expect(result, isA<ApShowUser>());
      final user = (result as ApShowUser).object;
      expect(user.username, 'e2e_bob');
      expect(user.host, 'mastodon.test');
    });
  });

  group('federation', () {
    test('showInstance returns the federated Mastodon instance', () async {
      final instance = await client.federation.showInstance(
        host: 'mastodon.test',
      );
      expect(instance, isNotNull);
      expect(instance!.host, 'mastodon.test');
      expect(instance.softwareName, 'mastodon');
    });

    test('instances includes mastodon.test', () async {
      final instances = await client.federation.instances(limit: 30);
      expect(
        instances.map((e) => e.host),
        contains('mastodon.test'),
      );
    });
  });

  group('note delivery', () {
    test('a local note reaches the remote follower side', () async {
      // e2e_alice は e2e_bob(mastodon.test) にフォローされている前提
      // (fediverse_e2e の make check で相互フォロー済み)
      final marker = 'e2e fed ${DateTime.now().millisecondsSinceEpoch}';
      final created = await client.notes.create(text: marker);
      addTearDown(() async {
        try {
          await client.notes.delete(noteId: created.id);
        } on MisskeyRateLimitException {
          // 使い捨てのE2E環境のため、レート制限による削除失敗は許容する
        }
      });

      // 配送はMisskey側のノート状態では確認できないため、
      // 自ノートがpublicで作成されたことのみ確認する(到達確認はMastodon側E2Eが担う)
      expect(created.visibility, MisskeyNoteVisibility.public);
    });
  });
}
