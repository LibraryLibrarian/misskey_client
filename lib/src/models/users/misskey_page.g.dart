// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyPage _$MisskeyPageFromJson(Map<String, dynamic> json) => MisskeyPage(
      id: json['id'] as String,
      createdAt:
          const SafeDateTimeConverter().fromJson(json['createdAt'] as String?),
      updatedAt:
          const SafeDateTimeConverter().fromJson(json['updatedAt'] as String?),
      userId: json['userId'] as String,
      title: json['title'] as String,
      name: json['name'] as String,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      summary: json['summary'] as String?,
      content: json['content'] as List<dynamic>?,
      variables: json['variables'] as List<dynamic>?,
      alignCenter: json['alignCenter'] as bool? ?? false,
      hideTitleWhenPinned: json['hideTitleWhenPinned'] as bool? ?? false,
      font: json['font'] as String?,
      script: json['script'] as String?,
      eyeCatchingImageId: json['eyeCatchingImageId'] as String?,
      likedCount: (json['likedCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool?,
    );
