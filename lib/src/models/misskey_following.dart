import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_following.g.dart';

/// A follow relationship (element of `/api/users/followers` and
/// `/api/users/following` responses).
@JsonSerializable()
class MisskeyFollowing {
  const MisskeyFollowing({
    required this.id,
    required this.createdAt,
    required this.followeeId,
    required this.followerId,
    this.followee,
    this.follower,
  });

  factory MisskeyFollowing.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFollowingFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFollowingToJson(this);

  /// The follow record ID.
  final String id;

  /// The creation timestamp.
  final DateTime createdAt;

  /// The followed user's ID.
  final String followeeId;

  /// The follower user's ID.
  final String followerId;

  /// The followed user.
  final MisskeyUser? followee;

  /// The follower user.
  final MisskeyUser? follower;
}
