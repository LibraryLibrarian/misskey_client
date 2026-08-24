import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_admin_announcement.freezed.dart';
part 'misskey_admin_announcement.g.dart';

/// An announcement as seen by administrators
/// (`/api/admin/announcements/*` responses).
///
/// Unlike the user-facing `MisskeyAnnouncement`, this includes management
/// fields such as [isActive], [userId], and the [reads] count.
@freezed
@JsonSerializable()
class MisskeyAdminAnnouncement with _$MisskeyAdminAnnouncement {
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
  @override
  final String id;

  /// The date and time when the announcement was created.
  @SafeDateTimeConverter()
  @override
  final DateTime? createdAt;

  /// The date and time when the announcement was last updated.
  @SafeDateTimeConverter()
  @override
  final DateTime? updatedAt;

  /// The announcement title.
  @override
  final String title;

  /// The announcement body text.
  @override
  final String text;

  /// The image URL, if any.
  @override
  final String? imageUrl;

  /// The icon type (`info`, `warning`, `error`, or `success`).
  @override
  final String? icon;

  /// The display style (`normal`, `banner`, or `dialog`).
  @override
  final String? display;

  /// Whether the announcement is active.
  @override
  final bool? isActive;

  /// Whether the announcement targets existing users only.
  @override
  final bool? forExistingUsers;

  /// Whether notification delivery is suppressed.
  @override
  final bool? silence;

  /// Whether users must confirm reading the announcement.
  @override
  final bool? needConfirmationToRead;

  /// The target user ID for user-specific announcements.
  @override
  final String? userId;

  /// The number of users who have read this announcement.
  @override
  final int? reads;
}
