import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';

part 'misskey_chat_room_member.g.dart';

/// チャットルームメンバー
@JsonSerializable(createToJson: false)
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

  final String id;
  final DateTime createdAt;
  final String userId;
  final MisskeyUser? user;
  final String roomId;
}
