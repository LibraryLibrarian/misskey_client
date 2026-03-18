import 'package:json_annotation/json_annotation.dart';

part 'endpoint_param.g.dart';

/// A parameter definition for an API endpoint from `/api/endpoint`.
@JsonSerializable()
class EndpointParam {
  const EndpointParam({
    required this.name,
    required this.type,
  });

  factory EndpointParam.fromJson(Map<String, dynamic> json) =>
      _$EndpointParamFromJson(json);

  Map<String, dynamic> toJson() => _$EndpointParamToJson(this);

  /// The parameter name.
  final String name;

  /// The parameter type (uppercase).
  final String type;
}
