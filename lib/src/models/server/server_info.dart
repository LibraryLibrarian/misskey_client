import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_info.freezed.dart';
part 'server_info.g.dart';

/// Server machine information returned by `/api/server-info`.
@freezed
@JsonSerializable()
class ServerInfo with _$ServerInfo {
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
  @override
  final String machine;

  /// The CPU information.
  @override
  final ServerCpuInfo cpu;

  /// The memory information.
  @override
  final ServerMemInfo mem;

  /// The filesystem information.
  @override
  final ServerFsInfo fs;
}

/// Server CPU information.
@freezed
@JsonSerializable()
class ServerCpuInfo with _$ServerCpuInfo {
  const ServerCpuInfo({required this.model, required this.cores});

  factory ServerCpuInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerCpuInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerCpuInfoToJson(this);

  /// The CPU model name.
  @override
  final String model;

  /// The number of CPU cores.
  @override
  final int cores;
}

/// Server memory information.
@freezed
@JsonSerializable()
class ServerMemInfo with _$ServerMemInfo {
  const ServerMemInfo({required this.total});

  factory ServerMemInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerMemInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerMemInfoToJson(this);

  /// The total memory capacity in bytes.
  @override
  final num total;
}

/// Server filesystem information.
@freezed
@JsonSerializable()
class ServerFsInfo with _$ServerFsInfo {
  const ServerFsInfo({required this.total, required this.used});

  factory ServerFsInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerFsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerFsInfoToJson(this);

  /// The total disk capacity in bytes.
  @override
  final num total;

  /// The used disk space in bytes.
  @override
  final num used;
}
