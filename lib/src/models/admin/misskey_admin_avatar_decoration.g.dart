// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_admin_avatar_decoration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAdminAvatarDecoration _$MisskeyAdminAvatarDecorationFromJson(
        Map<String, dynamic> json) =>
    MisskeyAdminAvatarDecoration(
      id: json['id'] as String,
      createdAt:
          const SafeDateTimeConverter().fromJson(json['createdAt'] as String?),
      updatedAt:
          const SafeDateTimeConverter().fromJson(json['updatedAt'] as String?),
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      roleIdsThatCanBeUsedThisDecoration:
          (json['roleIdsThatCanBeUsedThisDecoration'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$MisskeyAdminAvatarDecorationToJson(
        MisskeyAdminAvatarDecoration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
      'name': instance.name,
      'description': instance.description,
      'url': instance.url,
      'roleIdsThatCanBeUsedThisDecoration':
          instance.roleIdsThatCanBeUsedThisDecoration,
      'category': instance.category,
    };
