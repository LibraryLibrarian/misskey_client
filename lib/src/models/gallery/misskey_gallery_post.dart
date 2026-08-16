import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';
import '../misskey_drive_file.dart';
import '../misskey_user.dart';

part 'misskey_gallery_post.freezed.dart';
part 'misskey_gallery_post.g.dart';

/// A gallery post.
@freezed
@JsonSerializable()
class MisskeyGalleryPost with _$MisskeyGalleryPost {
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
  @override
  final String id;

  /// The date and time when the post was created.
  @SafeDateTimeConverter()
  @override
  final DateTime createdAt;

  /// The date and time when the post was last updated.
  @SafeDateTimeConverter()
  @override
  final DateTime updatedAt;

  /// The user ID of the post author.
  @override
  final String userId;

  /// The post author.
  @override
  final MisskeyUser? user;

  /// The post title (up to 256 characters).
  @override
  final String title;

  /// The post description (up to 2048 characters).
  @override
  final String? description;

  /// The list of attached file IDs.
  @override
  final List<String> fileIds;

  /// The list of attached file objects.
  @override
  final List<MisskeyDriveFile> files;

  /// The list of tags (may be absent from the response when empty).
  @override
  final List<String> tags;

  /// Whether the post contains sensitive content.
  @override
  final bool isSensitive;

  /// The number of likes.
  @override
  final int likedCount;

  /// Whether the authenticated user has liked this post.
  @override
  final bool? isLiked;
}
