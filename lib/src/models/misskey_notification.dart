import 'package:json_annotation/json_annotation.dart';

import 'misskey_note.dart';
import 'misskey_user.dart';

part 'misskey_notification.g.dart';

/// The type of a notification.
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

  /// An unknown notification type.
  unknown,
}

/// A Misskey notification.
@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$MisskeyNotificationToJson(this);

  /// The unique identifier of this notification.
  final String id;

  /// The date and time when this notification was created.
  final DateTime createdAt;

  /// The type of this notification.
  @JsonKey(unknownEnumValue: MisskeyNotificationType.unknown)
  final MisskeyNotificationType type;

  /// The ID of the user related to this notification.
  final String? userId;

  /// The user related to this notification.
  final MisskeyUser? user;

  /// The note related to this notification.
  final MisskeyNote? note;

  /// The reaction string for reaction notifications.
  final String? reaction;

  /// The achievement name for achievement notifications.
  final String? achievement;

  /// The body text for app notifications.
  final String? body;

  /// The header text for app notifications.
  final String? header;

  /// The icon URL for app notifications.
  final String? icon;

  /// The role information for role assignment notifications.
  final dynamic role;

  /// The message for follow request accepted notifications.
  final String? message;

  /// The list of reactions for grouped reaction notifications.
  final List<dynamic>? reactions;

  /// The list of users for grouped renote notifications.
  final List<MisskeyUser>? users;
}
