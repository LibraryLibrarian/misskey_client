import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

dynamic _load(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync());

void main() {
  group('MisskeyQueueStats.fromJson', () {
    test('deserializes counts for each queue', () {
      final stats = MisskeyQueueStats.fromJson(
        _load('admin_queue_stats.json') as Map<String, dynamic>,
      );

      expect(stats.deliver, isNotNull);
      expect(stats.inbox, isNotNull);
      expect(stats.db, isNotNull);
      expect(stats.objectStorage, isNotNull);
      expect(stats.deliver!.completed, isNonNegative);
    });

    test('maps the undocumented waiting-children field', () {
      // OpenAPIのQueueCountには無いが、サーバーは
      // paused / prioritized / waiting-children も返す
      final stats = MisskeyQueueStats.fromJson(
        _load('admin_queue_stats.json') as Map<String, dynamic>,
      );

      expect(stats.deliver!.paused, isNotNull);
      expect(stats.deliver!.prioritized, isNotNull);
      expect(stats.deliver!.waitingChildren, isNotNull);
    });
  });

  group('MisskeyQueueInfo.fromJson', () {
    test('flattens metrics into completed/failed', () {
      final list = _load('admin_queue_queues.json') as List<dynamic>;
      final queues = list
          .whereType<Map<String, dynamic>>()
          .map(MisskeyQueueInfo.fromJson)
          .toList();

      expect(queues, isNotEmpty);
      final queue = queues.first;
      expect(queue.name, isNotEmpty);
      expect(queue.counts, isNotNull);
      expect(queue.isPaused, isFalse);
      expect(queue.completedMetrics, isNotNull);
      expect(queue.completedMetrics!.data, isNotEmpty);
      expect(queue.failedMetrics, isNotNull);
      // queues では db は返らない
      expect(queue.db, isNull);
    });

    test('queue-stats response includes redis info in db', () {
      final info = MisskeyQueueInfo.fromJson(
        _load('admin_queue_queue_stats.json') as Map<String, dynamic>,
      );

      expect(info.name, 'deliver');
      expect(info.qualifiedName, isNotNull);
      expect(info.db, isNotNull);
      expect(info.db!['version'], isNotNull);
    });
  });

  group('MisskeyQueueJob.fromJson', () {
    test('handles types that differ from the documentation', () {
      final job = MisskeyQueueJob.fromJson(
        _load('admin_queue_job.json') as Map<String, dynamic>,
      );

      expect(job.id, isNotEmpty);
      expect(job.name, isNotEmpty);
      expect(job.isFailed, isFalse);
      // ドキュメントでは必須だが、成功ジョブでは省略される
      expect(job.failedReason, isNull);
      // ドキュメントは object だが実際は数値/文字列が返る
      expect(job.progress, isA<num>());
      expect(job.returnValue, isA<String>());
    });
  });

  group('MisskeyCaptchaSettings.fromJson', () {
    test('deserializes provider keys', () {
      final captcha = MisskeyCaptchaSettings.fromJson(
        _load('admin_captcha_current.json') as Map<String, dynamic>,
      );

      expect(captcha.provider, 'none');
      expect(captcha.hcaptcha!.siteKey, isNull);
      expect(captcha.mcaptcha!.instanceUrl, isNull);
      expect(captcha.turnstile, isNotNull);
    });
  });

  group('MisskeyModerationLog.fromJson', () {
    test('deserializes log entries with a typed user', () {
      final list = _load('admin_moderation_logs.json') as List<dynamic>;
      final logs = list
          .whereType<Map<String, dynamic>>()
          .map(MisskeyModerationLog.fromJson)
          .toList();

      expect(logs, isNotEmpty);
      final log = logs.first;
      expect(log.id, isNotEmpty);
      expect(log.type, isNotEmpty);
      expect(log.info, isNotNull);
      expect(log.user!.username, isNotEmpty);
      expect(log.createdAt, isA<DateTime>());
    });
  });

  group('MisskeyIndexStat.fromJson', () {
    test('includes fields missing from the documentation', () {
      final list = _load('admin_index_stats.json') as List<dynamic>;
      final stats = list
          .whereType<Map<String, dynamic>>()
          .map(MisskeyIndexStat.fromJson)
          .toList();

      expect(stats, isNotEmpty);
      final stat = stats.first;
      expect(stat.tablename, isNotEmpty);
      expect(stat.indexname, isNotEmpty);
      // OpenAPIには無いフィールド
      expect(stat.schemaname, isNotEmpty);
      expect(stat.indexdef, contains('CREATE'));
    });
  });

  group('MisskeyTableStat.fromJson', () {
    test('deserializes count and size per table', () {
      final map = _load('admin_table_stats.json') as Map<String, dynamic>;
      final stats = map.map(
        (key, value) => MapEntry(
          key,
          MisskeyTableStat.fromJson(value as Map<String, dynamic>),
        ),
      );

      expect(stats, isNotEmpty);
      final first = stats.values.first;
      expect(first.size, isPositive);
      expect(first.count, isA<num>());
    });
  });

  group('MisskeyDelayedQueueEntry.fromJson', () {
    test('parses the [host, count] tuple', () {
      final entry = MisskeyDelayedQueueEntry.fromJson(<dynamic>[
        'example.test',
        12,
      ]);
      expect(entry.host, 'example.test');
      expect(entry.count, 12);
    });
  });
}
