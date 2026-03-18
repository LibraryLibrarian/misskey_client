import 'package:json_annotation/json_annotation.dart';

part 'emoji_detailed.g.dart';

/// Detailed information about a custom emoji returned by `/api/emoji`.
///
/// Unlike `MisskeyCustomEmoji` (which corresponds to `EmojiSimple`), this
/// includes [id], [host], and [license], and always returns
/// [isSensitive], [localOnly], and
/// [roleIdsThatCanBeUsedThisEmojiAsReaction].
@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$EmojiDetailedToJson(this);

  /// The emoji ID.
  final String id;

  /// The list of aliases.
  final List<String> aliases;

  /// The emoji name (shortcode).
  final String name;

  /// The category, if any.
  final String? category;

  /// The host, or `null` for local emoji.
  final String? host;

  /// The image URL.
  final String url;

  /// The license information, if any.
  final String? license;

  /// Whether this emoji is marked as sensitive.
  final bool isSensitive;

  /// Whether this emoji is restricted to local use only.
  final bool localOnly;

  /// The list of role IDs that can use this emoji as a reaction.
  final List<String> roleIdsThatCanBeUsedThisEmojiAsReaction;
}
