import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_admin_avatar_decoration.g.dart';

/// An avatar decoration as managed by administrators
/// (`/api/admin/avatar-decorations/*` responses).
///
/// Unlike `AvatarDecoration` (the per-user applied decoration), this
/// represents the decoration definition registered on the instance.
@JsonSerializable()
class MisskeyAdminAvatarDecoration {
  const MisskeyAdminAvatarDecoration({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.name,
    required this.description,
    required this.url,
    this.roleIdsThatCanBeUsedThisDecoration,
    this.category,
  });

  factory MisskeyAdminAvatarDecoration.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdminAvatarDecorationFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdminAvatarDecorationToJson(this);

  /// The decoration ID.
  final String id;

  /// The date and time when the decoration was created.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The date and time when the decoration was last updated.
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The decoration name.
  final String name;

  /// The decoration description.
  final String description;

  /// The decoration image URL.
  final String url;

  /// The role IDs allowed to use this decoration (empty means everyone).
  final List<String>? roleIdsThatCanBeUsedThisDecoration;

  /// The category, if any.
  final String? category;
}
