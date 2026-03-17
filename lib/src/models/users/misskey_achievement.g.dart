// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAchievement _$MisskeyAchievementFromJson(Map<String, dynamic> json) =>
    MisskeyAchievement(
      name: json['name'] as String,
      unlockedAt: (json['unlockedAt'] as num).toInt(),
    );

Map<String, dynamic> _$MisskeyAchievementToJson(MisskeyAchievement instance) =>
    <String, dynamic>{
      'name': instance.name,
      'unlockedAt': instance.unlockedAt,
    };
