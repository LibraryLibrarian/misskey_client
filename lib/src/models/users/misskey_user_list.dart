import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_user_list.g.dart';

/// A user list from the `/api/users/lists/*` endpoints.
@JsonSerializable()
class MisskeyUserList {
  const MisskeyUserList({
    required this.id,
    required this.createdAt,
    required this.name,
    this.userIds = const [],
    this.isPublic = false,
    this.likedCount,
    this.isLiked,
  });

  factory MisskeyUserList.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserListFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserListToJson(this);

  /// The list ID.
  final String id;

  /// The creation date and time.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The list name.
  final String name;

  /// The array of user IDs in the list.
  @JsonKey(defaultValue: <String>[])
  final List<String> userIds;

  /// Whether the list is public.
  @JsonKey(defaultValue: false)
  final bool isPublic;

  /// The number of likes (only when `forPublic: true`).
  final int? likedCount;

  /// Whether the authenticated user has liked this list
  /// (only when `forPublic: true`).
  final bool? isLiked;
}
