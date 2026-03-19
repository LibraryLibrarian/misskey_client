import 'package:json_annotation/json_annotation.dart';

part 'misskey_note_translation.g.dart';

/// A note translation result (`/api/notes/translate`).
@JsonSerializable()
class MisskeyNoteTranslation {
  const MisskeyNoteTranslation({
    required this.sourceLang,
    required this.text,
  });

  factory MisskeyNoteTranslation.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteTranslationToJson(this);

  /// The detected language code of the source text.
  final String sourceLang;

  /// The translated text.
  final String text;
}
