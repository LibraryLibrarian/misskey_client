// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_access_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAccessToken _$MisskeyAccessTokenFromJson(Map<String, dynamic> json) =>
    MisskeyAccessToken(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      permission: (json['permission'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String?,
      lastUsedAt: const SafeDateTimeConverter().fromJson(
        json['lastUsedAt'] as String?,
      ),
      iconUrl: json['iconUrl'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$MisskeyAccessTokenToJson(MisskeyAccessToken instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'permission': instance.permission,
      'name': instance.name,
      'lastUsedAt': const SafeDateTimeConverter().toJson(instance.lastUsedAt),
      'iconUrl': instance.iconUrl,
      'description': instance.description,
    };
