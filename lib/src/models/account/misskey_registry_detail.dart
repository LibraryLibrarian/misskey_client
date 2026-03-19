import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_registry_detail.g.dart';

/// Detailed information about a registry item.
@JsonSerializable()
class MisskeyRegistryDetail {
  const MisskeyRegistryDetail({
    required this.updatedAt,
    required this.value,
  });

  factory MisskeyRegistryDetail.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRegistryDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRegistryDetailToJson(this);

  /// The date and time when this registry item was last updated.
  @SafeDateTimeConverter()
  final DateTime updatedAt;

  /// The value stored in the registry.
  final dynamic value;
}
