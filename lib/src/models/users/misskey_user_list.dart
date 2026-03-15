import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_user_list.g.dart';

/// ユーザーリスト（`/api/users/lists/*` のレスポンス）
@JsonSerializable(createToJson: false)
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

  final String id;

  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// リスト名
  final String name;

  /// リストに含まれるユーザーIDの配列
  @JsonKey(defaultValue: <String>[])
  final List<String> userIds;

  /// 公開リストかどうか
  @JsonKey(defaultValue: false)
  final bool isPublic;

  /// お気に入り数（`forPublic: true` の場合のみ）
  final int? likedCount;

  /// 認証ユーザーがお気に入り済みか（`forPublic: true` の場合のみ）
  final bool? isLiked;
}
