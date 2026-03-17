// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyChatMessage _$MisskeyChatMessageFromJson(Map<String, dynamic> json) =>
    MisskeyChatMessage(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      fromUserId: json['fromUserId'] as String,
      fromUser: json['fromUser'] == null
          ? null
          : MisskeyUser.fromJson(json['fromUser'] as Map<String, dynamic>),
      toUserId: json['toUserId'] as String?,
      toUser: json['toUser'] == null
          ? null
          : MisskeyUser.fromJson(json['toUser'] as Map<String, dynamic>),
      toRoomId: json['toRoomId'] as String?,
      toRoom: json['toRoom'] == null
          ? null
          : MisskeyChatRoom.fromJson(json['toRoom'] as Map<String, dynamic>),
      text: json['text'] as String?,
      fileId: json['fileId'] as String?,
      file: json['file'] == null
          ? null
          : MisskeyDriveFile.fromJson(json['file'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool?,
      reactions: (json['reactions'] as List<dynamic>)
          .map((e) =>
              MisskeyChatMessageReaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

MisskeyChatMessageReaction _$MisskeyChatMessageReactionFromJson(
        Map<String, dynamic> json) =>
    MisskeyChatMessageReaction(
      reaction: json['reaction'] as String,
      user: json['user'] == null
          ? null
          : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    );
