import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_note.dart';

part 'misskey_note_favorite.g.dart';

/// A favorited note record.
@JsonSerializable()
class MisskeyNoteFavorite {
  const MisskeyNoteFavorite({
    required this.id,
    required this.createdAt,
    required this.noteId,
    this.note,
  });

  factory MisskeyNoteFavorite.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteFavoriteFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteFavoriteToJson(this);

  /// The unique identifier of this favorite record.
  final String id;

  /// The date and time when this note was favorited.
  @SafeDateTimeConverter()
  final DateTime createdAt;

  /// The ID of the favorited note.
  final String noteId;

  /// The favorited note.
  final MisskeyNote? note;
}
