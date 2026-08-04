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
  late MisskeyClient admin;

  setUpAll(() {
    client = env.createMisskeyClient();
    admin = env.createMisskeyClient(admin: true);
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

  group('pages/update', () {
    late String pageId;

    // /pages/create も1時間に10件までのため、専用ページを使い回す
    const pageName = 'e2e-optional-clear';

    setUpAll(() async {
      final me = await client.account.i();
      try {
        final existing = await client.pages.showByName(
          name: pageName,
          username: me.username,
        );
        pageId = existing.id;
      } on MisskeyApiException catch (e) {
        if (e.code != 'NO_SUCH_PAGE') rethrow;
        final created = await client.pages.create(
          title: 'e2e optional clear',
          name: pageName,
          content: const <Map<String, dynamic>>[],
          variables: const <Map<String, dynamic>>[],
          script: '',
          summary: 'initial summary',
        );
        pageId = created.id;
      }
    });

    setUp(() async {
      await client.pages.update(
        pageId: pageId,
        summary: const Optional('initial summary'),
      );
    });

    test('omitting summary keeps the current value', () async {
      await client.pages.update(pageId: pageId, title: 'renamed only');

      final shown = await client.pages.showById(pageId: pageId);
      expect(shown.title, 'renamed only');
      expect(shown.summary, 'initial summary');
    });

    test('Optional(value) sets the summary', () async {
      await client.pages.update(
        pageId: pageId,
        summary: const Optional('updated summary'),
      );

      final shown = await client.pages.showById(pageId: pageId);
      expect(shown.summary, 'updated summary');
    });

    test('Optional.null_() clears the summary', () async {
      await client.pages.update(
        pageId: pageId,
        summary: const Optional.null_(),
      );

      final shown = await client.pages.showById(pageId: pageId);
      expect(shown.summary, isNull);
    });

    test('Optional.null_() clears the eye-catching image', () async {
      final file = await client.drive.files.create(
        bytes: pngBytes,
        filename: 'e2e-page-eyecatch.png',
      );
      await client.pages.update(
        pageId: pageId,
        eyeCatchingImageId: Optional(file.id),
      );
      final withImage = await client.pages.showById(pageId: pageId);
      expect(withImage.eyeCatchingImageId, file.id);

      await client.pages.update(
        pageId: pageId,
        eyeCatchingImageId: const Optional.null_(),
      );
      final cleared = await client.pages.showById(pageId: pageId);
      expect(cleared.eyeCatchingImageId, isNull);

      await client.drive.files.delete(fileId: file.id);
    });
  });

  group('admin/announcements/update', () {
    late String announcementId;

    Future<MisskeyAdminAnnouncement> fetch() async {
      final list = await admin.adminAnnouncements.list(limit: 100);
      return list.firstWhere((a) => a.id == announcementId);
    }

    setUp(() async {
      final created = await admin.adminAnnouncements.create(
        title: 'e2e optional clear',
        text: 'body',
        imageUrl: 'https://misskey.test/static-assets/icons/192.png',
      );
      announcementId = created.id;
    });

    tearDown(() async {
      await admin.adminAnnouncements.delete(id: announcementId);
    });

    // /admin/announcements/update はサーバー側が `ps.imageUrl || null` で評価する
    // ため、省略しても無変更にはならずクリアされる。ライブラリ側では制御できない
    // 仕様なので、その挙動をここで固定しておく
    test('omitting imageUrl clears it (server-side quirk)', () async {
      await admin.adminAnnouncements.update(
        id: announcementId,
        title: 'renamed only',
      );

      final shown = await fetch();
      expect(shown.title, 'renamed only');
      expect(shown.imageUrl, isNull);
    });

    test('an empty string is stored as null (server-side quirk)', () async {
      await admin.adminAnnouncements.update(
        id: announcementId,
        imageUrl: const Optional(''),
      );

      final shown = await fetch();
      expect(shown.imageUrl, isNull);
    });

    test('Optional(value) sets the imageUrl', () async {
      const url = 'https://misskey.test/static-assets/icons/512.png';
      await admin.adminAnnouncements.update(
        id: announcementId,
        imageUrl: const Optional(url),
      );

      final shown = await fetch();
      expect(shown.imageUrl, url);
    });

    test('Optional.null_() clears the imageUrl', () async {
      await admin.adminAnnouncements.update(
        id: announcementId,
        imageUrl: const Optional.null_(),
      );

      final shown = await fetch();
      expect(shown.imageUrl, isNull);
    });
  });

  group('admin/update-proxy-account', () {
    setUp(() async {
      await admin.admin.updateProxyAccount(
        description: const Optional('initial description'),
      );
    });

    test('omitting description keeps the current value', () async {
      final updated = await admin.admin.updateProxyAccount();
      expect(updated.description, 'initial description');
    });

    test('Optional(value) sets the description', () async {
      final updated = await admin.admin.updateProxyAccount(
        description: const Optional('updated description'),
      );
      expect(updated.description, 'updated description');
    });

    test('Optional.null_() clears the description', () async {
      final updated = await admin.admin.updateProxyAccount(
        description: const Optional.null_(),
      );
      expect(updated.description, isNull);

      // 永続化を別リクエストで確認する
      final reread = await admin.admin.updateProxyAccount();
      expect(reread.description, isNull);
    });
  });

  group('antennas/update', () {
    late String antennaId;
    late String userListId;

    setUpAll(() async {
      final list = await client.users.lists.create(name: 'e2e optional clear');
      userListId = list.id;
    });

    setUp(() async {
      final antenna = await client.antennas.create(
        name: 'e2e optional clear',
        src: 'list',
        userListId: userListId,
        keywords: const <List<String>>[
          <String>['e2e'],
        ],
        excludeKeywords: const <List<String>>[],
        users: const <String>[],
        caseSensitive: false,
        withReplies: false,
        withFile: false,
      );
      antennaId = antenna.id;
    });

    tearDown(() async {
      await client.antennas.delete(antennaId: antennaId);
    });

    tearDownAll(() async {
      await client.users.lists.delete(listId: userListId);
    });

    test('omitting userListId keeps the current value', () async {
      final updated = await client.antennas.update(
        antennaId: antennaId,
        name: 'renamed only',
      );
      expect(updated.name, 'renamed only');
      expect(updated.userListId, userListId);

      final shown = await client.antennas.show(antennaId: antennaId);
      expect(shown.userListId, userListId);
    });

    test('Optional.null_() clears the userListId', () async {
      final updated = await client.antennas.update(
        antennaId: antennaId,
        userListId: const Optional.null_(),
      );
      expect(updated.userListId, isNull);

      final shown = await client.antennas.show(antennaId: antennaId);
      expect(shown.userListId, isNull);
    });

    test('Optional(value) sets the userListId back', () async {
      await client.antennas.update(
        antennaId: antennaId,
        userListId: const Optional.null_(),
      );

      final updated = await client.antennas.update(
        antennaId: antennaId,
        userListId: Optional(userListId),
      );
      expect(updated.userListId, userListId);

      final shown = await client.antennas.show(antennaId: antennaId);
      expect(shown.userListId, userListId);
    });
  });
}
