import 'package:freezed_annotation/freezed_annotation.dart';

part 'emoji_detailed.freezed.dart';
part 'emoji_detailed.g.dart';

/// Detailed information about a custom emoji returned by `/api/emoji`.
///
/// Unlike `MisskeyCustomEmoji` (which corresponds to `EmojiSimple`), this
/// includes [id], [host], and [license], and always returns
/// [isSensitive], [localOnly], and
/// [roleIdsThatCanBeUsedThisEmojiAsReaction].
@freezed
@JsonSerializable()
class EmojiDetailed with _$EmojiDetailed {
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
  @override
  final String id;

  /// The list of aliases.
  @override
  final List<String> aliases;

  /// The emoji name (shortcode).
  @override
  final String name;

  /// The category, if any.
  @override
  final String? category;

  /// The host, or `null` for local emoji.
  @override
  final String? host;

  /// The image URL.
  @override
  final String url;

  /// The license information, if any.
  @override
  final String? license;

  /// Whether this emoji is marked as sensitive.
  @override
  final bool isSensitive;

  /// Whether this emoji is restricted to local use only.
  @override
  final bool localOnly;

  /// The list of role IDs that can use this emoji as a reaction.
  @override
  final List<String> roleIdsThatCanBeUsedThisEmojiAsReaction;
}
