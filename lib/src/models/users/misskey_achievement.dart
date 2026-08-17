import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_achievement.freezed.dart';
part 'misskey_achievement.g.dart';

/// A user achievement from the `/api/users/achievements` response.
@freezed
@JsonSerializable()
class MisskeyAchievement with _$MisskeyAchievement {
  const MisskeyAchievement({required this.name, required this.unlockedAt});

  factory MisskeyAchievement.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAchievementFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAchievementToJson(this);

  /// The achievement name.
  @override
  final String name;

  /// When the achievement was unlocked (Unix timestamp in seconds).
  @override
  final int unlockedAt;
}
