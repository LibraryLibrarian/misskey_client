import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';

part 'misskey_chat_room_member.g.dart';

/// A chat room member.
@JsonSerializable()
class MisskeyChatRoomMember {
  const MisskeyChatRoomMember({
    required this.id,
    required this.createdAt,
    required this.userId,
    this.user,
    required this.roomId,
  });

  factory MisskeyChatRoomMember.fromJson(Map<String, dynamic> json) =>
      _$MisskeyChatRoomMemberFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyChatRoomMemberToJson(this);

  /// The membership record ID.
  final String id;

  /// The date and time when the member joined.
  final DateTime createdAt;

  /// The user ID of the member.
  final String userId;

  /// The member user.
  final MisskeyUser? user;

  /// The ID of the room the member belongs to.
  final String roomId;
}
