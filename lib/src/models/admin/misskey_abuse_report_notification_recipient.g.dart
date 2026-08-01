// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_abuse_report_notification_recipient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAbuseReportNotificationRecipient
    _$MisskeyAbuseReportNotificationRecipientFromJson(
            Map<String, dynamic> json) =>
        MisskeyAbuseReportNotificationRecipient(
          id: json['id'] as String,
          isActive: json['isActive'] as bool,
          updatedAt: const SafeDateTimeConverter()
              .fromJson(json['updatedAt'] as String?),
          name: json['name'] as String,
          method: json['method'] as String,
          userId: json['userId'] as String?,
          user: json['user'] == null
              ? null
              : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
          systemWebhookId: json['systemWebhookId'] as String?,
          systemWebhook: json['systemWebhook'] as Map<String, dynamic>?,
        );

Map<String, dynamic> _$MisskeyAbuseReportNotificationRecipientToJson(
        MisskeyAbuseReportNotificationRecipient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
      'name': instance.name,
      'method': instance.method,
      'userId': instance.userId,
      'user': instance.user?.toJson(),
      'systemWebhookId': instance.systemWebhookId,
      'systemWebhook': instance.systemWebhook,
    };
