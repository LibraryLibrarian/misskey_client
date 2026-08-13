// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_system_webhook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeySystemWebhook _$MisskeySystemWebhookFromJson(
  Map<String, dynamic> json,
) => MisskeySystemWebhook(
  id: json['id'] as String,
  isActive: json['isActive'] as bool,
  updatedAt: const SafeDateTimeConverter().fromJson(
    json['updatedAt'] as String?,
  ),
  latestSentAt: const SafeDateTimeConverter().fromJson(
    json['latestSentAt'] as String?,
  ),
  latestStatus: json['latestStatus'] as num?,
  name: json['name'] as String,
  on: (json['on'] as List<dynamic>).map((e) => e as String).toList(),
  url: json['url'] as String,
  secret: json['secret'] as String?,
);

Map<String, dynamic> _$MisskeySystemWebhookToJson(
  MisskeySystemWebhook instance,
) => <String, dynamic>{
  'id': instance.id,
  'isActive': instance.isActive,
  'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
  'latestSentAt': const SafeDateTimeConverter().toJson(instance.latestSentAt),
  'latestStatus': instance.latestStatus,
  'name': instance.name,
  'on': instance.on,
  'url': instance.url,
  'secret': instance.secret,
};
