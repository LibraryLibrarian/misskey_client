import 'package:freezed_annotation/freezed_annotation.dart';

import '../server/server_info.dart';

part 'misskey_admin_server_info.freezed.dart';
part 'misskey_admin_server_info.g.dart';

/// Response model for the Misskey `/api/admin/server-info` endpoint.
///
/// Unlike the public `/api/server-info`, this includes software versions
/// (Node.js, PostgreSQL, Redis) and network interface information.
@freezed
@JsonSerializable()
class MisskeyAdminServerInfo with _$MisskeyAdminServerInfo {
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
  @override
  final String machine;

  /// The operating system (e.g. `linux`).
  @override
  final String os;

  /// The Node.js version.
  @override
  final String node;

  /// The PostgreSQL version.
  @override
  final String psql;

  /// The Redis version.
  @override
  final String redis;

  /// The CPU information.
  @override
  final ServerCpuInfo cpu;

  /// The memory information.
  @override
  final ServerMemInfo mem;

  /// The filesystem information.
  @override
  final ServerFsInfo fs;

  /// The network interface information.
  @override
  final AdminServerNetInfo? net;
}

/// Network interface information in [MisskeyAdminServerInfo].
@freezed
@JsonSerializable()
class AdminServerNetInfo with _$AdminServerNetInfo {
  const AdminServerNetInfo({this.interface});

  factory AdminServerNetInfo.fromJson(Map<String, dynamic> json) =>
      _$AdminServerNetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminServerNetInfoToJson(this);

  /// The network interface name (e.g. `eth0`).
  @override
  final String? interface;
}
