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
      eyeCatchingImage: json['eyeCatchingImage'] == null
          ? null
          : MisskeyDriveFile.fromJson(
              json['eyeCatchingImage'] as Map<String, dynamic>),
      attachedFiles: (json['attachedFiles'] as List<dynamic>?)
              ?.map((e) => MisskeyDriveFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      likedCount: (json['likedCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool?,
    );

Map<String, dynamic> _$MisskeyPageToJson(MisskeyPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
      'userId': instance.userId,
      'user': instance.user?.toJson(),
      'title': instance.title,
      'name': instance.name,
      'summary': instance.summary,
      'content': instance.content,
      'variables': instance.variables,
      'alignCenter': instance.alignCenter,
      'hideTitleWhenPinned': instance.hideTitleWhenPinned,
      'font': instance.font,
      'script': instance.script,
      'eyeCatchingImageId': instance.eyeCatchingImageId,
      'eyeCatchingImage': instance.eyeCatchingImage?.toJson(),
      'attachedFiles': instance.attachedFiles.map((e) => e.toJson()).toList(),
      'likedCount': instance.likedCount,
      'isLiked': instance.isLiked,
    };
