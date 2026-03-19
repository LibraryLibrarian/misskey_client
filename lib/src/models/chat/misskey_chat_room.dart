import 'package:json_annotation/json_annotation.dart';

import '../misskey_user.dart';

part 'misskey_chat_room.g.dart';

/// A Misskey chat room.
@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$MisskeyChatRoomToJson(this);

  /// The room ID.
  final String id;

  /// The date and time when the room was created.
  final DateTime createdAt;

  /// The user ID of the room owner.
  final String ownerId;

  /// The room owner.
  final MisskeyUser? owner;

  /// The room name.
  final String name;

  /// The room description.
  final String description;

  /// Whether the room is muted by the authenticated user.
  final bool? isMuted;

  /// Whether a pending invitation exists for the authenticated user.
  final bool? invitationExists;
}
