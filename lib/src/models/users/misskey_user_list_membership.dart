import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_user_list_membership.freezed.dart';
part 'misskey_user_list_membership.g.dart';

/// A user list membership entry.
@freezed
@JsonSerializable()
class MisskeyUserListMembership with _$MisskeyUserListMembership {
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
  @override
  final String id;

  /// The date and time the membership was created.
  @SafeDateTimeConverter()
  @override
  final DateTime? createdAt;

  /// The user ID of the member.
  @override
  final String userId;

  /// The member's user information.
  @override
  final MisskeyUser? user;

  /// Whether to include replies from this member.
  @JsonKey(defaultValue: false)
  @override
  final bool withReplies;
}
