import 'package:freezed_annotation/freezed_annotation.dart';

import '../misskey_user.dart';

part 'misskey_chat_room.freezed.dart';
part 'misskey_chat_room.g.dart';

/// A Misskey chat room.
@freezed
@JsonSerializable()
class MisskeyChatRoom with _$MisskeyChatRoom {
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
  @override
  final String id;

  /// The date and time when the room was created.
  @override
  final DateTime createdAt;

  /// The user ID of the room owner.
  @override
  final String ownerId;

  /// The room owner.
  @override
  final MisskeyUser? owner;

  /// The room name.
  @override
  final String name;

  /// The room description.
  @override
  final String description;

  /// Whether the room is muted by the authenticated user.
  @override
  final bool? isMuted;

  /// Whether a pending invitation exists for the authenticated user.
  @override
  final bool? invitationExists;
}
