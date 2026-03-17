// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAnnouncement _$MisskeyAnnouncementFromJson(Map<String, dynamic> json) =>
    MisskeyAnnouncement(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      title: json['title'] as String,
      text: json['text'] as String,
      icon: json['icon'] as String,
      display: json['display'] as String,
      updatedAt:
          const SafeDateTimeConverter().fromJson(json['updatedAt'] as String?),
      imageUrl: json['imageUrl'] as String?,
      needConfirmationToRead: json['needConfirmationToRead'] as bool? ?? false,
      silence: json['silence'] as bool? ?? false,
      forYou: json['forYou'] as bool? ?? false,
      isRead: json['isRead'] as bool?,
    );

Map<String, dynamic> _$MisskeyAnnouncementToJson(
        MisskeyAnnouncement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
      'title': instance.title,
      'text': instance.text,
      'imageUrl': instance.imageUrl,
      'icon': instance.icon,
      'display': instance.display,
      'needConfirmationToRead': instance.needConfirmationToRead,
      'silence': instance.silence,
      'forYou': instance.forYou,
      'isRead': instance.isRead,
    };
