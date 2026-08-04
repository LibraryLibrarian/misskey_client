// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_admin_server_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAdminServerInfo _$MisskeyAdminServerInfoFromJson(
        Map<String, dynamic> json) =>
    MisskeyAdminServerInfo(
      machine: json['machine'] as String,
      os: json['os'] as String,
      node: json['node'] as String,
      psql: json['psql'] as String,
      redis: json['redis'] as String,
      cpu: ServerCpuInfo.fromJson(json['cpu'] as Map<String, dynamic>),
      mem: ServerMemInfo.fromJson(json['mem'] as Map<String, dynamic>),
      fs: ServerFsInfo.fromJson(json['fs'] as Map<String, dynamic>),
      net: json['net'] == null
          ? null
          : AdminServerNetInfo.fromJson(json['net'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyAdminServerInfoToJson(
        MisskeyAdminServerInfo instance) =>
    <String, dynamic>{
      'machine': instance.machine,
      'os': instance.os,
      'node': instance.node,
      'psql': instance.psql,
      'redis': instance.redis,
      'cpu': instance.cpu.toJson(),
      'mem': instance.mem.toJson(),
      'fs': instance.fs.toJson(),
      'net': instance.net?.toJson(),
    };

AdminServerNetInfo _$AdminServerNetInfoFromJson(Map<String, dynamic> json) =>
    AdminServerNetInfo(
      interface: json['interface'] as String?,
    );

Map<String, dynamic> _$AdminServerNetInfoToJson(AdminServerNetInfo instance) =>
    <String, dynamic>{
      'interface': instance.interface,
    };
