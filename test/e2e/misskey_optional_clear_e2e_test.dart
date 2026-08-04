@Tags(['e2e'])
library;

import 'dart:convert';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import 'e2e_env.dart';

/// 1x1ピクセルのPNG(ドライブ操作用)
final List<int> pngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJ'
  'AAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

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

  group('channels/update', () {
    late String channelId;

    // /channels/create は1時間に10件までのレート制限があり、チャンネルには削除APIも
    // 無い。テストを繰り返し実行しても枯渇しないよう、専用チャンネルを使い回して
    // 各テストの前に状態を戻す
    const channelName = 'e2e optional clear';

    setUpAll(() async {
      // owned() はアーカイブ済みを返さないため、返ってきたものはそのまま使える。
      // 専用チャンネルが無ければ他の未アーカイブチャンネルを転用し、それも
      // 無ければ新規作成する(setUp で名前を揃えるので次回以降は名前で一致する)
      final owned = await client.channels.owned(limit: 100);
      final named = owned.where((c) => c.name == channelName).toList();
      final reusable = named.isNotEmpty ? named : owned;
      channelId = reusable.isNotEmpty
          ? reusable.first.id
          : (await client.channels.create(
              name: channelName,
              description: 'initial description',
            ))
              .id;
    });

    setUp(() async {
      await client.channels.update(
        channelId: channelId,
        name: channelName,
        description: const Optional('initial description'),
      );
    });

    test('omitting description keeps the current value', () async {
      final updated = await client.channels.update(
        channelId: channelId,
        name: 'renamed only',
      );
      expect(updated.name, 'renamed only');
      expect(updated.description, 'initial description');

      final shown = await client.channels.show(channelId: channelId);
      expect(shown.description, 'initial description');
    });

    test('Optional(value) sets the description', () async {
      final updated = await client.channels.update(
        channelId: channelId,
        description: const Optional('updated description'),
      );
      expect(updated.description, 'updated description');

      final shown = await client.channels.show(channelId: channelId);
      expect(shown.description, 'updated description');
    });

    test('Optional.null_() clears the description', () async {
      final updated = await client.channels.update(
        channelId: channelId,
        description: const Optional.null_(),
      );
      expect(updated.description, isNull);

      final shown = await client.channels.show(channelId: channelId);
      expect(shown.description, isNull);
    });

    test('Optional(value) sets the banner', () async {
      final file = await client.drive.files.create(
        bytes: pngBytes,
        filename: 'e2e-channel-banner.png',
      );
      final updated = await client.channels.update(
        channelId: channelId,
        bannerId: Optional(file.id),
      );
      expect(updated.bannerId, file.id);

      await client.drive.files.delete(fileId: file.id);
    });

    // /channels/update は `banner ? { bannerId: banner.id } : {}` で更新オブジェクトを
    // 組むため、明示的なnullが捨てられる(サーバー側の不具合)。単独で指定すると
    // 更新対象が空になりTypeORMが例外を投げて500、他フィールドと併用すると
    // 例外は出ないがバナーは消えない。ライブラリ側では制御できないため、
    // 現状の挙動をここで固定しておく
    test('clearing the banner alone fails with 500 (server-side bug)',
        () async {
      final file = await client.drive.files.create(
        bytes: pngBytes,
        filename: 'e2e-channel-banner.png',
      );
      await client.channels.update(
        channelId: channelId,
        bannerId: Optional(file.id),
      );

      await expectLater(
        client.channels.update(
          channelId: channelId,
          bannerId: const Optional.null_(),
        ),
        throwsA(isA<MisskeyServerException>()),
      );

      await client.drive.files.delete(fileId: file.id);
    });

    test('clearing the banner with another field silently does nothing '
        '(server-side bug)', () async {
      final file = await client.drive.files.create(
        bytes: pngBytes,
        filename: 'e2e-channel-banner.png',
      );
      await client.channels.update(
        channelId: channelId,
        bannerId: Optional(file.id),
      );

      final cleared = await client.channels.update(
        channelId: channelId,
        name: 'renamed with banner clear',
        bannerId: const Optional.null_(),
      );
      expect(cleared.name, 'renamed with banner clear');
      expect(cleared.bannerId, file.id);

      final shown = await client.channels.show(channelId: channelId);
      expect(shown.bannerId, file.id);

      await client.drive.files.delete(fileId: file.id);
    });
  });
}
