import 'package:json_annotation/json_annotation.dart';

import 'endpoint_param.dart';

part 'endpoint_info.g.dart';

/// Detailed information about an API endpoint from `/api/endpoint`.
@JsonSerializable()
class EndpointInfo {
  const EndpointInfo({
    required this.params,
  });

  factory EndpointInfo.fromJson(Map<String, dynamic> json) =>
      _$EndpointInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EndpointInfoToJson(this);

  /// The list of parameters for this endpoint.
  final List<EndpointParam> params;
}
