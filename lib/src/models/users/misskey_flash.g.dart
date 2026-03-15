// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_flash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyFlash _$MisskeyFlashFromJson(Map<String, dynamic> json) => MisskeyFlash(
      id: json['id'] as String,
      createdAt:
          const SafeDateTimeConverter().fromJson(json['createdAt'] as String?),
      updatedAt:
          const SafeDateTimeConverter().fromJson(json['updatedAt'] as String?),
      userId: json['userId'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      script: json['script'] as String,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      likedCount: (json['likedCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool?,
    );
