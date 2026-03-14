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
