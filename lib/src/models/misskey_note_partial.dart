import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_note_partial.freezed.dart';
part 'misskey_note_partial.g.dart';

/// Partial note information from `/api/notes/show-partial-bulk`.
///
/// A lightweight representation containing only reaction counts and emoji data.
@freezed
@JsonSerializable()
class MisskeyNotePartial with _$MisskeyNotePartial {
  const MisskeyNotePartial({
    required this.id,
    this.reactions,
    this.reactionEmojis,
  });

  factory MisskeyNotePartial.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNotePartialFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNotePartialToJson(this);

  /// The unique identifier of the note.
  @override
  final String id;

  /// A map of reactions where keys are emoji strings and values are counts.
  @JsonKey(defaultValue: <String, int>{})
  @override
  final Map<String, int>? reactions;

  /// Reaction emoji map where keys are shortcodes and values are URLs.
  @JsonKey(defaultValue: <String, String>{})
  @override
  final Map<String, String>? reactionEmojis;
}
