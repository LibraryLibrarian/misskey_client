import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_user.dart';

part 'misskey_role_user.freezed.dart';
part 'misskey_role_user.g.dart';

/// A user assigned to a role (element of `/api/roles/users` response).
@freezed
@JsonSerializable()
class MisskeyRoleUser with _$MisskeyRoleUser {
  const MisskeyRoleUser({required this.id, required this.user});

  factory MisskeyRoleUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRoleUserFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRoleUserToJson(this);

  /// The role assignment ID.
  @override
  final String id;

  /// The assigned user.
  @override
  final MisskeyUser user;
}
