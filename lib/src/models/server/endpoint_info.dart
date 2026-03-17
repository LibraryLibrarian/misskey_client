import 'package:json_annotation/json_annotation.dart';

import 'endpoint_param.dart';

part 'endpoint_info.g.dart';

/// エンドポイントの詳細情報（`/api/endpoint`）
@JsonSerializable(createToJson: false)
class EndpointInfo {
  const EndpointInfo({
    required this.params,
  });

  factory EndpointInfo.fromJson(Map<String, dynamic> json) =>
      _$EndpointInfoFromJson(json);

  /// エンドポイントのパラメーター一覧
  final List<EndpointParam> params;
}
