import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_note_reaction.g.dart';

/// ノートへのリアクション（`/api/notes/reactions` のレスポンス要素）
@JsonSerializable()
class MisskeyNoteReaction {
  const MisskeyNoteReaction({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.user,
  });

  factory MisskeyNoteReaction.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteReactionFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteReactionToJson(this);

  final String id;
  final DateTime createdAt;

  /// リアクション文字列（Unicode絵文字またはカスタム絵文字ショートコード）
  final String type;

  final MisskeyUser user;
}
