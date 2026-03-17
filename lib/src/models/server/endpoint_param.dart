import 'package:json_annotation/json_annotation.dart';

part 'endpoint_param.g.dart';

/// エンドポイントのパラメーター情報（`/api/endpoint`）
@JsonSerializable()
class EndpointParam {
  const EndpointParam({
    required this.name,
    required this.type,
  });

  factory EndpointParam.fromJson(Map<String, dynamic> json) =>
      _$EndpointParamFromJson(json);

  Map<String, dynamic> toJson() => _$EndpointParamToJson(this);

  /// パラメーター名
  final String name;

  /// パラメーターの型（大文字）
  final String type;
}
