// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_chat_room_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyChatRoomMember _$MisskeyChatRoomMemberFromJson(
        Map<String, dynamic> json) =>
    MisskeyChatRoomMember(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      roomId: json['roomId'] as String,
    );

Map<String, dynamic> _$MisskeyChatRoomMemberToJson(
        MisskeyChatRoomMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'user': instance.user?.toJson(),
      'roomId': instance.roomId,
    };
