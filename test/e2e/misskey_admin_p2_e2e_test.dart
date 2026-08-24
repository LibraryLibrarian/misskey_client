@Tags(['e2e'])
library;

import 'dart:convert';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import 'e2e_env.dart';

/// 1x1ピクセルのPNG(絵文字アップロード用)
final List<int> _pngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJ'
  'AAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

/// fediverse_e2e 環境(misskey.test)に対するAdmin API P2のE2Eテスト。
///
/// 連合を破壊する操作(remove-all-following等)は既存のフォロー関係を
/// 壊すため実行しない。
void main() {
  final env = E2eEnv.tryLoad();
  if (env == null) {
    test('misskey admin p2 e2e', () {}, skip: E2eEnv.skipReason);
    return;
  }

  late MisskeyClient admin;

  setUpAll(() {
    admin = env.createMisskeyClient(admin: true);
  });

  group('admin emoji', () {
    test('listV2 returns a consistent read-only page', () async {
      final result = await admin.adminEmoji.listV2(
        query: const MisskeyAdminEmojiListQuery(hostType: 'all'),
        limit: 10,
        page: 1,
        sortKeys: const ['-id'],
      );

      expect(result.emojis, hasLength(result.count));
      expect(result.count, lessThanOrEqualTo(10));
      expect(result.allCount, greaterThanOrEqualTo(result.count));
      expect(result.allPages, greaterThanOrEqualTo(0));
    });

    test('add -> list -> update -> bulk ops -> delete round trip', () async {
      final suffix = DateTime.now().millisecondsSinceEpoch;
      final name = 'e2e_emoji_$suffix';

      // ドライブへ画像をアップロードして絵文字として登録する
      final file = await admin.drive.files.create(
        bytes: _pngBytes,
        filename: 'e2e_emoji_$suffix.png',
        force: true,
      );
      addTearDown(() => admin.drive.files.delete(fileId: file.id));

      final emoji = await admin.adminEmoji.add(
        name: name,
        fileId: file.id,
        aliases: ['e2e_alias'],
      );
      expect(emoji.name, name);
      expect(emoji.aliases, contains('e2e_alias'));

      final listed = await admin.adminEmoji.list(query: name);
      expect(listed.map((e) => e.id), contains(emoji.id));

      await admin.adminEmoji.update(
        id: emoji.id,
        category: const Optional('e2e-category'),
      );
      final updated = await admin.adminEmoji.list(query: name);
      expect(updated.single.category, 'e2e-category');

      await admin.adminEmoji.addAliasesBulk(
        ids: [emoji.id],
        aliases: ['bulk_alias'],
      );
      await admin.adminEmoji.setLicenseBulk(ids: [emoji.id], license: 'CC0');
      final afterBulk = await admin.adminEmoji.list(query: name);
      expect(afterBulk.single.aliases, contains('bulk_alias'));
      expect(afterBulk.single.license, 'CC0');

      // set-aliases-bulk は add と違い、エイリアスを置き換える
      await admin.adminEmoji.setAliasesBulk(
        ids: [emoji.id],
        aliases: ['replaced_alias'],
      );
      final afterSetAliases = await admin.adminEmoji.list(query: name);
      expect(afterSetAliases.single.aliases, ['replaced_alias']);

      await admin.adminEmoji.setCategoryBulk(ids: [emoji.id]);
      await admin.adminEmoji.removeAliasesBulk(
        ids: [emoji.id],
        aliases: ['replaced_alias'],
      );

      await admin.adminEmoji.delete(id: emoji.id);
      final afterDelete = await admin.adminEmoji.list(query: name);
      expect(afterDelete, isEmpty);
    });

    test('listRemote is callable', () async {
      // 連合先の絵文字はキャッシュ状況に依存するため limit の遵守のみ固定する
      final remote = await admin.adminEmoji.listRemote(limit: 10);
      expect(remote.length, lessThanOrEqualTo(10));
    });

    test('copy creates a local emoji and removes it afterwards', () async {
      final remote = await admin.adminEmoji.listRemote(limit: 100);
      final candidates = remote.where((emoji) => emoji.host != null);
      if (candidates.isEmpty) {
        markTestSkipped(
          'The E2E server has no cached remote emoji; copy requires a '
          'pre-cached federated emoji.',
        );
        return;
      }
      EmojiDetailed? target;
      var exactLocalIdsBefore = <String>{};
      for (final candidate in candidates) {
        final exactLocalBefore = (await admin.adminEmoji.list(
          query: candidate.name,
          limit: 100,
        )).where((emoji) => emoji.host == null && emoji.name == candidate.name);
        final ids = exactLocalBefore.map((emoji) => emoji.id).toSet();
        if (ids.isEmpty) {
          target = candidate;
          exactLocalIdsBefore = ids;
          break;
        }
      }
      if (target == null) {
        markTestSkipped(
          'Every cached remote emoji has a conflicting local name; copy '
          'requires a non-conflicting remote emoji.',
        );
        return;
      }
      final copyTarget = target;

      String? copiedId;
      try {
        copiedId = await admin.adminEmoji.copy(emojiId: copyTarget.id);
        final copied = await admin.adminEmoji.list(
          query: copyTarget.name,
          limit: 100,
        );
        expect(copied.map((emoji) => emoji.id), contains(copiedId));
        expect(
          copied.singleWhere((emoji) => emoji.id == copiedId).host,
          isNull,
        );
      } finally {
        // 応答受信前にcopyが成功した場合も、事前に無かった同名local emojiを回収する。
        final cleanupCandidates = await admin.adminEmoji.list(
          query: copyTarget.name,
          limit: 100,
        );
        for (final emoji in cleanupCandidates) {
          final isNewExactLocal =
              emoji.host == null &&
              emoji.name == copyTarget.name &&
              !exactLocalIdsBefore.contains(emoji.id);
          final isKnownCopy = copiedId == null || emoji.id == copiedId;
          if (isNewExactLocal && isKnownCopy) {
            await admin.adminEmoji.delete(id: emoji.id);
          }
        }
      }

      final localAfter = await admin.adminEmoji.list(
        query: copyTarget.name,
        limit: 100,
      );
      expect(
        localAfter.where(
          (emoji) =>
              emoji.host == null &&
              emoji.name == copyTarget.name &&
              !exactLocalIdsBefore.contains(emoji.id),
        ),
        isEmpty,
      );
    });
  });

  group('admin announcements', () {
    test('create -> list -> update -> delete round trip', () async {
      final marker = 'e2e-ann-${DateTime.now().millisecondsSinceEpoch}';
      final created = await admin.adminAnnouncements.create(
        title: marker,
        text: 'announcement from e2e',
      );
      expect(created.title, marker);

      final listed = await admin.adminAnnouncements.list(limit: 100);
      expect(listed.map((a) => a.id), contains(created.id));

      await admin.adminAnnouncements.update(
        id: created.id,
        text: 'updated by e2e',
        isActive: false,
      );
      final archived = await admin.adminAnnouncements.list(
        limit: 100,
        status: 'archived',
      );
      expect(
        archived.singleWhere((a) => a.id == created.id).text,
        'updated by e2e',
      );

      await admin.adminAnnouncements.delete(id: created.id);
    });
  });

  group('admin abuse reports', () {
    test('report -> list -> update -> resolve round trip', () async {
      // 使い捨てユーザーを作り、alice(一般ユーザー)から通報する
      final username = 'e2e_ab${DateTime.now().millisecondsSinceEpoch}';
      final target = await admin.adminAccounts.create(
        username: username,
        password: 'e2e-temp-pass',
      );
      addTearDown(() => admin.adminAccounts.delete(userId: target.user.id));

      final alice = env.createMisskeyClient();
      final marker =
          'e2e abuse report ${DateTime.now().millisecondsSinceEpoch}';
      await alice.users.reportAbuse(userId: target.user.id, comment: marker);

      final reports = await admin.adminAbuseReports.list(state: 'unresolved');
      final report = reports.singleWhere((r) => r.comment == marker);
      expect(report.resolved, isFalse);
      expect(report.targetUserId, target.user.id);

      await admin.adminAbuseReports.update(
        reportId: report.id,
        moderationNote: 'checked by e2e',
      );
      await admin.adminAbuseReports.resolve(
        reportId: report.id,
        resolvedAs: 'accept',
      );

      final resolved = await admin.adminAbuseReports.list(state: 'resolved');
      final after = resolved.singleWhere((r) => r.id == report.id);
      expect(after.resolved, isTrue);
      expect(after.moderationNote, 'checked by e2e');
    });

    test('notification recipient email method requires an address', () async {
      // emailメソッドは対象ユーザーにメールアドレスが必要。
      // E2E環境のadminは未設定のため、サーバーがエラーを返すことを検証する
      final me = await admin.account.i();
      await expectLater(
        admin.adminAbuseReports.createNotificationRecipient(
          isActive: true,
          name: 'e2e-rcpt',
          method: 'email',
          userId: me.id,
        ),
        throwsA(
          isA<MisskeyApiException>().having(
            (e) => e.code,
            'code',
            'EMAIL_ADDRESS_NOT_SET',
          ),
        ),
      );
    });

    test(
      'notification recipient create -> show -> list -> update -> delete',
      () async {
        // webhookメソッドならメールアドレス設定なしでCRUDを一巡できる
        final hookName =
            'e2e-rcpt-hook-${DateTime.now().millisecondsSinceEpoch}';
        final webhook = await admin.adminSystemWebhook.create(
          isActive: true,
          name: hookName,
          on: ['abuseReport'],
          url: 'https://example.test/abuse-hook',
        );
        addTearDown(() => admin.adminSystemWebhook.delete(id: webhook.id));

        final name = 'e2e-rcpt-${DateTime.now().millisecondsSinceEpoch}';
        final created = await admin.adminAbuseReports
            .createNotificationRecipient(
              isActive: true,
              name: name,
              method: 'webhook',
              systemWebhookId: webhook.id,
            );
        expect(created.name, name);
        expect(created.method, 'webhook');

        final shown = await admin.adminAbuseReports.showNotificationRecipient(
          id: created.id,
        );
        expect(shown.id, created.id);
        expect(shown.systemWebhookId, webhook.id);

        final listed = await admin.adminAbuseReports
            .listNotificationRecipients();
        expect(listed.map((r) => r.id), contains(created.id));

        final updated = await admin.adminAbuseReports
            .updateNotificationRecipient(
              id: created.id,
              isActive: false,
              name: '$name updated',
              method: 'webhook',
              systemWebhookId: webhook.id,
            );
        expect(updated.isActive, isFalse);
        expect(updated.name, '$name updated');

        await admin.adminAbuseReports.deleteNotificationRecipient(
          id: created.id,
        );
        final afterDelete = await admin.adminAbuseReports
            .listNotificationRecipients();
        expect(afterDelete.map((r) => r.id), isNot(contains(created.id)));
      },
    );
  });

  group('admin federation', () {
    test('refreshRemoteInstanceMetadata and updateInstance', () async {
      await admin.adminFederation.refreshRemoteInstanceMetadata(
        host: 'mastodon.test',
      );
      // 注意: このエンドポイントは「変更が発生しない更新」に対して
      // INTERNAL_ERROR(500)を返すため、必ず値を変化させる
      final marker = 'e2e note ${DateTime.now().millisecondsSinceEpoch}';
      await admin.adminFederation.updateInstance(
        host: 'mastodon.test',
        moderationNote: marker,
      );
      // 一時的に配送停止し、すぐ解除する(両方とも状態変化のある更新)
      await admin.adminFederation.updateInstance(
        host: 'mastodon.test',
        isSuspended: true,
      );
      await admin.adminFederation.updateInstance(
        host: 'mastodon.test',
        isSuspended: false,
      );
    });
  });

  group('admin relays', () {
    test('add -> list -> remove round trip', () async {
      // 実在しない閉域ドメインのリレー(購読はrequestingのまま進まない)
      const inbox = 'https://relay.example.test/inbox';
      final relay = await admin.adminRelays.add(inbox: inbox);
      expect(relay.inbox, inbox);
      expect(relay.status, MisskeyRelayStatus.requesting);

      final listed = await admin.adminRelays.list();
      expect(listed.map((r) => r.inbox), contains(inbox));

      await admin.adminRelays.remove(inbox: inbox);
      final afterRemove = await admin.adminRelays.list();
      expect(afterRemove.map((r) => r.inbox), isNot(contains(inbox)));
    });
  });
}
