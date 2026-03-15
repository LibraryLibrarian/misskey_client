import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_follow_request.g.dart';

/// フォローリクエスト（`/api/following/requests/list` 等のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyFollowRequest {
  const MisskeyFollowRequest({
    required this.id,
    required this.follower,
    required this.followee,
  });

  factory MisskeyFollowRequest.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFollowRequestFromJson(json);

  final String id;

  /// フォローリクエストの送信者
  final MisskeyUser follower;

  /// フォローリクエストの受信者
  final MisskeyUser followee;
}
