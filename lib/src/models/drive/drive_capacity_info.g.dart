// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_capacity_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriveCapacityInfo _$DriveCapacityInfoFromJson(Map<String, dynamic> json) =>
    DriveCapacityInfo(
      capacity: (json['capacity'] as num).toInt(),
      usage: (json['usage'] as num).toInt(),
    );

Map<String, dynamic> _$DriveCapacityInfoToJson(DriveCapacityInfo instance) =>
    <String, dynamic>{
      'capacity': instance.capacity,
      'usage': instance.usage,
    };
