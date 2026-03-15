// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceStats _$InstanceStatsFromJson(Map<String, dynamic> json) =>
    InstanceStats(
      notesCount: (json['notesCount'] as num).toInt(),
      originalNotesCount: (json['originalNotesCount'] as num).toInt(),
      usersCount: (json['usersCount'] as num).toInt(),
      originalUsersCount: (json['originalUsersCount'] as num).toInt(),
      instances: (json['instances'] as num).toInt(),
      driveUsageLocal: (json['driveUsageLocal'] as num).toInt(),
      driveUsageRemote: (json['driveUsageRemote'] as num).toInt(),
      reactionsCount: (json['reactionsCount'] as num?)?.toInt(),
    );
