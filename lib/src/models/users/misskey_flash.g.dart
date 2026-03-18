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
      visibility: json['visibility'] as String?,
      likedCount: (json['likedCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool?,
    );

Map<String, dynamic> _$MisskeyFlashToJson(MisskeyFlash instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
      'userId': instance.userId,
      'user': instance.user?.toJson(),
      'title': instance.title,
      'summary': instance.summary,
      'script': instance.script,
      'visibility': instance.visibility,
      'likedCount': instance.likedCount,
      'isLiked': instance.isLiked,
    };
