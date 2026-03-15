import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_flash.g.dart';

/// Misskey Flash（Play）（`/api/users/flashs` のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyFlash {
  const MisskeyFlash({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.title,
    required this.summary,
    required this.script,
    this.user,
    this.likedCount = 0,
    this.isLiked,
  });

  factory MisskeyFlash.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFlashFromJson(json);

  final String id;

  @SafeDateTimeConverter()
  final DateTime? createdAt;

  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  final String userId;
  final MisskeyUser? user;

  /// Flash タイトル
  final String title;

  /// 概要
  final String summary;

  /// AiScript コード
  final String script;

  /// いいね数
  @JsonKey(defaultValue: 0)
  final int likedCount;

  /// 認証ユーザーがいいね済みか
  final bool? isLiked;
}
