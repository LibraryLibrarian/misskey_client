import 'package:freezed_annotation/freezed_annotation.dart';

part 'instance_stats.freezed.dart';
part 'instance_stats.g.dart';

/// Instance statistics returned by `/api/stats`.
@freezed
@JsonSerializable()
class InstanceStats with _$InstanceStats {
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
  @override
  final int notesCount;

  /// The number of notes originating from this instance.
  @override
  final int originalNotesCount;

  /// The total number of users.
  @override
  final int usersCount;

  /// The number of local users.
  @override
  final int originalUsersCount;

  /// The number of federated instances.
  @override
  final int instances;

  /// Local drive usage in bytes.
  @override
  final int driveUsageLocal;

  /// Remote drive usage in bytes.
  @override
  final int driveUsageRemote;

  /// The number of reactions (not in the official schema but returned
  /// by the handler).
  @override
  final int? reactionsCount;
}
