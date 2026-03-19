import 'package:json_annotation/json_annotation.dart';

part 'misskey_note_partial.g.dart';

/// Partial note information from `/api/notes/show-partial-bulk`.
///
/// A lightweight representation containing only reaction counts and emoji data.
@JsonSerializable()
class MisskeyNotePartial {
  const MisskeyNotePartial({
    required this.id,
    this.reactions,
    this.reactionEmojis,
  });

  factory MisskeyNotePartial.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNotePartialFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNotePartialToJson(this);

  /// The unique identifier of the note.
  final String id;

  /// A map of reactions where keys are emoji strings and values are counts.
  @JsonKey(defaultValue: <String, int>{})
  final Map<String, int>? reactions;

  /// Reaction emoji map where keys are shortcodes and values are URLs.
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String>? reactionEmojis;
}
