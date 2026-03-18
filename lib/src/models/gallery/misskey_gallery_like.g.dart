// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_gallery_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyGalleryLike _$MisskeyGalleryLikeFromJson(Map<String, dynamic> json) =>
    MisskeyGalleryLike(
      id: json['id'] as String,
      post: MisskeyGalleryPost.fromJson(json['post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyGalleryLikeToJson(MisskeyGalleryLike instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post': instance.post.toJson(),
    };
