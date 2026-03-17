// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_webhook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyWebhook _$MisskeyWebhookFromJson(Map<String, dynamic> json) =>
    MisskeyWebhook(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      on: (json['on'] as List<dynamic>).map((e) => e as String).toList(),
      url: json['url'] as String,
      secret: json['secret'] as String,
      active: json['active'] as bool,
      latestSentAt: const SafeDateTimeConverter()
          .fromJson(json['latestSentAt'] as String?),
      latestStatus: (json['latestStatus'] as num?)?.toInt(),
    );
