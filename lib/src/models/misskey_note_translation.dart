import 'package:json_annotation/json_annotation.dart';

part 'misskey_note_translation.g.dart';

/// ノート翻訳結果（`/api/notes/translate`）
@JsonSerializable(createToJson: false)
class MisskeyNoteTranslation {
  const MisskeyNoteTranslation({
    required this.sourceLang,
    required this.text,
  });

  factory MisskeyNoteTranslation.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteTranslationFromJson(json);

  /// 検出された原文の言語コード
  final String sourceLang;

  /// 翻訳後のテキスト
  final String text;
}
