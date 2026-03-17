import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_following.g.dart';

/// フォロー関係（`/api/users/followers` / `/api/users/following` のレスポンス要素）
@JsonSerializable(createToJson: false)
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

  final String id;
  final DateTime createdAt;
  final String followeeId;
  final String followerId;
  final MisskeyUser? followee;
  final MisskeyUser? follower;
}
