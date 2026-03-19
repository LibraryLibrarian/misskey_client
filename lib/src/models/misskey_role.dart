import 'package:json_annotation/json_annotation.dart';

part 'misskey_role.g.dart';

/// A role (`/api/roles/show` and related responses).
@JsonSerializable()
class MisskeyRole {
  const MisskeyRole({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    this.color,
    this.iconUrl,
    required this.target,
    required this.isPublic,
    required this.isExplorable,
    required this.asBadge,
    required this.canEditMembersByModerator,
    required this.displayOrder,
    required this.usersCount,
  });

  factory MisskeyRole.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRoleFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRoleToJson(this);

  /// The unique identifier of this role.
  final String id;

  /// The date and time when this role was created.
  final DateTime createdAt;

  /// The date and time when this role was last updated.
  final DateTime updatedAt;

  /// The name of this role.
  final String name;

  /// The description of this role.
  final String description;

  /// The theme color (e.g. `#ff0000`).
  final String? color;

  /// The icon URL.
  final String? iconUrl;

  /// The assignment method (`manual` / `conditional`).
  final String target;

  /// Whether this is a public role.
  final bool isPublic;

  /// Whether this role appears in the discoverable roles list.
  final bool isExplorable;

  /// Whether this role is displayed as a badge.
  final bool asBadge;

  /// Whether moderators can edit members of this role.
  final bool canEditMembersByModerator;

  /// The display order.
  final int displayOrder;

  /// The number of users assigned to this role.
  final int usersCount;
}
