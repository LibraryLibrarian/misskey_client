// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_registry_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyRegistryDetail _$MisskeyRegistryDetailFromJson(
        Map<String, dynamic> json) =>
    MisskeyRegistryDetail(
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      value: json['value'],
    );

Map<String, dynamic> _$MisskeyRegistryDetailToJson(
        MisskeyRegistryDetail instance) =>
    <String, dynamic>{
      'updatedAt': instance.updatedAt.toIso8601String(),
      'value': instance.value,
    };
