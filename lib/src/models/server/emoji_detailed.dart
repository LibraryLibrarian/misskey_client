import 'package:json_annotation/json_annotation.dart';

part 'emoji_detailed.g.dart';

/// カスタム絵文字の詳細情報（`/api/emoji`）
///
/// `MisskeyCustomEmoji`（`EmojiSimple`相当）と異なり、
/// [id], [host], [license] を含み、
/// [isSensitive], [localOnly], [roleIdsThatCanBeUsedThisEmojiAsReaction]
/// が常に返却される。
@JsonSerializable(createToJson: false)
class EmojiDetailed {
  const EmojiDetailed({
    required this.id,
    required this.aliases,
    required this.name,
    this.category,
    this.host,
    required this.url,
    this.license,
    required this.isSensitive,
    required this.localOnly,
    required this.roleIdsThatCanBeUsedThisEmojiAsReaction,
  });

  factory EmojiDetailed.fromJson(Map<String, dynamic> json) =>
      _$EmojiDetailedFromJson(json);

  /// 絵文字ID
  final String id;

  /// エイリアス一覧
  final List<String> aliases;

  /// 絵文字名（ショートコード）
  final String name;

  /// カテゴリ
  final String? category;

  /// ホスト（ローカル絵文字の場合はnull）
  final String? host;

  /// 画像URL
  final String url;

  /// ライセンス情報
  final String? license;

  /// センシティブフラグ
  final bool isSensitive;

  /// ローカル限定フラグ
  final bool localOnly;

  /// この絵文字をリアクションとして使用可能なロールID一覧
  final List<String> roleIdsThatCanBeUsedThisEmojiAsReaction;
}
