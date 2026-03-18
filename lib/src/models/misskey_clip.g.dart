// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_clip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyClip _$MisskeyClipFromJson(Map<String, dynamic> json) => MisskeyClip(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      name: json['name'] as String,
      lastClippedAt: const SafeDateTimeConverter()
          .fromJson(json['lastClippedAt'] as String?),
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      description: json['description'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      favoritedCount: (json['favoritedCount'] as num?)?.toInt() ?? 0,
      isFavorited: json['isFavorited'] as bool?,
    );

Map<String, dynamic> _$MisskeyClipToJson(MisskeyClip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastClippedAt':
          const SafeDateTimeConverter().toJson(instance.lastClippedAt),
      'userId': instance.userId,
      'user': instance.user?.toJson(),
      'name': instance.name,
      'description': instance.description,
      'isPublic': instance.isPublic,
      'favoritedCount': instance.favoritedCount,
      'isFavorited': instance.isFavorited,
    };
