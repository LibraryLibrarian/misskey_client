// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_chat_room_invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyChatRoomInvitation _$MisskeyChatRoomInvitationFromJson(
        Map<String, dynamic> json) =>
    MisskeyChatRoomInvitation(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      roomId: json['roomId'] as String,
      room: json['room'] == null
          ? null
          : MisskeyChatRoom.fromJson(json['room'] as Map<String, dynamic>),
      userId: json['userId'] as String,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyChatRoomInvitationToJson(
        MisskeyChatRoomInvitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'roomId': instance.roomId,
      'room': instance.room,
      'userId': instance.userId,
      'user': instance.user,
    };
