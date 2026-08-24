import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_user_list.freezed.dart';
part 'misskey_user_list.g.dart';

/// A user list from the `/api/users/lists/*` endpoints.
@freezed
@JsonSerializable()
class MisskeyUserList with _$MisskeyUserList {
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
  @override
  final String id;

  /// The creation date and time.
  @SafeDateTimeConverter()
  @override
  final DateTime? createdAt;

  /// The list name.
  @override
  final String name;

  /// The array of user IDs in the list.
  @override
  final List<String> userIds;

  /// Whether the list is public.
  @override
  final bool isPublic;

  /// The number of likes (only when `forPublic: true`).
  @override
  final int? likedCount;

  /// Whether the authenticated user has liked this list
  /// (only when `forPublic: true`).
  @override
  final bool? isLiked;
}
