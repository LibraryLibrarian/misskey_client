@Tags(['e2e'])
library;

import 'dart:convert';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import 'e2e_env.dart';

/// 1x1ピクセルのPNG(ドライブ操作用)
final List<int> _pngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJ'
  'AAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

/// fediverse_e2e 環境(misskey.test)に対するAdmin API P3のE2Eテスト。
///
/// キューのclear/promoteや drive/cleanup 等の全体に影響する破壊的操作は、
/// 他のテストの前提を壊すため実行しない(呼び出し可能性のみ確認する)。
void main() {
  final env = E2eEnv.tryLoad();
  if (env == null) {
    test('misskey admin p3 e2e', () {}, skip: E2eEnv.skipReason);
    return;
  }

  late MisskeyClient admin;

  setUpAll(() {
    admin = env.createMisskeyClient(admin: true);
  });

  group('admin queue', () {
    test('stats returns counts including undocumented states', () async {
      final stats = await admin.adminQueue.stats();
      expect(stats.deliver, isNotNull);
      expect(stats.inbox, isNotNull);
      expect(stats.deliver!.completed, isNotNull);
      // ドキュメントに無いがサーバーが返すフィールド
      expect(stats.deliver!.paused, isNotNull);
      expect(stats.deliver!.prioritized, isNotNull);
      expect(stats.deliver!.waitingChildren, isNotNull);
    });

    test('queues lists all queues with metrics', () async {
      final queues = await admin.adminQueue.queues();
      expect(queues, isNotEmpty);
      expect(queues.map((q) => q.name), contains('deliver'));
      final deliver = queues.firstWhere((q) => q.name == 'deliver');
      expect(deliver.counts, isNotNull);
      expect(deliver.isPaused, isFalse);
      expect(deliver.completedMetrics, isNotNull);
    });

    test('queueStats returns redis info for a single queue', () async {
      final info = await admin.adminQueue.queueStats(queue: 'deliver');
      expect(info.name, 'deliver');
      expect(info.qualifiedName, isNotNull);
      expect(info.db, isNotNull);
      expect(info.db!['version'], isNotNull);
    });

    test('jobs and showJob return delivery jobs', () async {
      final jobs = await admin.adminQueue.jobs(
        queue: 'deliver',
        state: ['completed'],
      );
      expect(jobs, isNotEmpty);
      final job = jobs.first;
      expect(job.id, isNotEmpty);
      expect(job.isFailed, isFalse);
      // 成功ジョブでは failedReason がレスポンスに含まれない
      expect(job.failedReason, isNull);

      final shown = await admin.adminQueue.showJob(
        queue: 'deliver',
        jobId: job.id,
      );
      expect(shown.id, job.id);

      // 成功したdeliverジョブはログを残さないため、件数ではなく
      // 呼び出しがデシリアライズまで通ることを検証する
      await admin.adminQueue.showJobLogs(queue: 'deliver', jobId: job.id);
    });

    test('deliverDelayed and inboxDelayed return host/count tuples', () async {
      // 遅延キューは連合の状態次第で空になりうる。中身がある場合の
      // [host, count] タプル構造のみを固定する
      for (final entry in await admin.adminQueue.deliverDelayed()) {
        expect(entry.host, isNotEmpty);
        expect(entry.count, isNonNegative);
      }
      for (final entry in await admin.adminQueue.inboxDelayed()) {
        expect(entry.host, isNotEmpty);
        expect(entry.count, isNonNegative);
      }
    });
  });

  group('admin drive', () {
    test('files and showFile return moderation views', () async {
      final alice = env.createMisskeyClient();
      final uploaded = await alice.drive.files.create(
        bytes: _pngBytes,
        filename: 'e2e_p3_${DateTime.now().millisecondsSinceEpoch}.png',
        force: true,
      );
      addTearDown(() => alice.drive.files.delete(fileId: uploaded.id));

      final files = await admin.adminDrive.files(limit: 100, origin: 'local');
      expect(files.map((f) => f.id), contains(uploaded.id));

      final shown = await admin.adminDrive.showFile(fileId: uploaded.id);
      expect(shown['id'], uploaded.id);
      // admin専用のモデレーション向けフィールド
      expect(shown.containsKey('requestIp'), isTrue);
    });
  });

  group('admin ad', () {
    test('create -> list -> update -> delete round trip', () async {
      final now = DateTime.now();
      final memo = 'e2e ad ${now.millisecondsSinceEpoch}';
      final ad = await admin.adminAd.create(
        url: 'https://example.test/ad',
        memo: memo,
        place: 'square',
        priority: 'middle',
        ratio: 1,
        startsAt: now.millisecondsSinceEpoch,
        expiresAt: now.add(const Duration(days: 1)).millisecondsSinceEpoch,
        imageUrl: 'https://example.test/ad.png',
        dayOfWeek: 0,
      );
      expect(ad.memo, memo);
      expect(ad.place, 'square');
      expect(ad.startsAt, isA<DateTime>());

      final listed = await admin.adminAd.list(limit: 100);
      expect(listed.map((a) => a.id), contains(ad.id));

      await admin.adminAd.update(id: ad.id, memo: '$memo updated');
      final afterUpdate = await admin.adminAd.list(limit: 100);
      expect(
        afterUpdate.firstWhere((a) => a.id == ad.id).memo,
        '$memo updated',
      );

      await admin.adminAd.delete(id: ad.id);
      final afterDelete = await admin.adminAd.list(limit: 100);
      expect(afterDelete.map((a) => a.id), isNot(contains(ad.id)));
    });
  });

  group('admin avatar decorations', () {
    test('create -> list -> update -> delete round trip', () async {
      final name = 'e2e-deco-${DateTime.now().millisecondsSinceEpoch}';
      final created = await admin.adminAvatarDecorations.create(
        name: name,
        description: 'created by e2e',
        url: 'https://example.test/deco.png',
      );
      expect(created.name, name);

      final listed = await admin.adminAvatarDecorations.list(limit: 100);
      expect(listed.map((d) => d.id), contains(created.id));

      await admin.adminAvatarDecorations.update(
        id: created.id,
        description: 'updated by e2e',
      );
      final afterUpdate = await admin.adminAvatarDecorations.list(limit: 100);
      expect(
        afterUpdate.firstWhere((d) => d.id == created.id).description,
        'updated by e2e',
      );

      await admin.adminAvatarDecorations.delete(id: created.id);
    });
  });

  group('admin system webhook', () {
    test('create -> show -> list -> update -> test -> delete', () async {
      final name = 'e2e-hook-${DateTime.now().millisecondsSinceEpoch}';
      final created = await admin.adminSystemWebhook.create(
        isActive: true,
        name: name,
        on: ['abuseReport'],
        url: 'https://example.test/hook',
      );
      expect(created.name, name);
      expect(created.on, ['abuseReport']);

      final shown = await admin.adminSystemWebhook.show(id: created.id);
      expect(shown.id, created.id);

      final listed = await admin.adminSystemWebhook.list();
      expect(listed.map((w) => w.id), contains(created.id));

      final updated = await admin.adminSystemWebhook.update(
        id: created.id,
        isActive: false,
        name: name,
        on: ['abuseReport', 'userCreated'],
        url: 'https://example.test/hook2',
      );
      expect(updated.isActive, isFalse);
      expect(updated.on, hasLength(2));

      // 配送先は実在しないが、キュー投入まで成功すればよい
      await admin.adminSystemWebhook.test(
        webhookId: created.id,
        type: 'abuseReport',
      );

      await admin.adminSystemWebhook.delete(id: created.id);
    });
  });

  group('admin captcha', () {
    test('current returns provider settings', () async {
      final captcha = await admin.adminCaptcha.current();
      expect(captcha.provider, 'none');
      expect(captcha.hcaptcha, isNotNull);
      expect(captcha.mcaptcha, isNotNull);
      expect(captcha.hcaptcha!.siteKey, isNull);
    });
  });

  group('admin misc', () {
    test('showModerationLogs returns recent actions', () async {
      final logs = await admin.admin.showModerationLogs(limit: 10);
      expect(logs, isNotEmpty);
      final log = logs.first;
      expect(log.id, isNotEmpty);
      expect(log.type, isNotEmpty);
      expect(log.user, isNotNull);
      expect(log.createdAt, isA<DateTime>());
    });

    test('getUserIps returns records (empty when IP logging is off)', () async {
      final users = await admin.admin.showUsers(
        origin: 'local',
        username: 'e2e_alice',
      );
      final alice = users.singleWhere((u) => u.username == 'e2e_alice');
      // seedはenableIpLoggingを有効にしていないため常に空になる
      expect(await admin.admin.getUserIps(userId: alice.id), isEmpty);
    });

    test('getIndexStats returns full index definitions', () async {
      final stats = await admin.admin.getIndexStats();
      expect(stats, isNotEmpty);
      final stat = stats.first;
      expect(stat.tablename, isNotEmpty);
      expect(stat.indexname, isNotEmpty);
      // ドキュメントに無いがサーバーが返すフィールド
      expect(stat.schemaname, isNotNull);
      expect(stat.indexdef, isNotNull);
    });

    test('getTableStats returns per-table counts and sizes', () async {
      final stats = await admin.admin.getTableStats();
      expect(stats, isNotEmpty);
      expect(stats.containsKey('user'), isTrue);
      expect(stats['user']!.size, isPositive);
    });

    test('unsetUserAvatar and unsetUserBanner are callable', () async {
      final username = 'e2e_av${DateTime.now().millisecondsSinceEpoch}';
      final created = await admin.adminAccounts.create(
        username: username,
        password: 'e2e-temp-pass',
      );
      addTearDown(() => admin.adminAccounts.delete(userId: created.user.id));

      await admin.admin.unsetUserAvatar(userId: created.user.id);
      await admin.admin.unsetUserBanner(userId: created.user.id);
    });

    test('updateProxyAccount updates the instance actor', () async {
      final marker = 'e2e proxy ${DateTime.now().millisecondsSinceEpoch}';
      final proxy = await admin.admin.updateProxyAccount(
        description: marker,
      );
      expect(proxy.description, marker);
    });

    test('createPromo pins a note', () async {
      final alice = env.createMisskeyClient();
      final note = await alice.notes.create(text: 'e2e promo target');
      addTearDown(() async {
        try {
          await alice.notes.delete(noteId: note.id);
        } on MisskeyRateLimitException {
          // 使い捨て環境のためレート制限による削除失敗は許容する
        }
      });

      await admin.admin.createPromo(
        noteId: note.id,
        expiresAt:
            DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch,
      );

      // 同じノートの二重登録はサーバーが拒否する
      await expectLater(
        admin.admin.createPromo(
          noteId: note.id,
          expiresAt: DateTime.now()
              .add(const Duration(days: 1))
              .millisecondsSinceEpoch,
        ),
        throwsA(isA<MisskeyApiException>()),
      );
    });
  });
}
