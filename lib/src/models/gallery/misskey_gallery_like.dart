import 'package:json_annotation/json_annotation.dart';

import 'misskey_gallery_post.dart';

part 'misskey_gallery_like.g.dart';

/// ギャラリー投稿へのいいね情報
@JsonSerializable(createToJson: false)
class MisskeyGalleryLike {
  const MisskeyGalleryLike({
    required this.id,
    required this.post,
  });

  factory MisskeyGalleryLike.fromJson(Map<String, dynamic> json) =>
      _$MisskeyGalleryLikeFromJson(json);

  /// いいねのID
  final String id;

  /// いいねしたギャラリー投稿
  final MisskeyGalleryPost post;
}
