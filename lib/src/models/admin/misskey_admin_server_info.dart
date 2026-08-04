import 'package:json_annotation/json_annotation.dart';

import '../server/server_info.dart';

part 'misskey_admin_server_info.g.dart';

/// Response model for the Misskey `/api/admin/server-info` endpoint.
///
/// Unlike the public `/api/server-info`, this includes software versions
/// (Node.js, PostgreSQL, Redis) and network interface information.
@JsonSerializable()
class MisskeyAdminServerInfo {
  const MisskeyAdminServerInfo({
    required this.machine,
    required this.os,
    required this.node,
    required this.psql,
    required this.redis,
    required this.cpu,
    required this.mem,
    required this.fs,
    this.net,
  });

  factory MisskeyAdminServerInfo.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdminServerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdminServerInfoToJson(this);

  /// The machine name.
  final String machine;

  /// The operating system (e.g. `linux`).
  final String os;

  /// The Node.js version.
  final String node;

  /// The PostgreSQL version.
  final String psql;

  /// The Redis version.
  final String redis;

  /// The CPU information.
  final ServerCpuInfo cpu;

  /// The memory information.
  final ServerMemInfo mem;

  /// The filesystem information.
  final ServerFsInfo fs;

  /// The network interface information.
  final AdminServerNetInfo? net;
}

/// Network interface information in [MisskeyAdminServerInfo].
@JsonSerializable()
class AdminServerNetInfo {
  const AdminServerNetInfo({this.interface});

  factory AdminServerNetInfo.fromJson(Map<String, dynamic> json) =>
      _$AdminServerNetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminServerNetInfoToJson(this);

  /// The network interface name (e.g. `eth0`).
  final String? interface;
}
