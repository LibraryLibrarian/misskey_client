import 'package:json_annotation/json_annotation.dart';

part 'server_info.g.dart';

/// Server machine information returned by `/api/server-info`.
@JsonSerializable()
class ServerInfo {
  const ServerInfo({
    required this.machine,
    required this.cpu,
    required this.mem,
    required this.fs,
  });

  factory ServerInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerInfoToJson(this);

  /// The machine name.
  final String machine;

  /// The CPU information.
  final ServerCpuInfo cpu;

  /// The memory information.
  final ServerMemInfo mem;

  /// The filesystem information.
  final ServerFsInfo fs;
}

/// Server CPU information.
@JsonSerializable()
class ServerCpuInfo {
  const ServerCpuInfo({
    required this.model,
    required this.cores,
  });

  factory ServerCpuInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerCpuInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerCpuInfoToJson(this);

  /// The CPU model name.
  final String model;

  /// The number of CPU cores.
  final int cores;
}

/// Server memory information.
@JsonSerializable()
class ServerMemInfo {
  const ServerMemInfo({
    required this.total,
  });

  factory ServerMemInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerMemInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerMemInfoToJson(this);

  /// The total memory capacity in bytes.
  final num total;
}

/// Server filesystem information.
@JsonSerializable()
class ServerFsInfo {
  const ServerFsInfo({
    required this.total,
    required this.used,
  });

  factory ServerFsInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerFsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerFsInfoToJson(this);

  /// The total disk capacity in bytes.
  final num total;

  /// The used disk space in bytes.
  final num used;
}
