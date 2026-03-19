import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_drive_file.dart';
import '../misskey_user.dart';

part 'misskey_page.g.dart';

/// A Misskey Page from the `/api/users/pages` response.
@JsonSerializable()
class MisskeyPage {
  const MisskeyPage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.title,
    required this.name,
    this.user,
    this.summary,
    this.content,
    this.variables,
    this.alignCenter = false,
    this.hideTitleWhenPinned = false,
    this.font,
    this.script,
    this.eyeCatchingImageId,
    this.eyeCatchingImage,
    this.attachedFiles = const [],
    this.likedCount = 0,
    this.isLiked,
  });

  factory MisskeyPage.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPageFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyPageToJson(this);

  /// The page ID.
  final String id;

  /// The creation date and time.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The last update date and time.
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The ID of the user who created this page.
  final String userId;

  /// The user who created this page.
  final MisskeyUser? user;

  /// The page title.
  final String title;

  /// The URL path name of the page.
  final String name;

  /// The summary.
  final String? summary;

  /// The page content as an array of blocks.
  final List<dynamic>? content;

  /// The page variables.
  final List<dynamic>? variables;

  /// Whether the content is center-aligned.
  @JsonKey(defaultValue: false)
  final bool alignCenter;

  /// Whether to hide the title when pinned.
  @JsonKey(defaultValue: false)
  final bool hideTitleWhenPinned;

  /// The font setting.
  final String? font;

  /// The page script.
  final String? script;

  /// The file ID of the eye-catching image.
  final String? eyeCatchingImageId;

  /// The eye-catching image.
  final MisskeyDriveFile? eyeCatchingImage;

  /// Files automatically collected from image blocks in the content.
  final List<MisskeyDriveFile> attachedFiles;

  /// The number of likes.
  @JsonKey(defaultValue: 0)
  final int likedCount;

  /// Whether the authenticated user has liked this page.
  final bool? isLiked;
}
