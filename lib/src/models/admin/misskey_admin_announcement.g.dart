// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_admin_announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAdminAnnouncement _$MisskeyAdminAnnouncementFromJson(
  Map<String, dynamic> json,
) => MisskeyAdminAnnouncement(
  id: json['id'] as String,
  createdAt: const SafeDateTimeConverter().fromJson(
    json['createdAt'] as String?,
  ),
  updatedAt: const SafeDateTimeConverter().fromJson(
    json['updatedAt'] as String?,
  ),
  title: json['title'] as String,
  text: json['text'] as String,
  imageUrl: json['imageUrl'] as String?,
  icon: json['icon'] as String?,
  display: json['display'] as String?,
  isActive: json['isActive'] as bool?,
  forExistingUsers: json['forExistingUsers'] as bool?,
  silence: json['silence'] as bool?,
  needConfirmationToRead: json['needConfirmationToRead'] as bool?,
  userId: json['userId'] as String?,
  reads: (json['reads'] as num?)?.toInt(),
);

Map<String, dynamic> _$MisskeyAdminAnnouncementToJson(
  MisskeyAdminAnnouncement instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
  'title': instance.title,
  'text': instance.text,
  'imageUrl': instance.imageUrl,
  'icon': instance.icon,
  'display': instance.display,
  'isActive': instance.isActive,
  'forExistingUsers': instance.forExistingUsers,
  'silence': instance.silence,
  'needConfirmationToRead': instance.needConfirmationToRead,
  'userId': instance.userId,
  'reads': instance.reads,
};
