import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_converters.dart';
import 'misskey_note.dart';

part 'misskey_note_favorite.freezed.dart';
part 'misskey_note_favorite.g.dart';

/// A favorited note record.
@freezed
@JsonSerializable()
class MisskeyNoteFavorite with _$MisskeyNoteFavorite {
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
  @override
  final String id;

  /// The date and time when this note was favorited.
  @SafeDateTimeConverter()
  @override
  final DateTime createdAt;

  /// The ID of the favorited note.
  @override
  final String noteId;

  /// The favorited note.
  @override
  final MisskeyNote? note;
}
