import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';

part 'misskey_chat_room.g.dart';

/// Misskey チャットルーム
@JsonSerializable(createToJson: false)
class MisskeyChatRoom {
  const MisskeyChatRoom({
    required this.id,
    required this.createdAt,
    required this.ownerId,
    this.owner,
    required this.name,
    required this.description,
    this.isMuted,
    this.invitationExists,
  });

  factory MisskeyChatRoom.fromJson(Map<String, dynamic> json) =>
      _$MisskeyChatRoomFromJson(json);

  final String id;
  final DateTime createdAt;
  final String ownerId;
  final MisskeyUser? owner;
  final String name;
  final String description;
  final bool? isMuted;
  final bool? invitationExists;
}
