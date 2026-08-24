import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_gallery_post.dart';

part 'misskey_gallery_like.freezed.dart';
part 'misskey_gallery_like.g.dart';

/// A like on a gallery post.
@freezed
@JsonSerializable()
class MisskeyGalleryLike with _$MisskeyGalleryLike {
  const MisskeyGalleryLike({required this.id, required this.post});

  factory MisskeyGalleryLike.fromJson(Map<String, dynamic> json) =>
      _$MisskeyGalleryLikeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyGalleryLikeToJson(this);

  /// The like ID.
  @override
  final String id;

  /// The gallery post that was liked.
  @override
  final MisskeyGalleryPost post;
}
