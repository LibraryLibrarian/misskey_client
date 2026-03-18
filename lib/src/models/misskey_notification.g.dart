// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNotification _$MisskeyNotificationFromJson(Map<String, dynamic> json) =>
    MisskeyNotification(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: $enumDecode(_$MisskeyNotificationTypeEnumMap, json['type'],
          unknownValue: MisskeyNotificationType.unknown),
      userId: json['userId'] as String?,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      note: json['note'] == null
          ? null
          : MisskeyNote.fromJson(json['note'] as Map<String, dynamic>),
      reaction: json['reaction'] as String?,
      achievement: json['achievement'] as String?,
      body: json['body'] as String?,
      header: json['header'] as String?,
      icon: json['icon'] as String?,
      role: json['role'],
      message: json['message'] as String?,
      reactions: json['reactions'] as List<dynamic>?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => MisskeyUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MisskeyNotificationToJson(
        MisskeyNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': _$MisskeyNotificationTypeEnumMap[instance.type]!,
      'userId': instance.userId,
      'user': instance.user?.toJson(),
      'note': instance.note?.toJson(),
      'reaction': instance.reaction,
      'achievement': instance.achievement,
      'body': instance.body,
      'header': instance.header,
      'icon': instance.icon,
      'role': instance.role,
      'message': instance.message,
      'reactions': instance.reactions,
      'users': instance.users?.map((e) => e.toJson()).toList(),
    };

const _$MisskeyNotificationTypeEnumMap = {
  MisskeyNotificationType.follow: 'follow',
  MisskeyNotificationType.mention: 'mention',
  MisskeyNotificationType.reply: 'reply',
  MisskeyNotificationType.renote: 'renote',
  MisskeyNotificationType.quote: 'quote',
  MisskeyNotificationType.reaction: 'reaction',
  MisskeyNotificationType.pollEnded: 'pollEnded',
  MisskeyNotificationType.receiveFollowRequest: 'receiveFollowRequest',
  MisskeyNotificationType.followRequestAccepted: 'followRequestAccepted',
  MisskeyNotificationType.achievementEarned: 'achievementEarned',
  MisskeyNotificationType.app: 'app',
  MisskeyNotificationType.roleAssigned: 'roleAssigned',
  MisskeyNotificationType.test: 'test',
  MisskeyNotificationType.note: 'note',
  MisskeyNotificationType.scheduledNotePosted: 'scheduledNotePosted',
  MisskeyNotificationType.scheduledNotePostFailed: 'scheduledNotePostFailed',
  MisskeyNotificationType.chatRoomInvitationReceived:
      'chatRoomInvitationReceived',
  MisskeyNotificationType.exportCompleted: 'exportCompleted',
  MisskeyNotificationType.login: 'login',
  MisskeyNotificationType.createToken: 'createToken',
  MisskeyNotificationType.reactionGrouped: 'reaction:grouped',
  MisskeyNotificationType.renoteGrouped: 'renote:grouped',
  MisskeyNotificationType.unknown: 'unknown',
};
