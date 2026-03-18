import 'package:json_annotation/json_annotation.dart';

import '../misskey_drive_file.dart';
import '../misskey_user.dart';
import 'misskey_chat_room.dart';

part 'misskey_chat_message.g.dart';

/// A Misskey chat message.
///
/// For direct messages, [toUserId] and [toUser] are set.
/// For room messages, [toRoomId] and [toRoom] are set.
@JsonSerializable()
class MisskeyChatMessage {
  const MisskeyChatMessage({
    required this.id,
    required this.createdAt,
    required this.fromUserId,
    this.fromUser,
    this.toUserId,
    this.toUser,
    this.toRoomId,
    this.toRoom,
    this.text,
    this.fileId,
    this.file,
    this.isRead,
    required this.reactions,
  });

  factory MisskeyChatMessage.fromJson(Map<String, dynamic> json) =>
      _$MisskeyChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyChatMessageToJson(this);

  /// The message ID.
  final String id;

  /// The date and time when the message was created.
  final DateTime createdAt;

  /// The user ID of the sender.
  final String fromUserId;

  /// The sender user.
  final MisskeyUser? fromUser;

  /// The recipient user ID for direct messages.
  final String? toUserId;

  /// The recipient user for direct messages.
  final MisskeyUser? toUser;

  /// The destination room ID for room messages.
  final String? toRoomId;

  /// The destination room for room messages.
  final MisskeyChatRoom? toRoom;

  /// The message body text.
  final String? text;

  /// The attached file ID.
  final String? fileId;

  /// The attached file.
  final MisskeyDriveFile? file;

  /// Whether the message has been read by the authenticated user.
  final bool? isRead;

  /// The list of reactions on this message.
  final List<MisskeyChatMessageReaction> reactions;
}

/// A reaction on a chat message.
@JsonSerializable()
class MisskeyChatMessageReaction {
  const MisskeyChatMessageReaction({
    required this.reaction,
    this.user,
  });

  factory MisskeyChatMessageReaction.fromJson(Map<String, dynamic> json) =>
      _$MisskeyChatMessageReactionFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyChatMessageReactionToJson(this);

  /// The reaction string (Unicode emoji or custom emoji code).
  final String reaction;

  /// The user who reacted.
  final MisskeyUser? user;
}
