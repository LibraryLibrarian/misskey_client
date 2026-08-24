import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_role.freezed.dart';
part 'misskey_role.g.dart';

/// A role (`/api/roles/show` and related responses).
@freezed
@JsonSerializable()
class MisskeyRole with _$MisskeyRole {
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
    this.isAdministrator,
    this.isModerator,
    this.policies,
    this.condFormula,
    this.preserveAssignmentOnMoveAccount,
  });

  factory MisskeyRole.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRoleFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRoleToJson(this);

  /// The unique identifier of this role.
  @override
  final String id;

  /// The date and time when this role was created.
  @override
  final DateTime createdAt;

  /// The date and time when this role was last updated.
  @override
  final DateTime updatedAt;

  /// The name of this role.
  @override
  final String name;

  /// The description of this role.
  @override
  final String description;

  /// The theme color (e.g. `#ff0000`).
  @override
  final String? color;

  /// The icon URL.
  @override
  final String? iconUrl;

  /// The assignment method (`manual` / `conditional`).
  @override
  final String target;

  /// Whether this is a public role.
  @override
  final bool isPublic;

  /// Whether this role appears in the discoverable roles list.
  @override
  final bool isExplorable;

  /// Whether this role is displayed as a badge.
  @override
  final bool asBadge;

  /// Whether moderators can edit members of this role.
  @override
  final bool canEditMembersByModerator;

  /// The display order.
  @override
  final int displayOrder;

  /// The number of users assigned to this role.
  @override
  final int usersCount;

  /// Whether this role grants administrator privileges.
  @JsonKey(defaultValue: false)
  @override
  final bool? isAdministrator;

  /// Whether this role grants moderator privileges.
  @JsonKey(defaultValue: false)
  @override
  final bool? isModerator;

  /// The policy overrides applied by this role.
  @override
  final Map<String, dynamic>? policies;

  /// The conditional assignment formula (used when [target] is `conditional`).
  @override
  final Map<String, dynamic>? condFormula;

  /// Whether the role assignment is preserved when the user moves their
  /// account.
  @JsonKey(defaultValue: false)
  @override
  final bool? preserveAssignmentOnMoveAccount;
}
