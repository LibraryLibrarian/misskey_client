import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_registry_detail.g.dart';

/// レジストリアイテムの詳細情報
@JsonSerializable()
class MisskeyRegistryDetail {
  const MisskeyRegistryDetail({
    required this.updatedAt,
    required this.value,
  });

  factory MisskeyRegistryDetail.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRegistryDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRegistryDetailToJson(this);

  /// 最終更新日時
  @SafeDateTimeConverter()
  final DateTime updatedAt;

  /// レジストリに格納されている値
  final dynamic value;
}
