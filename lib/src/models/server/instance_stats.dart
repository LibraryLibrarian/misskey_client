import 'package:json_annotation/json_annotation.dart';

part 'instance_stats.g.dart';

/// インスタンスの統計情報（`/api/stats`）
@JsonSerializable()
class InstanceStats {
  const InstanceStats({
    required this.notesCount,
    required this.originalNotesCount,
    required this.usersCount,
    required this.originalUsersCount,
    required this.instances,
    required this.driveUsageLocal,
    required this.driveUsageRemote,
    this.reactionsCount,
  });

  factory InstanceStats.fromJson(Map<String, dynamic> json) =>
      _$InstanceStatsFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceStatsToJson(this);

  /// 総ノート数
  final int notesCount;

  /// ローカル発信ノート数
  final int originalNotesCount;

  /// 総ユーザー数
  final int usersCount;

  /// ローカルユーザー数
  final int originalUsersCount;

  /// 連合インスタンス数
  final int instances;

  /// ローカルドライブ使用量（バイト）
  final int driveUsageLocal;

  /// リモートドライブ使用量（バイト）
  final int driveUsageRemote;

  /// リアクション数（公式スキーマ未定義だがハンドラーで返却される）
  final int? reactionsCount;
}
