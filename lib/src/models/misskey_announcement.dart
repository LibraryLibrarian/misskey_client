import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';

part 'misskey_announcement.g.dart';

/// A server announcement (element of the `/api/announcements` response).
@JsonSerializable()
class MisskeyAnnouncement {
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
  });

  factory MisskeyAnnouncement.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAnnouncementToJson(this);

  /// The announcement ID.
  final String id;

  /// The creation timestamp.
  @SafeDateTimeConverter()
  final DateTime createdAt;

  /// The last-updated timestamp.
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The announcement title.
  final String title;

  /// The announcement body text.
  final String text;

  /// The image URL.
  final String? imageUrl;

  /// The icon type (`info` / `warning` / `error` / `success`).
  final String icon;

  /// The display style (`dialog` / `normal` / `banner`).
  final String display;

  /// Whether the user must confirm before marking as read.
  @JsonKey(defaultValue: false)
  final bool needConfirmationToRead;

  /// Whether this is a silent announcement (no notification).
  @JsonKey(defaultValue: false)
  final bool silence;

  /// Whether this announcement is targeted at the current user.
  @JsonKey(defaultValue: false)
  final bool forYou;

  /// Whether the announcement has been read (only present when authenticated).
  final bool? isRead;
}
