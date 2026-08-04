@Tags(['e2e'])
library;

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import 'e2e_env.dart';

/// fediverse_e2e 環境(misskey.test)に対する、update系メソッドの
/// nullクリア(`Optional.null_()`)のE2Eテスト。
///
/// 各テストは以下の3状態を必ず検証する。
/// 1. 省略 → 無変更(サーバー側の値が保持される)
/// 2. `Optional(value)` → 値が設定される
/// 3. `Optional.null_()` → nullでクリアされ、再取得しても消えたまま
void main() {
  final env = E2eEnv.tryLoad();
  if (env == null) {
    test('misskey optional clear e2e', () {}, skip: E2eEnv.skipReason);
    return;
  }

  late MisskeyClient client;

  setUpAll(() {
    client = env.createMisskeyClient();
  });

  group('clips/update', () {
    late String clipId;

    setUp(() async {
      final clip = await client.clips.create(
        name: 'e2e clip ${DateTime.now().millisecondsSinceEpoch}',
        description: 'initial description',
      );
      clipId = clip.id;
    });

    tearDown(() async {
      await client.clips.delete(clipId: clipId);
    });

    // /clips/update はサーバー側が `ps.description || null` で評価するため、
    // 省略しても無変更にはならずクリアされる。ライブラリ側では制御できない
    // 仕様なので、その挙動をここで固定しておく
    test('omitting description clears it (server-side quirk)', () async {
      final updated = await client.clips.update(
        clipId: clipId,
        name: 'renamed only',
      );
      expect(updated.name, 'renamed only');
      expect(updated.description, isNull);

      final shown = await client.clips.show(clipId: clipId);
      expect(shown.description, isNull);
    });

    test('an empty string is stored as null (server-side quirk)', () async {
      final updated = await client.clips.update(
        clipId: clipId,
        description: const Optional(''),
      );
      expect(updated.description, isNull);
    });

    test('Optional(value) sets the description', () async {
      final updated = await client.clips.update(
        clipId: clipId,
        description: const Optional('updated description'),
      );
      expect(updated.description, 'updated description');

      final shown = await client.clips.show(clipId: clipId);
      expect(shown.description, 'updated description');
    });

    test('Optional.null_() clears the description', () async {
      final updated = await client.clips.update(
        clipId: clipId,
        description: const Optional.null_(),
      );
      expect(updated.description, isNull);

      // 永続化されていることを確認する(レスポンスだけでは判断しない)
      final shown = await client.clips.show(clipId: clipId);
      expect(shown.description, isNull);
    });
  });
}
