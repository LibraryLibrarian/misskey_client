// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_moderation_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyModerationLog _$MisskeyModerationLogFromJson(
  Map<String, dynamic> json,
) => MisskeyModerationLog(
  id: json['id'] as String,
  createdAt: const SafeDateTimeConverter().fromJson(
    json['createdAt'] as String?,
  ),
  type: json['type'] as String,
  info: json['info'] as Map<String, dynamic>?,
  userId: json['userId'] as String?,
  user: json['user'] == null
      ? null
      : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MisskeyModerationLogToJson(
  MisskeyModerationLog instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
  'info': instance.info,
  'userId': instance.userId,
  'user': instance.user?.toJson(),
};

MisskeyUserIp _$MisskeyUserIpFromJson(Map<String, dynamic> json) =>
    MisskeyUserIp(
      ip: json['ip'] as String,
      createdAt: const SafeDateTimeConverter().fromJson(
        json['createdAt'] as String?,
      ),
    );

Map<String, dynamic> _$MisskeyUserIpToJson(MisskeyUserIp instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
    };

MisskeyIndexStat _$MisskeyIndexStatFromJson(Map<String, dynamic> json) =>
    MisskeyIndexStat(
      tablename: json['tablename'] as String,
      indexname: json['indexname'] as String,
      schemaname: json['schemaname'] as String?,
      tablespace: json['tablespace'] as String?,
      indexdef: json['indexdef'] as String?,
    );

Map<String, dynamic> _$MisskeyIndexStatToJson(MisskeyIndexStat instance) =>
    <String, dynamic>{
      'tablename': instance.tablename,
      'indexname': instance.indexname,
      'schemaname': instance.schemaname,
      'tablespace': instance.tablespace,
      'indexdef': instance.indexdef,
    };

MisskeyTableStat _$MisskeyTableStatFromJson(Map<String, dynamic> json) =>
    MisskeyTableStat(count: json['count'] as num, size: json['size'] as num);

Map<String, dynamic> _$MisskeyTableStatToJson(MisskeyTableStat instance) =>
    <String, dynamic>{'count': instance.count, 'size': instance.size};
