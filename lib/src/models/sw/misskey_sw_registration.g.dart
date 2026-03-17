// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_sw_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeySwRegistration _$MisskeySwRegistrationFromJson(
        Map<String, dynamic> json) =>
    MisskeySwRegistration(
      state: json['state'] as String,
      key: json['key'] as String?,
      userId: json['userId'] as String,
      endpoint: json['endpoint'] as String,
      sendReadMessage: json['sendReadMessage'] as bool,
    );

Map<String, dynamic> _$MisskeySwRegistrationToJson(
        MisskeySwRegistration instance) =>
    <String, dynamic>{
      'state': instance.state,
      'key': instance.key,
      'userId': instance.userId,
      'endpoint': instance.endpoint,
      'sendReadMessage': instance.sendReadMessage,
    };
