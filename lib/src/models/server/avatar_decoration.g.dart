// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_decoration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarDecoration _$AvatarDecorationFromJson(Map<String, dynamic> json) =>
    AvatarDecoration(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      roleIdsThatCanBeUsedThisDecoration:
          (json['roleIdsThatCanBeUsedThisDecoration'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$AvatarDecorationToJson(AvatarDecoration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'url': instance.url,
      'roleIdsThatCanBeUsedThisDecoration':
          instance.roleIdsThatCanBeUsedThisDecoration,
    };
