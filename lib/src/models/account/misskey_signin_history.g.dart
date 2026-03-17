// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_signin_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeySigninHistory _$MisskeySigninHistoryFromJson(
        Map<String, dynamic> json) =>
    MisskeySigninHistory(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      ip: json['ip'] as String?,
      headers: json['headers'] as Map<String, dynamic>?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$MisskeySigninHistoryToJson(
        MisskeySigninHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'ip': instance.ip,
      'headers': instance.headers,
      'success': instance.success,
    };
