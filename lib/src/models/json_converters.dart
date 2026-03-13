import 'package:json_annotation/json_annotation.dart';

/// [DateTime.tryParse] を使用する安全な [JsonConverter]。
///
/// 不正な書式で例外を投げる代わりに `null` にフォールバックする。
class SafeDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const SafeDateTimeConverter();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.tryParse(json);

  @override
  String? toJson(DateTime? object) => object?.toIso8601String();
}
