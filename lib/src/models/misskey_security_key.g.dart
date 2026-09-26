// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_security_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeySecurityKey _$MisskeySecurityKeyFromJson(Map<String, dynamic> json) =>
    MisskeySecurityKey(
      id: json['id'] as String,
      name: json['name'] as String,
      lastUsed: DateTime.parse(json['lastUsed'] as String),
    );

Map<String, dynamic> _$MisskeySecurityKeyToJson(MisskeySecurityKey instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lastUsed': instance.lastUsed.toIso8601String(),
    };
