import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_admin_avatar_decoration.freezed.dart';
part 'misskey_admin_avatar_decoration.g.dart';

/// An avatar decoration as managed by administrators
/// (`/api/admin/avatar-decorations/*` responses).
///
/// Unlike `AvatarDecoration` (the per-user applied decoration), this
/// represents the decoration definition registered on the instance.
@freezed
@JsonSerializable()
class MisskeyAdminAvatarDecoration with _$MisskeyAdminAvatarDecoration {
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
  @override
  final String id;

  /// The date and time when the decoration was created.
  @SafeDateTimeConverter()
  @override
  final DateTime? createdAt;

  /// The date and time when the decoration was last updated.
  @SafeDateTimeConverter()
  @override
  final DateTime? updatedAt;

  /// The decoration name.
  @override
  final String name;

  /// The decoration description.
  @override
  final String description;

  /// The decoration image URL.
  @override
  final String url;

  /// The role IDs allowed to use this decoration (empty means everyone).
  @override
  final List<String>? roleIdsThatCanBeUsedThisDecoration;

  /// The category, if any.
  @override
  final String? category;
}
