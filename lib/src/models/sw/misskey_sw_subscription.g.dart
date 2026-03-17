// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_sw_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeySwSubscription _$MisskeySwSubscriptionFromJson(
        Map<String, dynamic> json) =>
    MisskeySwSubscription(
      userId: json['userId'] as String,
      endpoint: json['endpoint'] as String,
      sendReadMessage: json['sendReadMessage'] as bool,
    );

Map<String, dynamic> _$MisskeySwSubscriptionToJson(
        MisskeySwSubscription instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'endpoint': instance.endpoint,
      'sendReadMessage': instance.sendReadMessage,
    };
