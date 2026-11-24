// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_authorized_app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAuthorizedApp _$MisskeyAuthorizedAppFromJson(
  Map<String, dynamic> json,
) => MisskeyAuthorizedApp(
  id: json['id'] as String,
  name: json['name'] as String,
  permission: (json['permission'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  callbackUrl: json['callbackUrl'] as String?,
  isAuthorized: json['isAuthorized'] as bool?,
);

Map<String, dynamic> _$MisskeyAuthorizedAppToJson(
  MisskeyAuthorizedApp instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'permission': instance.permission,
  'callbackUrl': instance.callbackUrl,
  'isAuthorized': instance.isAuthorized,
};
