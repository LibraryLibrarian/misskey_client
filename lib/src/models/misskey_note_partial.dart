import 'package:json_annotation/json_annotation.dart';

part 'misskey_note_partial.g.dart';

/// ノートの部分情報（`/api/notes/show-partial-bulk`）
///
/// リアクション数と絵文字情報のみを含む軽量なノート情報
@JsonSerializable(createToJson: false)
class MisskeyNotePartial {
  const MisskeyNotePartial({
    required this.id,
    this.reactions,
    this.reactionEmojis,
  });

  factory MisskeyNotePartial.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNotePartialFromJson(json);

  final String id;

  /// リアクションのマップ {emoji: count}
  @JsonKey(defaultValue: <String, int>{})
  final Map<String, int>? reactions;

  /// リアクション絵文字マップ {shortcode: url}
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String>? reactionEmojis;
}
