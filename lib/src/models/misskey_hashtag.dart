import 'package:json_annotation/json_annotation.dart';

part 'misskey_hashtag.g.dart';

/// Hashtag information (response from `/api/hashtags/show`, etc.).
@JsonSerializable()
class MisskeyHashtag {
  const MisskeyHashtag({
    required this.tag,
    required this.mentionedUsersCount,
    required this.mentionedLocalUsersCount,
    required this.mentionedRemoteUsersCount,
    required this.attachedUsersCount,
    required this.attachedLocalUsersCount,
    required this.attachedRemoteUsersCount,
  });

  factory MisskeyHashtag.fromJson(Map<String, dynamic> json) =>
      _$MisskeyHashtagFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyHashtagToJson(this);

  /// The hashtag string.
  final String tag;

  /// The total number of users who mentioned this hashtag.
  final int mentionedUsersCount;

  /// The number of local users who mentioned this hashtag.
  final int mentionedLocalUsersCount;

  /// The number of remote users who mentioned this hashtag.
  final int mentionedRemoteUsersCount;

  /// The total number of users who have this hashtag on their profile.
  final int attachedUsersCount;

  /// The number of local users who have this hashtag on their profile.
  final int attachedLocalUsersCount;

  /// The number of remote users who have this hashtag on their profile.
  final int attachedRemoteUsersCount;
}
