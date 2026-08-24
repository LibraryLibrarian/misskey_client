import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_note.dart';
import 'misskey_user.dart';

part 'misskey_notification.freezed.dart';
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
@freezed
@JsonSerializable()
class MisskeyNotification with _$MisskeyNotification {
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
  @override
  final String id;

  /// The date and time when this notification was created.
  @override
  final DateTime createdAt;

  /// The type of this notification.
  @JsonKey(unknownEnumValue: MisskeyNotificationType.unknown)
  @override
  final MisskeyNotificationType type;

  /// The ID of the user related to this notification.
  @override
  final String? userId;

  /// The user related to this notification.
  @override
  final MisskeyUser? user;

  /// The note related to this notification.
  @override
  final MisskeyNote? note;

  /// The reaction string for reaction notifications.
  @override
  final String? reaction;

  /// The achievement name for achievement notifications.
  @override
  final String? achievement;

  /// The body text for app notifications.
  @override
  final String? body;

  /// The header text for app notifications.
  @override
  final String? header;

  /// The icon URL for app notifications.
  @override
  final String? icon;

  /// The role information for role assignment notifications.
  @override
  final dynamic role;

  /// The message for follow request accepted notifications.
  @override
  final String? message;

  /// The list of reactions for grouped reaction notifications.
  @override
  final List<dynamic>? reactions;

  /// The list of users for grouped renote notifications.
  @override
  final List<MisskeyUser>? users;
}
