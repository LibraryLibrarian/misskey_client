import 'package:json_annotation/json_annotation.dart';

import 'misskey_gallery_post.dart';

part 'misskey_gallery_like.g.dart';

/// A like on a gallery post.
@JsonSerializable()
class MisskeyGalleryLike {
  const MisskeyGalleryLike({
    required this.id,
    required this.post,
  });

  factory MisskeyGalleryLike.fromJson(Map<String, dynamic> json) =>
      _$MisskeyGalleryLikeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyGalleryLikeToJson(this);

  /// The like ID.
  final String id;

  /// The gallery post that was liked.
  final MisskeyGalleryPost post;
}
