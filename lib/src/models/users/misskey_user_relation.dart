import 'package:json_annotation/json_annotation.dart';

part 'misskey_user_relation.g.dart';

/// ユーザー間の関係情報（`/api/users/relation` のレスポンス）
@JsonSerializable()
class MisskeyUserRelation {
  const MisskeyUserRelation({
    required this.id,
    this.isFollowing = false,
    this.hasPendingFollowRequestFromYou = false,
    this.hasPendingFollowRequestToYou = false,
    this.isFollowed = false,
    this.isBlocking = false,
    this.isBlocked = false,
    this.isMuted = false,
    this.isRenoteMuted = false,
  });

  factory MisskeyUserRelation.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserRelationFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserRelationToJson(this);

  /// 対象ユーザーのID
  final String id;

  /// フォローしているか
  @JsonKey(defaultValue: false)
  final bool isFollowing;

  /// こちらからフォローリクエストを送信中か
  @JsonKey(defaultValue: false)
  final bool hasPendingFollowRequestFromYou;

  /// 相手からフォローリクエストを受信中か
  @JsonKey(defaultValue: false)
  final bool hasPendingFollowRequestToYou;

  /// フォローされているか
  @JsonKey(defaultValue: false)
  final bool isFollowed;

  /// ブロックしているか
  @JsonKey(defaultValue: false)
  final bool isBlocking;

  /// ブロックされているか
  @JsonKey(defaultValue: false)
  final bool isBlocked;

  /// ミュートしているか
  @JsonKey(defaultValue: false)
  final bool isMuted;

  /// リノートをミュートしているか
  @JsonKey(defaultValue: false)
  final bool isRenoteMuted;
}
