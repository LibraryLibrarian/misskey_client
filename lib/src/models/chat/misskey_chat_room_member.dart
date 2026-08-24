import 'package:freezed_annotation/freezed_annotation.dart';

import '../misskey_user.dart';

part 'misskey_chat_room_member.freezed.dart';
part 'misskey_chat_room_member.g.dart';

/// A chat room member.
@freezed
@JsonSerializable()
class MisskeyChatRoomMember with _$MisskeyChatRoomMember {
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
  @override
  final String id;

  /// The date and time when the member joined.
  @override
  final DateTime createdAt;

  /// The user ID of the member.
  @override
  final String userId;

  /// The member user.
  @override
  final MisskeyUser? user;

  /// The ID of the room the member belongs to.
  @override
  final String roomId;
}
