import 'package:json_annotation/json_annotation.dart';

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
