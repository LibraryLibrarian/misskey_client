// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_abuse_user_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAbuseUserReport _$MisskeyAbuseUserReportFromJson(
  Map<String, dynamic> json,
) => MisskeyAbuseUserReport(
  id: json['id'] as String,
  createdAt: const SafeDateTimeConverter().fromJson(
    json['createdAt'] as String?,
  ),
  comment: json['comment'] as String,
  resolved: json['resolved'] as bool,
  reporterId: json['reporterId'] as String?,
  targetUserId: json['targetUserId'] as String?,
  assigneeId: json['assigneeId'] as String?,
  reporter: json['reporter'] == null
      ? null
      : MisskeyUser.fromJson(json['reporter'] as Map<String, dynamic>),
  targetUser: json['targetUser'] == null
      ? null
      : MisskeyUser.fromJson(json['targetUser'] as Map<String, dynamic>),
  assignee: json['assignee'] == null
      ? null
      : MisskeyUser.fromJson(json['assignee'] as Map<String, dynamic>),
  forwarded: json['forwarded'] as bool?,
  resolvedAs: json['resolvedAs'] as String?,
  moderationNote: json['moderationNote'] as String?,
);

Map<String, dynamic> _$MisskeyAbuseUserReportToJson(
  MisskeyAbuseUserReport instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
  'comment': instance.comment,
  'resolved': instance.resolved,
  'reporterId': instance.reporterId,
  'targetUserId': instance.targetUserId,
  'assigneeId': instance.assigneeId,
  'reporter': instance.reporter?.toJson(),
  'targetUser': instance.targetUser?.toJson(),
  'assignee': instance.assignee?.toJson(),
  'forwarded': instance.forwarded,
  'resolvedAs': instance.resolvedAs,
  'moderationNote': instance.moderationNote,
};
