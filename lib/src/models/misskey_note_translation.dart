import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_note_translation.freezed.dart';
part 'misskey_note_translation.g.dart';

/// A note translation result (`/api/notes/translate`).
@freezed
@JsonSerializable()
class MisskeyNoteTranslation with _$MisskeyNoteTranslation {
  const MisskeyNoteTranslation({required this.sourceLang, required this.text});

  factory MisskeyNoteTranslation.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteTranslationToJson(this);

  /// The detected language code of the source text.
  @override
  final String sourceLang;

  /// The translated text.
  @override
  final String text;
}
