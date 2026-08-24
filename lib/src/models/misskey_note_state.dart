import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_note_state.freezed.dart';
part 'misskey_note_state.g.dart';

/// The authenticated user's state for a note (`/api/notes/state`).
@freezed
@JsonSerializable()
class MisskeyNoteState with _$MisskeyNoteState {
  const MisskeyNoteState({
    required this.isFavorited,
    required this.isMutedThread,
  });

  factory MisskeyNoteState.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteStateFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteStateToJson(this);

  /// Whether the note is favorited.
  @JsonKey(defaultValue: false)
  @override
  final bool isFavorited;

  /// Whether the thread is muted.
  @JsonKey(defaultValue: false)
  @override
  final bool isMutedThread;
}
