import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_user.dart';

part 'misskey_clip.g.dart';

/// A Misskey clip (bookmarked collection of notes).
@JsonSerializable()
class MisskeyClip {
  const MisskeyClip({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.name,
    this.lastClippedAt,
    this.user,
    this.description,
    this.isPublic,
    this.favoritedCount,
    this.isFavorited,
  });

  factory MisskeyClip.fromJson(Map<String, dynamic> json) =>
      _$MisskeyClipFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyClipToJson(this);

  /// The clip ID.
  final String id;

  /// The creation timestamp.
  final DateTime createdAt;

  /// The timestamp of the last note clipped.
  @SafeDateTimeConverter()
  final DateTime? lastClippedAt;

  /// The owner user's ID.
  final String userId;

  /// The owner user.
  final MisskeyUser? user;

  /// The clip name.
  final String name;

  /// The clip description.
  final String? description;

  /// Whether the clip is public.
  @JsonKey(defaultValue: false)
  final bool? isPublic;

  /// The number of users who favorited this clip.
  @JsonKey(defaultValue: 0)
  final int? favoritedCount;

  /// Whether the current user has favorited this clip.
  final bool? isFavorited;
}
