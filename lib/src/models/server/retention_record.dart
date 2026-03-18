import 'package:json_annotation/json_annotation.dart';

part 'retention_record.g.dart';

/// A user retention record returned by `/api/retention`.
@JsonSerializable()
class RetentionRecord {
  const RetentionRecord({
    required this.createdAt,
    required this.users,
    required this.data,
  });

  factory RetentionRecord.fromJson(Map<String, dynamic> json) =>
      _$RetentionRecordFromJson(json);

  Map<String, dynamic> toJson() => _$RetentionRecordToJson(this);

  /// The date and time of the aggregation.
  final DateTime createdAt;

  /// The number of target users.
  final int users;

  /// Retention data keyed by elapsed days (as strings) with user
  /// counts as values.
  final Map<String, int> data;
}
