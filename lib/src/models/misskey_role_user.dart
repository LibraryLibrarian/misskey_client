import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_role_user.g.dart';

/// A user assigned to a role (element of `/api/roles/users` response).
@JsonSerializable()
class MisskeyRoleUser {
  const MisskeyRoleUser({
    required this.id,
    required this.user,
  });

  factory MisskeyRoleUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRoleUserFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRoleUserToJson(this);

  /// The role assignment ID.
  final String id;

  /// The assigned user.
  final MisskeyUser user;
}
