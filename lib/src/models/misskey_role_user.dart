import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_role_user.g.dart';

/// ロール所属ユーザー（`/api/roles/users` のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyRoleUser {
  const MisskeyRoleUser({
    required this.id,
    required this.user,
  });

  factory MisskeyRoleUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRoleUserFromJson(json);

  /// ロール割り当てID
  final String id;

  /// ユーザー情報
  final MisskeyUser user;
}
