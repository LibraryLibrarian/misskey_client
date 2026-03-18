// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerInfo _$ServerInfoFromJson(Map<String, dynamic> json) => ServerInfo(
      machine: json['machine'] as String,
      cpu: ServerCpuInfo.fromJson(json['cpu'] as Map<String, dynamic>),
      mem: ServerMemInfo.fromJson(json['mem'] as Map<String, dynamic>),
      fs: ServerFsInfo.fromJson(json['fs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServerInfoToJson(ServerInfo instance) =>
    <String, dynamic>{
      'machine': instance.machine,
      'cpu': instance.cpu.toJson(),
      'mem': instance.mem.toJson(),
      'fs': instance.fs.toJson(),
    };

ServerCpuInfo _$ServerCpuInfoFromJson(Map<String, dynamic> json) =>
    ServerCpuInfo(
      model: json['model'] as String,
      cores: (json['cores'] as num).toInt(),
    );

Map<String, dynamic> _$ServerCpuInfoToJson(ServerCpuInfo instance) =>
    <String, dynamic>{
      'model': instance.model,
      'cores': instance.cores,
    };

ServerMemInfo _$ServerMemInfoFromJson(Map<String, dynamic> json) =>
    ServerMemInfo(
      total: json['total'] as num,
    );

Map<String, dynamic> _$ServerMemInfoToJson(ServerMemInfo instance) =>
    <String, dynamic>{
      'total': instance.total,
    };

ServerFsInfo _$ServerFsInfoFromJson(Map<String, dynamic> json) => ServerFsInfo(
      total: json['total'] as num,
      used: json['used'] as num,
    );

Map<String, dynamic> _$ServerFsInfoToJson(ServerFsInfo instance) =>
    <String, dynamic>{
      'total': instance.total,
      'used': instance.used,
    };
