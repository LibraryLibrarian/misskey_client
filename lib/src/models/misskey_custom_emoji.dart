import 'package:json_annotation/json_annotation.dart';

part 'misskey_custom_emoji.g.dart';

/// A Misskey custom emoji.
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

  /// The shortcode (without surrounding colons).
  @JsonKey(name: 'name')
  final String shortcode;

  /// The emoji image URL.
  final String url;

  /// The category this emoji belongs to.
  final String? category;

  /// Alternative names for this emoji.
  final List<String>? aliases;

  /// Whether the emoji is restricted to the local instance.
  final bool? localOnly;

  /// Whether the emoji is marked as sensitive.
  final bool? isSensitive;

  /// The role IDs that are allowed to use this emoji as a reaction.
  final List<String>? roleIdsThatCanBeUsedThisEmojiAsReaction;
}
