import 'package:json_annotation/json_annotation.dart';

part 'misskey_custom_emoji.g.dart';

/// Misskey のカスタム絵文字
@JsonSerializable()
class MisskeyCustomEmoji {
  const MisskeyCustomEmoji({
    required this.shortcode,
    required this.url,
    this.category,
    this.aliases,
    this.localOnly,
    this.isSensitive,
    this.roleIdsThatCanBeUsedThisEmojiAsReaction,
  });

  // Misskey API may return emoji objects in different formats.
  // The `emojis` field on notes is a simple map {shortcode: url},
  // while custom emoji endpoints return full objects.
  // This factory handles the full object format.
  factory MisskeyCustomEmoji.fromJson(Map<String, dynamic> json) =>
      _$MisskeyCustomEmojiFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyCustomEmojiToJson(this);

  /// ショートコード（コロンを除いた部分）
  @JsonKey(name: 'name')
  final String shortcode;

  /// 画像URL
  final String url;

  final String? category;

  final List<String>? aliases;

  final bool? localOnly;

  final bool? isSensitive;

  final List<String>? roleIdsThatCanBeUsedThisEmojiAsReaction;
}
