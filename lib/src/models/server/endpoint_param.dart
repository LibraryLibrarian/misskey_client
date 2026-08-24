import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoint_param.freezed.dart';
part 'endpoint_param.g.dart';

/// A parameter definition for an API endpoint from `/api/endpoint`.
@freezed
@JsonSerializable()
class EndpointParam with _$EndpointParam {
  const EndpointParam({required this.name, required this.type});

  factory EndpointParam.fromJson(Map<String, dynamic> json) =>
      _$EndpointParamFromJson(json);

  Map<String, dynamic> toJson() => _$EndpointParamToJson(this);

  /// The parameter name.
  @override
  final String name;

  /// The parameter type (uppercase).
  @override
  final String type;
}
