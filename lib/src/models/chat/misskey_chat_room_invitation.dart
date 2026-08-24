import 'package:freezed_annotation/freezed_annotation.dart';

import '../misskey_user.dart';
import 'misskey_chat_room.dart';

part 'misskey_chat_room_invitation.freezed.dart';
part 'misskey_chat_room_invitation.g.dart';

/// A chat room invitation.
@freezed
@JsonSerializable()
class MisskeyChatRoomInvitation with _$MisskeyChatRoomInvitation {
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
  @override
  final String id;

  /// The date and time when the invitation was created.
  @override
  final DateTime createdAt;

  /// The ID of the room being invited to.
  @override
  final String roomId;

  /// The room being invited to.
  @override
  final MisskeyChatRoom? room;

  /// The user ID of the invitee.
  @override
  final String userId;

  /// The invitee user.
  @override
  final MisskeyUser? user;
}
