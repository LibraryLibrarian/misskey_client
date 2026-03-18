import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_flash.g.dart';

/// A Misskey Flash (Play) from the `/api/users/flashs` response.
@JsonSerializable()
class MisskeyFlash {
  const MisskeyFlash({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.title,
    required this.summary,
    required this.script,
    this.user,
    this.visibility,
    this.likedCount = 0,
    this.isLiked,
  });

  factory MisskeyFlash.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFlashFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFlashToJson(this);

  /// The Flash ID.
  final String id;

  /// The creation date and time.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The last update date and time.
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The ID of the user who created this Flash.
  final String userId;

  /// The user who created this Flash.
  final MisskeyUser? user;

  /// The Flash title.
  final String title;

  /// The summary.
  final String summary;

  /// The AiScript source code.
  final String script;

  /// The visibility (`public` or `private`).
  final String? visibility;

  /// The number of likes.
  @JsonKey(defaultValue: 0)
  final int likedCount;

  /// Whether the authenticated user has liked this Flash.
  final bool? isLiked;
}
