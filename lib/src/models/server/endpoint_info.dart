import 'package:freezed_annotation/freezed_annotation.dart';

import 'endpoint_param.dart';

part 'endpoint_info.freezed.dart';
part 'endpoint_info.g.dart';

/// Detailed information about an API endpoint from `/api/endpoint`.
@freezed
@JsonSerializable()
class EndpointInfo with _$EndpointInfo {
  const EndpointInfo({required this.params});

  factory EndpointInfo.fromJson(Map<String, dynamic> json) =>
      _$EndpointInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EndpointInfoToJson(this);

  /// The list of parameters for this endpoint.
  @override
  final List<EndpointParam> params;
}
