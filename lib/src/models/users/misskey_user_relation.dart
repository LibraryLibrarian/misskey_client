import 'package:json_annotation/json_annotation.dart';

part 'misskey_user_relation.g.dart';

/// The relationship between users, returned by `/api/users/relation`.
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

  /// The target user's ID.
  final String id;

  /// Whether you are following this user.
  @JsonKey(defaultValue: false)
  final bool isFollowing;

  /// Whether you have a pending follow request to this user.
  @JsonKey(defaultValue: false)
  final bool hasPendingFollowRequestFromYou;

  /// Whether this user has a pending follow request to you.
  @JsonKey(defaultValue: false)
  final bool hasPendingFollowRequestToYou;

  /// Whether this user is following you.
  @JsonKey(defaultValue: false)
  final bool isFollowed;

  /// Whether you are blocking this user.
  @JsonKey(defaultValue: false)
  final bool isBlocking;

  /// Whether this user is blocking you.
  @JsonKey(defaultValue: false)
  final bool isBlocked;

  /// Whether you are muting this user.
  @JsonKey(defaultValue: false)
  final bool isMuted;

  /// Whether you are muting renotes from this user.
  @JsonKey(defaultValue: false)
  final bool isRenoteMuted;
}
