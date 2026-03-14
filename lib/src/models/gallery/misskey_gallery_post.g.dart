// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_gallery_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyGalleryPost _$MisskeyGalleryPostFromJson(Map<String, dynamic> json) =>
    MisskeyGalleryPost(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String,
      title: json['title'] as String,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      description: json['description'] as String?,
      fileIds: (json['fileIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      files: (json['files'] as List<dynamic>?)
              ?.map((e) => MisskeyDriveFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isSensitive: json['isSensitive'] as bool? ?? false,
      likedCount: (json['likedCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool?,
    );
