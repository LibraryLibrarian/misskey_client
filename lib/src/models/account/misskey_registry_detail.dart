import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_registry_detail.freezed.dart';
part 'misskey_registry_detail.g.dart';

/// Detailed information about a registry item.
@freezed
@JsonSerializable()
class MisskeyRegistryDetail with _$MisskeyRegistryDetail {
  const MisskeyRegistryDetail({required this.updatedAt, required this.value});

  factory MisskeyRegistryDetail.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRegistryDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRegistryDetailToJson(this);

  /// The date and time when this registry item was last updated.
  @SafeDateTimeConverter()
  @override
  final DateTime updatedAt;

  /// The value stored in the registry.
  @override
  final dynamic value;
}
