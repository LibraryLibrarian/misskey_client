import 'package:json_annotation/json_annotation.dart';

part 'misskey_note_state.g.dart';

/// The authenticated user's state for a note (`/api/notes/state`).
@JsonSerializable()
class MisskeyNoteState {
  const MisskeyNoteState({
    required this.isFavorited,
    required this.isMutedThread,
  });

  factory MisskeyNoteState.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteStateFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteStateToJson(this);

  /// Whether the note is favorited.
  @JsonKey(defaultValue: false)
  final bool isFavorited;

  /// Whether the thread is muted.
  @JsonKey(defaultValue: false)
  final bool isMutedThread;
}
