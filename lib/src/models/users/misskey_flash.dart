import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_flash.freezed.dart';
part 'misskey_flash.g.dart';

/// A Misskey Flash (Play) from the `/api/users/flashs` response.
@freezed
@JsonSerializable()
class MisskeyFlash with _$MisskeyFlash {
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

  /// The ID of the user who created this Flash.
  @override
  final String userId;

  /// The user who created this Flash.
  @override
  final MisskeyUser? user;

  /// The Flash title.
  @override
  final String title;

  /// The summary.
  @override
  final String summary;

  /// The AiScript source code.
  @override
  final String script;

  /// The visibility (`public` or `private`).
  @override
  final String? visibility;

  /// The number of likes.
  @JsonKey(defaultValue: 0)
  @override
  final int likedCount;

  /// Whether the authenticated user has liked this Flash.
  @override
  final bool? isLiked;
}
