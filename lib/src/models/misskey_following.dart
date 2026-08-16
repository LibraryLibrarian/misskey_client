import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_user.dart';

part 'misskey_following.freezed.dart';
part 'misskey_following.g.dart';

/// A follow relationship (element of `/api/users/followers` and
/// `/api/users/following` responses).
@freezed
@JsonSerializable()
class MisskeyFollowing with _$MisskeyFollowing {
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
  @override
  final String id;

  /// The creation timestamp.
  @override
  final DateTime createdAt;

  /// The followed user's ID.
  @override
  final String followeeId;

  /// The follower user's ID.
  @override
  final String followerId;

  /// The followed user.
  @override
  final MisskeyUser? followee;

  /// The follower user.
  @override
  final MisskeyUser? follower;
}
