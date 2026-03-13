import 'package:json_annotation/json_annotation.dart';

import 'misskey_note.dart';
import 'misskey_user.dart';

part 'misskey_notification.g.dart';

/// 通知の種別
@JsonEnum()
enum MisskeyNotificationType {
  follow,
  mention,
  reply,
  renote,
  quote,
  reaction,
  pollEnded,
  receiveFollowRequest,
  followRequestAccepted,
  achievementEarned,
  app,
  roleAssigned,
  test,
  note,
  scheduledNotePosted,
  scheduledNotePostFailed,
  chatRoomInvitationReceived,
  exportCompleted,
  login,
  createToken,

  @JsonValue('reaction:grouped')
  reactionGrouped,

  @JsonValue('renote:grouped')
  renoteGrouped,

  /// 未知の通知タイプ
  unknown,
}

/// Misskey の通知
@JsonSerializable(createToJson: false)
class MisskeyNotification {
  const MisskeyNotification({
    required this.id,
    required this.createdAt,
    required this.type,
    this.userId,
    this.user,
    this.note,
    this.reaction,
    this.achievement,
    this.body,
    this.header,
    this.icon,
    this.role,
    this.message,
    this.reactions,
    this.users,
  });

  factory MisskeyNotification.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNotificationFromJson(json);

  final String id;
  final DateTime createdAt;

  @JsonKey(unknownEnumValue: MisskeyNotificationType.unknown)
  final MisskeyNotificationType type;

  final String? userId;
  final MisskeyUser? user;
  final MisskeyNote? note;

  /// リアクション通知の場合のリアクション文字列
  final String? reaction;

  /// 実績通知の場合の実績名
  final String? achievement;

  /// アプリ通知の場合の本文
  final String? body;

  /// アプリ通知の場合のヘッダー
  final String? header;

  /// アプリ通知の場合のアイコンURL
  final String? icon;

  /// ロール割り当て通知の場合のロール情報
  final dynamic role;

  /// フォローリクエスト承認通知の場合のメッセージ
  final String? message;

  /// グループ化リアクション通知の場合のリアクションリスト
  final List<dynamic>? reactions;

  /// グループ化リノート通知の場合のユーザーリスト
  final List<MisskeyUser>? users;
}
