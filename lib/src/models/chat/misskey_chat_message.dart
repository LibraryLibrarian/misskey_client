import 'package:json_annotation/json_annotation.dart';

import '../misskey_drive_file.dart';
import '../misskey_user.dart';
import 'misskey_chat_room.dart';

part 'misskey_chat_message.g.dart';

/// Misskey チャットメッセージ
///
/// 1対1メッセージの場合は [toUserId]/[toUser] が設定され、
/// ルームメッセージの場合は [toRoomId]/[toRoom] が設定される。
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

  final String id;
  final DateTime createdAt;
  final String fromUserId;
  final MisskeyUser? fromUser;

  /// 1対1チャットの宛先ユーザーID
  final String? toUserId;

  /// 1対1チャットの宛先ユーザー
  final MisskeyUser? toUser;

  /// ルームチャットの宛先ルームID
  final String? toRoomId;

  /// ルームチャットの宛先ルーム
  final MisskeyChatRoom? toRoom;

  /// メッセージ本文
  final String? text;

  /// 添付ファイルID
  final String? fileId;

  /// 添付ファイル
  final MisskeyDriveFile? file;

  /// 既読かどうか（認証ユーザーに対する状態）
  final bool? isRead;

  /// リアクション一覧
  final List<MisskeyChatMessageReaction> reactions;
}

/// チャットメッセージに付与されたリアクション
@JsonSerializable()
class MisskeyChatMessageReaction {
  const MisskeyChatMessageReaction({
    required this.reaction,
    this.user,
  });

  factory MisskeyChatMessageReaction.fromJson(Map<String, dynamic> json) =>
      _$MisskeyChatMessageReactionFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyChatMessageReactionToJson(this);

  /// リアクション文字列（Unicode絵文字またはカスタム絵文字コード）
  final String reaction;

  /// リアクションしたユーザー
  final MisskeyUser? user;
}
