import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/admin/misskey_queue.dart';

/// Provides job queue management admin APIs (`/api/admin/queue/*`).
///
/// All endpoints require administrator privileges.
///
/// The `queue` parameter accepts one of `system`, `endedPollNotification`,
/// `postScheduledNote`, `deliver`, `inbox`, `db`, `relationship`,
/// `objectStorage`, `userWebhookDeliver`, or `systemWebhookDeliver`.
class AdminQueueApi {
  const AdminQueueApi({required this.http});

  final MisskeyHttp http;

  /// Fetches aggregated job counts for the main queues
  /// (`/api/admin/queue/stats`).
  Future<MisskeyQueueStats> stats() async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/queue/stats',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyQueueStats.fromJson(res);
  }

  /// Fetches the list of queues with their counts and metrics
  /// (`/api/admin/queue/queues`).
  Future<List<MisskeyQueueInfo>> queues() async {
    final res = await http.send<List<dynamic>>(
      '/admin/queue/queues',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyQueueInfo.fromJson)
        .toList();
  }

  /// Fetches detailed statistics for a single queue
  /// (`/api/admin/queue/queue-stats`).
  ///
  /// The result additionally includes Redis server information in `db`.
  Future<MisskeyQueueInfo> queueStats({required String queue}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/queue/queue-stats',
      body: <String, dynamic>{'queue': queue},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyQueueInfo.fromJson(res);
  }

  /// Fetches jobs in a queue (`/api/admin/queue/jobs`).
  ///
  /// [state] accepts job states such as `wait`, `active`, `completed`,
  /// `failed`, `delayed`, `paused`, and `prioritized`. Use [search] to
  /// filter jobs by keyword.
  Future<List<MisskeyQueueJob>> jobs({
    required String queue,
    required List<String> state,
    String? search,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/queue/jobs',
      body: <String, dynamic>{
        'queue': queue,
        'state': state,
        'search': ?search,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyQueueJob.fromJson)
        .toList();
  }

  /// Fetches a single job (`/api/admin/queue/show-job`).
  Future<MisskeyQueueJob> showJob({
    required String queue,
    required String jobId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/queue/show-job',
      body: <String, dynamic>{'queue': queue, 'jobId': jobId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyQueueJob.fromJson(res);
  }

  /// Fetches the logs of a single job (`/api/admin/queue/show-job-logs`).
  Future<List<String>> showJobLogs({
    required String queue,
    required String jobId,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/queue/show-job-logs',
      body: <String, dynamic>{'queue': queue, 'jobId': jobId},
      options: const RequestOptions(idempotent: true),
    );
    return res.whereType<String>().toList();
  }

  /// Retries a failed job (`/api/admin/queue/retry-job`).
  Future<void> retryJob({required String queue, required String jobId}) =>
      http.send<Object?>(
        '/admin/queue/retry-job',
        body: <String, dynamic>{'queue': queue, 'jobId': jobId},
      );

  /// Removes a job from a queue (`/api/admin/queue/remove-job`).
  Future<void> removeJob({required String queue, required String jobId}) =>
      http.send<Object?>(
        '/admin/queue/remove-job',
        body: <String, dynamic>{'queue': queue, 'jobId': jobId},
      );

  /// Promotes delayed jobs so they run immediately
  /// (`/api/admin/queue/promote-jobs`).
  Future<void> promoteJobs({required String queue}) => http.send<Object?>(
    '/admin/queue/promote-jobs',
    body: <String, dynamic>{'queue': queue},
  );

  /// Clears jobs in a queue (`/api/admin/queue/clear`).
  ///
  /// [state] accepts `*` (all states) or a specific state such as
  /// `completed`, `wait`, `active`, `paused`, `prioritized`, `delayed`,
  /// or `failed`.
  Future<void> clear({required String queue, required String state}) =>
      http.send<Object?>(
        '/admin/queue/clear',
        body: <String, dynamic>{'queue': queue, 'state': state},
      );

  /// Fetches per-host delayed counts for the delivery queue
  /// (`/api/admin/queue/deliver-delayed`).
  Future<List<MisskeyDelayedQueueEntry>> deliverDelayed() async {
    final res = await http.send<List<dynamic>>(
      '/admin/queue/deliver-delayed',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<List<dynamic>>()
        .map(MisskeyDelayedQueueEntry.fromJson)
        .toList();
  }

  /// Fetches per-host delayed counts for the inbox queue
  /// (`/api/admin/queue/inbox-delayed`).
  Future<List<MisskeyDelayedQueueEntry>> inboxDelayed() async {
    final res = await http.send<List<dynamic>>(
      '/admin/queue/inbox-delayed',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<List<dynamic>>()
        .map(MisskeyDelayedQueueEntry.fromJson)
        .toList();
  }
}
