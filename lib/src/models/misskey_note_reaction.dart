import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_note_reaction.g.dart';

/// A reaction to a note (element of `/api/notes/reactions` response).
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

  /// The unique identifier of this reaction.
  final String id;

  /// The date and time when this reaction was created.
  final DateTime createdAt;

  /// The reaction string (Unicode emoji or custom emoji shortcode).
  final String type;

  /// The user who reacted.
  final MisskeyUser user;
}
