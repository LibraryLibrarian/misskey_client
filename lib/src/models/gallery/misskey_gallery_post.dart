import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_drive_file.dart';
import '../misskey_user.dart';

part 'misskey_gallery_post.g.dart';

/// ギャラリー投稿
@JsonSerializable(createToJson: false)
class MisskeyGalleryPost {
  const MisskeyGalleryPost({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.title,
    this.user,
    this.description,
    this.fileIds = const [],
    this.files = const [],
    this.tags = const [],
    this.isSensitive = false,
    this.likedCount = 0,
    this.isLiked,
  });

  factory MisskeyGalleryPost.fromJson(Map<String, dynamic> json) =>
      _$MisskeyGalleryPostFromJson(json);

  final String id;

  @SafeDateTimeConverter()
  final DateTime createdAt;

  @SafeDateTimeConverter()
  final DateTime updatedAt;

  final String userId;

  final MisskeyUser? user;

  /// 投稿タイトル（最大256文字）
  final String title;

  /// 投稿の説明文（最大2048文字）
  final String? description;

  /// 添付ファイルIDリスト
  final List<String> fileIds;

  /// 添付ファイルオブジェクトリスト
  final List<MisskeyDriveFile> files;

  /// タグリスト（空の場合レスポンスに含まれないことがある）
  final List<String> tags;

  /// センシティブコンテンツかどうか
  final bool isSensitive;

  /// いいね数
  final int likedCount;

  /// 認証ユーザーがいいね済みかどうか（認証時のみ）
  final bool? isLiked;
}
