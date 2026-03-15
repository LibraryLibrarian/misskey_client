import 'package:json_annotation/json_annotation.dart';

part 'server_info.g.dart';

/// サーバーのマシン情報（`/api/server-info`）
@JsonSerializable(createToJson: false)
class ServerInfo {
  const ServerInfo({
    required this.machine,
    required this.cpu,
    required this.mem,
    required this.fs,
  });

  factory ServerInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerInfoFromJson(json);

  /// マシン名
  final String machine;

  /// CPU情報
  final ServerCpuInfo cpu;

  /// メモリ情報
  final ServerMemInfo mem;

  /// ファイルシステム情報
  final ServerFsInfo fs;
}

/// サーバーのCPU情報
@JsonSerializable(createToJson: false)
class ServerCpuInfo {
  const ServerCpuInfo({
    required this.model,
    required this.cores,
  });

  factory ServerCpuInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerCpuInfoFromJson(json);

  /// CPUモデル名
  final String model;

  /// コア数
  final int cores;
}

/// サーバーのメモリ情報
@JsonSerializable(createToJson: false)
class ServerMemInfo {
  const ServerMemInfo({
    required this.total,
  });

  factory ServerMemInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerMemInfoFromJson(json);

  /// 総メモリ容量（バイト）
  final num total;
}

/// サーバーのファイルシステム情報
@JsonSerializable(createToJson: false)
class ServerFsInfo {
  const ServerFsInfo({
    required this.total,
    required this.used,
  });

  factory ServerFsInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerFsInfoFromJson(json);

  /// 総ディスク容量（バイト）
  final num total;

  /// 使用済みディスク容量（バイト）
  final num used;
}
