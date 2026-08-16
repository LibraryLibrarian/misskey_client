import 'package:json_annotation/json_annotation.dart';

import 'muted_word.dart';

/// A safe [JsonConverter] that uses [DateTime.tryParse].
///
/// Falls back to `null` instead of throwing on malformed input.
class SafeDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const SafeDateTimeConverter();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.tryParse(json);

  @override
  String? toJson(DateTime? object) => object?.toIso8601String();
}

/// Converts Misskey word-mute conditions to and from their JSON union shape.
///
/// Unrecognized element shapes are preserved as [MutedWordUnknown] so that a
/// fork-specific value does not make the entire user response unusable.
class MutedWordListConverter
    implements JsonConverter<List<MutedWord>?, List<dynamic>?> {
  const MutedWordListConverter();

  @override
  List<MutedWord>? fromJson(List<dynamic>? json) {
    if (json == null) return null;

    return json.map(_fromJsonElement).toList();
  }

  @override
  List<dynamic>? toJson(List<MutedWord>? object) => object
      ?.map<dynamic>(
        (word) => switch (word) {
          MutedWordKeywords(:final keywords) => keywords,
          MutedWordRegex(:final pattern) => pattern,
          MutedWordUnknown(:final rawValue) => rawValue,
        },
      )
      .toList();

  MutedWord _fromJsonElement(dynamic value) {
    if (value is String) {
      return MutedWordRegex(pattern: value);
    }
    if (value is List<dynamic>) {
      if (value.every((element) => element is String)) {
        return MutedWordKeywords(keywords: value.cast<String>());
      }
    }
    return MutedWordUnknown(rawValue: value);
  }
}
