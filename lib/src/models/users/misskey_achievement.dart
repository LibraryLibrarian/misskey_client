import 'package:json_annotation/json_annotation.dart';

part 'misskey_achievement.g.dart';

/// ユーザーの実績（`/api/users/achievements` のレスポンス要素）
@JsonSerializable()
class MisskeyAchievement {
  const MisskeyAchievement({
    required this.name,
    required this.unlockedAt,
  });

  factory MisskeyAchievement.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAchievementFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAchievementToJson(this);

  /// 実績名
  final String name;

  /// 解除日時（Unixタイムスタンプ秒）
  final int unlockedAt;
}
