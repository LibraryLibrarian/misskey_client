import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_user_list_membership.g.dart';

/// ユーザーリストのメンバーシップ情報
@JsonSerializable(createToJson: false)
class MisskeyUserListMembership {
  const MisskeyUserListMembership({
    required this.id,
    required this.createdAt,
    required this.userId,
    this.user,
    this.withReplies = false,
  });

  factory MisskeyUserListMembership.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserListMembershipFromJson(json);

  final String id;

  @SafeDateTimeConverter()
  final DateTime? createdAt;

  final String userId;

  final MisskeyUser? user;

  /// リプライを含めるかどうか
  @JsonKey(defaultValue: false)
  final bool withReplies;
}
