import 'package:json_annotation/json_annotation.dart';

part 'misskey_queue.g.dart';

/// Job counts per state for a queue.
///
/// Note: the API documentation only lists `waiting`, `active`, `completed`,
/// `failed`, and `delayed`, but Misskey 2026.5.1 additionally returns
/// `paused`, `prioritized`, and `waiting-children`.
@JsonSerializable()
class MisskeyQueueCount {
  const MisskeyQueueCount({
    this.waiting,
    this.active,
    this.completed,
    this.failed,
    this.delayed,
    this.paused,
    this.prioritized,
    this.waitingChildren,
  });

  factory MisskeyQueueCount.fromJson(Map<String, dynamic> json) =>
      _$MisskeyQueueCountFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyQueueCountToJson(this);

  /// The number of jobs waiting to be processed.
  final num? waiting;

  /// The number of jobs currently being processed.
  final num? active;

  /// The number of completed jobs.
  final num? completed;

  /// The number of failed jobs.
  final num? failed;

  /// The number of delayed jobs.
  final num? delayed;

  /// The number of paused jobs.
  final num? paused;

  /// The number of prioritized jobs.
  final num? prioritized;

  /// The number of jobs waiting for their child jobs.
  @JsonKey(name: 'waiting-children')
  final num? waitingChildren;
}

/// Aggregated job counts returned by `/api/admin/queue/stats`.
@JsonSerializable()
class MisskeyQueueStats {
  const MisskeyQueueStats({
    this.deliver,
    this.inbox,
    this.db,
    this.objectStorage,
    this.userWebhookDeliver,
    this.systemWebhookDeliver,
  });

  factory MisskeyQueueStats.fromJson(Map<String, dynamic> json) =>
      _$MisskeyQueueStatsFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyQueueStatsToJson(this);

  /// Counts for the ActivityPub delivery queue.
  final MisskeyQueueCount? deliver;

  /// Counts for the ActivityPub inbox queue.
  final MisskeyQueueCount? inbox;

  /// Counts for the database queue.
  final MisskeyQueueCount? db;

  /// Counts for the object storage queue.
  final MisskeyQueueCount? objectStorage;

  /// Counts for the user webhook delivery queue.
  final MisskeyQueueCount? userWebhookDeliver;

  /// Counts for the system webhook delivery queue.
  final MisskeyQueueCount? systemWebhookDeliver;
}

/// Throughput metrics for a queue.
@JsonSerializable()
class MisskeyQueueMetrics {
  const MisskeyQueueMetrics({this.meta, this.data, this.count});

  factory MisskeyQueueMetrics.fromJson(Map<String, dynamic> json) =>
      _$MisskeyQueueMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyQueueMetricsToJson(this);

  /// Metadata about the sampling window (`count`, `prevTS`, `prevCount`).
  final Map<String, dynamic>? meta;

  /// The per-minute sample values.
  final List<num>? data;

  /// The total count.
  final num? count;
}

/// A queue summary returned by `/api/admin/queue/queues`.
@JsonSerializable()
class MisskeyQueueInfo {
  const MisskeyQueueInfo({
    required this.name,
    this.qualifiedName,
    this.counts,
    this.isPaused,
    this.completedMetrics,
    this.failedMetrics,
    this.db,
  });

  /// Creates an instance from the raw response JSON.
  ///
  /// `metrics` is flattened into [completedMetrics] and [failedMetrics].
  factory MisskeyQueueInfo.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] as Map<String, dynamic>?;
    return MisskeyQueueInfo(
      name: json['name'] as String,
      qualifiedName: json['qualifiedName'] as String?,
      counts: json['counts'] == null
          ? null
          : MisskeyQueueCount.fromJson(json['counts'] as Map<String, dynamic>),
      isPaused: json['isPaused'] as bool?,
      completedMetrics: metrics?['completed'] == null
          ? null
          : MisskeyQueueMetrics.fromJson(
              metrics!['completed'] as Map<String, dynamic>,
            ),
      failedMetrics: metrics?['failed'] == null
          ? null
          : MisskeyQueueMetrics.fromJson(
              metrics!['failed'] as Map<String, dynamic>,
            ),
      db: json['db'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => _$MisskeyQueueInfoToJson(this);

  /// The queue name (e.g. `deliver`, `inbox`, `db`).
  final String name;

  /// The fully qualified queue name, when returned by the endpoint.
  final String? qualifiedName;

  /// The job counts per state.
  final MisskeyQueueCount? counts;

  /// Whether the queue is paused.
  final bool? isPaused;

  /// Throughput metrics for completed jobs.
  final MisskeyQueueMetrics? completedMetrics;

  /// Throughput metrics for failed jobs.
  final MisskeyQueueMetrics? failedMetrics;

  /// Redis server information, returned only by
  /// `/api/admin/queue/queue-stats`.
  final Map<String, dynamic>? db;
}

/// A job in a queue (`/api/admin/queue/jobs`, `/api/admin/queue/show-job`).
@JsonSerializable()
class MisskeyQueueJob {
  const MisskeyQueueJob({
    required this.id,
    required this.name,
    this.data,
    this.opts,
    this.timestamp,
    this.processedOn,
    this.processedBy,
    this.finishedOn,
    this.progress,
    this.attempts,
    this.delay,
    this.failedReason,
    this.stacktrace,
    this.returnValue,
    this.isFailed,
  });

  factory MisskeyQueueJob.fromJson(Map<String, dynamic> json) =>
      _$MisskeyQueueJobFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyQueueJobToJson(this);

  /// The job ID.
  final String id;

  /// The job name (for delivery jobs this is the destination host).
  final String name;

  /// The job payload.
  final Map<String, dynamic>? data;

  /// The job options.
  final Map<String, dynamic>? opts;

  /// The epoch timestamp (ms) when the job was enqueued.
  final num? timestamp;

  /// The epoch timestamp (ms) when processing started.
  final num? processedOn;

  /// The worker that processed the job.
  final String? processedBy;

  /// The epoch timestamp (ms) when processing finished.
  final num? finishedOn;

  /// The job progress.
  ///
  /// Typed as `dynamic` because the server returns a number in practice
  /// even though the API documentation declares an object.
  final dynamic progress;

  /// The number of attempts made.
  final num? attempts;

  /// The delay in milliseconds.
  final num? delay;

  /// The failure reason, if the job failed.
  ///
  /// The API documentation marks this as required, but the server omits
  /// it for successful jobs.
  final String? failedReason;

  /// The failure stack trace.
  final List<String>? stacktrace;

  /// The value returned by the job.
  ///
  /// Typed as `dynamic` because the server returns a string in practice
  /// even though the API documentation declares an object.
  final dynamic returnValue;

  /// Whether the job has failed.
  final bool? isFailed;
}

/// A per-host delayed job count entry
/// (`/api/admin/queue/deliver-delayed`, `/api/admin/queue/inbox-delayed`).
class MisskeyDelayedQueueEntry {
  const MisskeyDelayedQueueEntry({required this.host, required this.count});

  /// Creates an instance from the raw `[host, count]` tuple.
  factory MisskeyDelayedQueueEntry.fromJson(List<dynamic> json) =>
      MisskeyDelayedQueueEntry(host: json[0] as String, count: json[1] as num);

  /// The destination host.
  final String host;

  /// The number of delayed jobs for this host.
  final num count;
}
