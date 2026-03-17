import 'package:json_annotation/json_annotation.dart';

part 'misskey_note_state.g.dart';

/// ノートに対する認証ユーザーの状態（`/api/notes/state`）
@JsonSerializable(createToJson: false)
class MisskeyNoteState {
  const MisskeyNoteState({
    required this.isFavorited,
    required this.isMutedThread,
  });

  factory MisskeyNoteState.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteStateFromJson(json);

  /// お気に入り済みかどうか
  @JsonKey(defaultValue: false)
  final bool isFavorited;

  /// スレッドをミュート済みかどうか
  @JsonKey(defaultValue: false)
  final bool isMutedThread;
}
