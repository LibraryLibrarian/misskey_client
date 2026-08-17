import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_converters.dart';

part 'misskey_announcement.freezed.dart';
part 'misskey_announcement.g.dart';

/// A server announcement (element of the `/api/announcements` response).
@freezed
@JsonSerializable()
class MisskeyAnnouncement with _$MisskeyAnnouncement {
  const MisskeyAnnouncement({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.text,
    required this.icon,
    required this.display,
    this.updatedAt,
    this.imageUrl,
    this.needConfirmationToRead = false,
    this.silence = false,
    this.forYou = false,
    this.isRead,
    this.isActive,
    this.forExistingUsers,
    this.userId,
  });

  factory MisskeyAnnouncement.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAnnouncementToJson(this);

  /// The announcement ID.
  @override
  final String id;

  /// The creation timestamp.
  @SafeDateTimeConverter()
  @override
  final DateTime createdAt;

  /// The last-updated timestamp.
  @SafeDateTimeConverter()
  @override
  final DateTime? updatedAt;

  /// The announcement title.
  @override
  final String title;

  /// The announcement body text.
  @override
  final String text;

  /// The image URL.
  @override
  final String? imageUrl;

  /// The icon type (`info` / `warning` / `error` / `success`).
  @override
  final String icon;

  /// The display style (`dialog` / `normal` / `banner`).
  @override
  final String display;

  /// Whether the user must confirm before marking as read.
  @JsonKey(defaultValue: false)
  @override
  final bool needConfirmationToRead;

  /// Whether this is a silent announcement (no notification).
  @JsonKey(defaultValue: false)
  @override
  final bool silence;

  /// Whether this announcement is targeted at the current user.
  @JsonKey(defaultValue: false)
  @override
  final bool forYou;

  /// Whether the announcement has been read (only present when authenticated).
  @override
  final bool? isRead;

  /// Whether this announcement is currently active.
  @JsonKey(defaultValue: true)
  @override
  final bool? isActive;

  /// Whether this announcement is shown only to existing users at the time
  /// of creation.
  @JsonKey(defaultValue: false)
  @override
  final bool? forExistingUsers;

  /// The user ID this announcement is targeted at, or null for all users.
  @override
  final String? userId;
}
