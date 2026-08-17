import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_custom_emoji.freezed.dart';
part 'misskey_custom_emoji.g.dart';

/// A Misskey custom emoji.
@freezed
@JsonSerializable()
class MisskeyCustomEmoji with _$MisskeyCustomEmoji {
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
  @override
  final String shortcode;

  /// The emoji image URL.
  @override
  final String url;

  /// The category this emoji belongs to.
  @override
  final String? category;

  /// Alternative names for this emoji.
  @override
  final List<String>? aliases;

  /// Whether the emoji is restricted to the local instance.
  @override
  final bool? localOnly;

  /// Whether the emoji is marked as sensitive.
  @override
  final bool? isSensitive;

  /// The role IDs that are allowed to use this emoji as a reaction.
  @override
  final List<String>? roleIdsThatCanBeUsedThisEmojiAsReaction;
}
