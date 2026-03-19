import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_follow_request.g.dart';

/// A follow request (element of the `/api/following/requests/list` response).
@JsonSerializable()
class MisskeyFollowRequest {
  const MisskeyFollowRequest({
    required this.id,
    required this.follower,
    required this.followee,
  });

  factory MisskeyFollowRequest.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFollowRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFollowRequestToJson(this);

  /// The follow request ID.
  final String id;

  /// The user who sent the follow request.
  final MisskeyUser follower;

  /// The user who received the follow request.
  final MisskeyUser followee;
}
