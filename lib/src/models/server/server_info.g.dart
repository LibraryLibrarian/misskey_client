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

ServerCpuInfo _$ServerCpuInfoFromJson(Map<String, dynamic> json) =>
    ServerCpuInfo(
      model: json['model'] as String,
      cores: (json['cores'] as num).toInt(),
    );

ServerMemInfo _$ServerMemInfoFromJson(Map<String, dynamic> json) =>
    ServerMemInfo(
      total: json['total'] as num,
    );

ServerFsInfo _$ServerFsInfoFromJson(Map<String, dynamic> json) => ServerFsInfo(
      total: json['total'] as num,
      used: json['used'] as num,
    );
