import 'package:json_annotation/json_annotation.dart';

part 'instance_stats.g.dart';

/// Instance statistics returned by `/api/stats`.
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

  /// The total number of notes.
  final int notesCount;

  /// The number of notes originating from this instance.
  final int originalNotesCount;

  /// The total number of users.
  final int usersCount;

  /// The number of local users.
  final int originalUsersCount;

  /// The number of federated instances.
  final int instances;

  /// Local drive usage in bytes.
  final int driveUsageLocal;

  /// Remote drive usage in bytes.
  final int driveUsageRemote;

  /// The number of reactions (not in the official schema but returned
  /// by the handler).
  final int? reactionsCount;
}
