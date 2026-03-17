// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndpointInfo _$EndpointInfoFromJson(Map<String, dynamic> json) => EndpointInfo(
      params: (json['params'] as List<dynamic>)
          .map((e) => EndpointParam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EndpointInfoToJson(EndpointInfo instance) =>
    <String, dynamic>{
      'params': instance.params,
    };
