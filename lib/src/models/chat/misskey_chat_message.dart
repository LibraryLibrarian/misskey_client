import 'package:freezed_annotation/freezed_annotation.dart';

import '../misskey_drive_file.dart';
import '../misskey_user.dart';
import 'misskey_chat_room.dart';

part 'misskey_chat_message.freezed.dart';
part 'misskey_chat_message.g.dart';

/// A Misskey chat message.
///
/// For direct messages, [toUserId] and [toUser] are set.
/// For room messages, [toRoomId] and [toRoom] are set.
@freezed
@JsonSerializable()
class MisskeyChatMessage with _$MisskeyChatMessage {
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
  @override
  final String id;

  /// The date and time when the message was created.
  @override
  final DateTime createdAt;

  /// The user ID of the sender.
  @override
  final String fromUserId;

  /// The sender user.
  @override
  final MisskeyUser? fromUser;

  /// The recipient user ID for direct messages.
  @override
  final String? toUserId;

  /// The recipient user for direct messages.
  @override
  final MisskeyUser? toUser;

  /// The destination room ID for room messages.
  @override
  final String? toRoomId;

  /// The destination room for room messages.
  @override
  final MisskeyChatRoom? toRoom;

  /// The message body text.
  @override
  final String? text;

  /// The attached file ID.
  @override
  final String? fileId;

  /// The attached file.
  @override
  final MisskeyDriveFile? file;

  /// Whether the message has been read by the authenticated user.
  @override
  final bool? isRead;

  /// The list of reactions on this message.
  @override
  final List<MisskeyChatMessageReaction> reactions;
}

/// A reaction on a chat message.
@freezed
@JsonSerializable()
class MisskeyChatMessageReaction with _$MisskeyChatMessageReaction {
  const MisskeyChatMessageReaction({required this.reaction, this.user});

  factory MisskeyChatMessageReaction.fromJson(Map<String, dynamic> json) =>
      _$MisskeyChatMessageReactionFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyChatMessageReactionToJson(this);

  /// The reaction string (Unicode emoji or custom emoji code).
  @override
  final String reaction;

  /// The user who reacted.
  @override
  final MisskeyUser? user;
}
