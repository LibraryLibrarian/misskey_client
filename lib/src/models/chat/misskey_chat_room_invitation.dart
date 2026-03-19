import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';
import 'misskey_chat_room.dart';

part 'misskey_chat_room_invitation.g.dart';

/// A chat room invitation.
@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$MisskeyChatRoomInvitationToJson(this);

  /// The invitation ID.
  final String id;

  /// The date and time when the invitation was created.
  final DateTime createdAt;

  /// The ID of the room being invited to.
  final String roomId;

  /// The room being invited to.
  final MisskeyChatRoom? room;

  /// The user ID of the invitee.
  final String userId;

  /// The invitee user.
  final MisskeyUser? user;
}
