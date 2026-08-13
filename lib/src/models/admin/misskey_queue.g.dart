// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyQueueCount _$MisskeyQueueCountFromJson(Map<String, dynamic> json) =>
    MisskeyQueueCount(
      waiting: json['waiting'] as num?,
      active: json['active'] as num?,
      completed: json['completed'] as num?,
      failed: json['failed'] as num?,
      delayed: json['delayed'] as num?,
      paused: json['paused'] as num?,
      prioritized: json['prioritized'] as num?,
      waitingChildren: json['waiting-children'] as num?,
    );

Map<String, dynamic> _$MisskeyQueueCountToJson(MisskeyQueueCount instance) =>
    <String, dynamic>{
      'waiting': instance.waiting,
      'active': instance.active,
      'completed': instance.completed,
      'failed': instance.failed,
      'delayed': instance.delayed,
      'paused': instance.paused,
      'prioritized': instance.prioritized,
      'waiting-children': instance.waitingChildren,
    };

MisskeyQueueStats _$MisskeyQueueStatsFromJson(Map<String, dynamic> json) =>
    MisskeyQueueStats(
      deliver: json['deliver'] == null
          ? null
          : MisskeyQueueCount.fromJson(json['deliver'] as Map<String, dynamic>),
      inbox: json['inbox'] == null
          ? null
          : MisskeyQueueCount.fromJson(json['inbox'] as Map<String, dynamic>),
      db: json['db'] == null
          ? null
          : MisskeyQueueCount.fromJson(json['db'] as Map<String, dynamic>),
      objectStorage: json['objectStorage'] == null
          ? null
          : MisskeyQueueCount.fromJson(
              json['objectStorage'] as Map<String, dynamic>,
            ),
      userWebhookDeliver: json['userWebhookDeliver'] == null
          ? null
          : MisskeyQueueCount.fromJson(
              json['userWebhookDeliver'] as Map<String, dynamic>,
            ),
      systemWebhookDeliver: json['systemWebhookDeliver'] == null
          ? null
          : MisskeyQueueCount.fromJson(
              json['systemWebhookDeliver'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MisskeyQueueStatsToJson(MisskeyQueueStats instance) =>
    <String, dynamic>{
      'deliver': instance.deliver?.toJson(),
      'inbox': instance.inbox?.toJson(),
      'db': instance.db?.toJson(),
      'objectStorage': instance.objectStorage?.toJson(),
      'userWebhookDeliver': instance.userWebhookDeliver?.toJson(),
      'systemWebhookDeliver': instance.systemWebhookDeliver?.toJson(),
    };

MisskeyQueueMetrics _$MisskeyQueueMetricsFromJson(Map<String, dynamic> json) =>
    MisskeyQueueMetrics(
      meta: json['meta'] as Map<String, dynamic>?,
      data: (json['data'] as List<dynamic>?)?.map((e) => e as num).toList(),
      count: json['count'] as num?,
    );

Map<String, dynamic> _$MisskeyQueueMetricsToJson(
  MisskeyQueueMetrics instance,
) => <String, dynamic>{
  'meta': instance.meta,
  'data': instance.data,
  'count': instance.count,
};

MisskeyQueueInfo _$MisskeyQueueInfoFromJson(Map<String, dynamic> json) =>
    MisskeyQueueInfo(
      name: json['name'] as String,
      qualifiedName: json['qualifiedName'] as String?,
      counts: json['counts'] == null
          ? null
          : MisskeyQueueCount.fromJson(json['counts'] as Map<String, dynamic>),
      isPaused: json['isPaused'] as bool?,
      completedMetrics: json['completedMetrics'] == null
          ? null
          : MisskeyQueueMetrics.fromJson(
              json['completedMetrics'] as Map<String, dynamic>,
            ),
      failedMetrics: json['failedMetrics'] == null
          ? null
          : MisskeyQueueMetrics.fromJson(
              json['failedMetrics'] as Map<String, dynamic>,
            ),
      db: json['db'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MisskeyQueueInfoToJson(MisskeyQueueInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'qualifiedName': instance.qualifiedName,
      'counts': instance.counts?.toJson(),
      'isPaused': instance.isPaused,
      'completedMetrics': instance.completedMetrics?.toJson(),
      'failedMetrics': instance.failedMetrics?.toJson(),
      'db': instance.db,
    };

MisskeyQueueJob _$MisskeyQueueJobFromJson(Map<String, dynamic> json) =>
    MisskeyQueueJob(
      id: json['id'] as String,
      name: json['name'] as String,
      data: json['data'] as Map<String, dynamic>?,
      opts: json['opts'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] as num?,
      processedOn: json['processedOn'] as num?,
      processedBy: json['processedBy'] as String?,
      finishedOn: json['finishedOn'] as num?,
      progress: json['progress'],
      attempts: json['attempts'] as num?,
      delay: json['delay'] as num?,
      failedReason: json['failedReason'] as String?,
      stacktrace: (json['stacktrace'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      returnValue: json['returnValue'],
      isFailed: json['isFailed'] as bool?,
    );

Map<String, dynamic> _$MisskeyQueueJobToJson(MisskeyQueueJob instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'data': instance.data,
      'opts': instance.opts,
      'timestamp': instance.timestamp,
      'processedOn': instance.processedOn,
      'processedBy': instance.processedBy,
      'finishedOn': instance.finishedOn,
      'progress': instance.progress,
      'attempts': instance.attempts,
      'delay': instance.delay,
      'failedReason': instance.failedReason,
      'stacktrace': instance.stacktrace,
      'returnValue': instance.returnValue,
      'isFailed': instance.isFailed,
    };
