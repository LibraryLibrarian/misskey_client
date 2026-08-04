import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_admin_announcement.g.dart';

/// An announcement as seen by administrators
/// (`/api/admin/announcements/*` responses).
///
/// Unlike the user-facing `MisskeyAnnouncement`, this includes management
/// fields such as [isActive], [userId], and the [reads] count.
@JsonSerializable()
class MisskeyAdminAnnouncement {
  const MisskeyAdminAnnouncement({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.title,
    required this.text,
    this.imageUrl,
    this.icon,
    this.display,
    this.isActive,
    this.forExistingUsers,
    this.silence,
    this.needConfirmationToRead,
    this.userId,
    this.reads,
  });

  factory MisskeyAdminAnnouncement.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdminAnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdminAnnouncementToJson(this);

  /// The announcement ID.
  final String id;

  /// The date and time when the announcement was created.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The date and time when the announcement was last updated.
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The announcement title.
  final String title;

  /// The announcement body text.
  final String text;

  /// The image URL, if any.
  final String? imageUrl;

  /// The icon type (`info`, `warning`, `error`, or `success`).
  final String? icon;

  /// The display style (`normal`, `banner`, or `dialog`).
  final String? display;

  /// Whether the announcement is active.
  final bool? isActive;

  /// Whether the announcement targets existing users only.
  final bool? forExistingUsers;

  /// Whether notification delivery is suppressed.
  final bool? silence;

  /// Whether users must confirm reading the announcement.
  final bool? needConfirmationToRead;

  /// The target user ID for user-specific announcements.
  final String? userId;

  /// The number of users who have read this announcement.
  final int? reads;
}
