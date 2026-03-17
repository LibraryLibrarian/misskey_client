import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_note.dart';

part 'misskey_note_favorite.g.dart';

/// ノートのお気に入り情報
@JsonSerializable(createToJson: false)
class MisskeyNoteFavorite {
  const MisskeyNoteFavorite({
    required this.id,
    required this.createdAt,
    required this.noteId,
    this.note,
  });

  factory MisskeyNoteFavorite.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteFavoriteFromJson(json);

  final String id;

  @SafeDateTimeConverter()
  final DateTime createdAt;

  final String noteId;
  final MisskeyNote? note;
}
