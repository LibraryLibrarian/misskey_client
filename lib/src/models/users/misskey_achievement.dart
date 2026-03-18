import 'package:json_annotation/json_annotation.dart';

part 'misskey_achievement.g.dart';

/// A user achievement from the `/api/users/achievements` response.
@JsonSerializable()
class MisskeyAchievement {
  const MisskeyAchievement({
    required this.name,
    required this.unlockedAt,
  });

  factory MisskeyAchievement.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAchievementFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAchievementToJson(this);

  /// The achievement name.
  final String name;

  /// When the achievement was unlocked (Unix timestamp in seconds).
  final int unlockedAt;
}
