// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyChatRoom _$MisskeyChatRoomFromJson(Map<String, dynamic> json) =>
    MisskeyChatRoom(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      ownerId: json['ownerId'] as String,
      owner: json['owner'] == null
          ? null
          : MisskeyUser.fromJson(json['owner'] as Map<String, dynamic>),
      name: json['name'] as String,
      description: json['description'] as String,
      isMuted: json['isMuted'] as bool?,
      invitationExists: json['invitationExists'] as bool?,
    );

Map<String, dynamic> _$MisskeyChatRoomToJson(MisskeyChatRoom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'ownerId': instance.ownerId,
      'owner': instance.owner?.toJson(),
      'name': instance.name,
      'description': instance.description,
      'isMuted': instance.isMuted,
      'invitationExists': instance.invitationExists,
    };
