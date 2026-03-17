import 'package:json_annotation/json_annotation.dart';

part 'retention_record.g.dart';

/// ユーザーリテンション（定着率）レコード（`/api/retention`）
@JsonSerializable(createToJson: false)
class RetentionRecord {
  const RetentionRecord({
    required this.createdAt,
    required this.users,
    required this.data,
  });

  factory RetentionRecord.fromJson(Map<String, dynamic> json) =>
      _$RetentionRecordFromJson(json);

  /// 集計対象日時
  final DateTime createdAt;

  /// 対象ユーザー数
  final int users;

  /// 日数ごとのリテンションデータ（キーは経過日数の文字列、値はユーザー数）
  final Map<String, int> data;
}
