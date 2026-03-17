import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_user.dart';

part 'misskey_clip.g.dart';

/// Misskey のクリップ
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

  final String id;
  final DateTime createdAt;

  @SafeDateTimeConverter()
  final DateTime? lastClippedAt;

  final String userId;
  final MisskeyUser? user;
  final String name;
  final String? description;

  @JsonKey(defaultValue: false)
  final bool? isPublic;

  @JsonKey(defaultValue: 0)
  final int? favoritedCount;

  final bool? isFavorited;
}
