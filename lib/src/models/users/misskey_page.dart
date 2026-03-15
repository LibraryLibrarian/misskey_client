import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_page.g.dart';

/// Misskeyページ（`/api/users/pages` のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyPage {
  const MisskeyPage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.title,
    required this.name,
    this.user,
    this.summary,
    this.content,
    this.variables,
    this.alignCenter = false,
    this.hideTitleWhenPinned = false,
    this.font,
    this.script,
    this.eyeCatchingImageId,
    this.likedCount = 0,
    this.isLiked,
  });

  factory MisskeyPage.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPageFromJson(json);

  final String id;

  @SafeDateTimeConverter()
  final DateTime? createdAt;

  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  final String userId;
  final MisskeyUser? user;

  /// ページタイトル
  final String title;

  /// ページのURLパス名
  final String name;

  /// 概要
  final String? summary;

  /// ページコンテンツ（ブロック配列）
  final List<dynamic>? content;

  /// ページ変数
  final List<dynamic>? variables;

  /// 中央揃えか
  @JsonKey(defaultValue: false)
  final bool alignCenter;

  /// ピン留め時にタイトルを隠すか
  @JsonKey(defaultValue: false)
  final bool hideTitleWhenPinned;

  /// フォント設定
  final String? font;

  /// スクリプト
  final String? script;

  /// アイキャッチ画像のファイルID
  final String? eyeCatchingImageId;

  /// いいね数
  @JsonKey(defaultValue: 0)
  final int likedCount;

  /// 認証ユーザーがいいね済みか
  final bool? isLiked;
}
