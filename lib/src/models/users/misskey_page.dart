import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';
import '../misskey_drive_file.dart';
import '../misskey_user.dart';

part 'misskey_page.freezed.dart';
part 'misskey_page.g.dart';

/// A Misskey Page from the `/api/users/pages` response.
@freezed
@JsonSerializable()
class MisskeyPage with _$MisskeyPage {
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
  @override
  final String id;

  /// The creation date and time.
  @SafeDateTimeConverter()
  @override
  final DateTime? createdAt;

  /// The last update date and time.
  @SafeDateTimeConverter()
  @override
  final DateTime? updatedAt;

  /// The ID of the user who created this page.
  @override
  final String userId;

  /// The user who created this page.
  @override
  final MisskeyUser? user;

  /// The page title.
  @override
  final String title;

  /// The URL path name of the page.
  @override
  final String name;

  /// The summary.
  @override
  final String? summary;

  /// The page content as an array of blocks.
  @override
  final List<dynamic>? content;

  /// The page variables.
  @override
  final List<dynamic>? variables;

  /// Whether the content is center-aligned.
  @JsonKey(defaultValue: false)
  @override
  final bool alignCenter;

  /// Whether to hide the title when pinned.
  @JsonKey(defaultValue: false)
  @override
  final bool hideTitleWhenPinned;

  /// The font setting.
  @override
  final String? font;

  /// The page script.
  @override
  final String? script;

  /// The file ID of the eye-catching image.
  @override
  final String? eyeCatchingImageId;

  /// The eye-catching image.
  @override
  final MisskeyDriveFile? eyeCatchingImage;

  /// Files automatically collected from image blocks in the content.
  @override
  final List<MisskeyDriveFile> attachedFiles;

  /// The number of likes.
  @JsonKey(defaultValue: 0)
  @override
  final int likedCount;

  /// Whether the authenticated user has liked this page.
  @override
  final bool? isLiked;
}
