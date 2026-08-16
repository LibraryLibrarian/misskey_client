import 'package:freezed_annotation/freezed_annotation.dart';

part 'retention_record.freezed.dart';
part 'retention_record.g.dart';

/// A user retention record returned by `/api/retention`.
@freezed
@JsonSerializable()
class RetentionRecord with _$RetentionRecord {
  const RetentionRecord({
    required this.createdAt,
    required this.users,
    required this.data,
  });

  factory RetentionRecord.fromJson(Map<String, dynamic> json) =>
      _$RetentionRecordFromJson(json);

  Map<String, dynamic> toJson() => _$RetentionRecordToJson(this);

  /// The date and time of the aggregation.
  @override
  final DateTime createdAt;

  /// The number of target users.
  @override
  final int users;

  /// Retention data keyed by elapsed days (as strings) with user
  /// counts as values.
  @override
  final Map<String, int> data;
}
