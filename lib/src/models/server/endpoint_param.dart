import 'package:json_annotation/json_annotation.dart';

part 'endpoint_param.g.dart';

/// エンドポイントのパラメーター情報（`/api/endpoint`）
@JsonSerializable(createToJson: false)
class EndpointParam {
  const EndpointParam({
    required this.name,
    required this.type,
  });

  factory EndpointParam.fromJson(Map<String, dynamic> json) =>
      _$EndpointParamFromJson(json);

  /// パラメーター名
  final String name;

  /// パラメーターの型（大文字）
  final String type;
}
