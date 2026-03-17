import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';
import 'misskey_chat_room.dart';

part 'misskey_chat_room_invitation.g.dart';

/// チャットルーム招待
@JsonSerializable(createToJson: false)
class MisskeyChatRoomInvitation {
  const MisskeyChatRoomInvitation({
    required this.id,
    required this.createdAt,
    required this.roomId,
    this.room,
    required this.userId,
    this.user,
  });

  factory MisskeyChatRoomInvitation.fromJson(Map<String, dynamic> json) =>
      _$MisskeyChatRoomInvitationFromJson(json);

  final String id;
  final DateTime createdAt;
  final String roomId;
  final MisskeyChatRoom? room;
  final String userId;
  final MisskeyUser? user;
}
