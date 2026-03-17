// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retention_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetentionRecord _$RetentionRecordFromJson(Map<String, dynamic> json) =>
    RetentionRecord(
      createdAt: DateTime.parse(json['createdAt'] as String),
      users: (json['users'] as num).toInt(),
      data: Map<String, int>.from(json['data'] as Map),
    );

Map<String, dynamic> _$RetentionRecordToJson(RetentionRecord instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'users': instance.users,
      'data': instance.data,
    };
