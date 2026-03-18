import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_drive_file.dart';
import '../misskey_user.dart';

part 'misskey_gallery_post.g.dart';

/// A gallery post.
@JsonSerializable()
class MisskeyGalleryPost {
  const MisskeyGalleryPost({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.title,
    this.user,
    this.description,
    this.fileIds = const [],
    this.files = const [],
    this.tags = const [],
    this.isSensitive = false,
    this.likedCount = 0,
    this.isLiked,
  });

  factory MisskeyGalleryPost.fromJson(Map<String, dynamic> json) =>
      _$MisskeyGalleryPostFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyGalleryPostToJson(this);

  /// The post ID.
  final String id;

  /// The date and time when the post was created.
  @SafeDateTimeConverter()
  final DateTime createdAt;

  /// The date and time when the post was last updated.
  @SafeDateTimeConverter()
  final DateTime updatedAt;

  /// The user ID of the post author.
  final String userId;

  /// The post author.
  final MisskeyUser? user;

  /// The post title (up to 256 characters).
  final String title;

  /// The post description (up to 2048 characters).
  final String? description;

  /// The list of attached file IDs.
  final List<String> fileIds;

  /// The list of attached file objects.
  final List<MisskeyDriveFile> files;

  /// The list of tags (may be absent from the response when empty).
  final List<String> tags;

  /// Whether the post contains sensitive content.
  final bool isSensitive;

  /// The number of likes.
  final int likedCount;

  /// Whether the authenticated user has liked this post.
  final bool? isLiked;
}
