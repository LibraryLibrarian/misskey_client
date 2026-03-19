import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_user_list_membership.g.dart';

/// A user list membership entry.
@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$MisskeyUserListMembershipToJson(this);

  /// The membership ID.
  final String id;

  /// The date and time the membership was created.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The user ID of the member.
  final String userId;

  /// The member's user information.
  final MisskeyUser? user;

  /// Whether to include replies from this member.
  @JsonKey(defaultValue: false)
  final bool withReplies;
}
