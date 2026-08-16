import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_user.dart';

part 'misskey_follow_request.freezed.dart';
part 'misskey_follow_request.g.dart';

/// A follow request (element of the `/api/following/requests/list` response).
@freezed
@JsonSerializable()
class MisskeyFollowRequest with _$MisskeyFollowRequest {
  const MisskeyFollowRequest({
    required this.id,
    required this.follower,
    required this.followee,
  });

  factory MisskeyFollowRequest.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFollowRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFollowRequestToJson(this);

  /// The follow request ID.
  @override
  final String id;

  /// The user who sent the follow request.
  @override
  final MisskeyUser follower;

  /// The user who received the follow request.
  @override
  final MisskeyUser followee;
}
