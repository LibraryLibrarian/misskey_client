// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_custom_emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyCustomEmoji _$MisskeyCustomEmojiFromJson(Map<String, dynamic> json) =>
    MisskeyCustomEmoji(
      shortcode: json['name'] as String,
      url: json['url'] as String,
      category: json['category'] as String?,
      aliases:
          (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList(),
      localOnly: json['localOnly'] as bool?,
      isSensitive: json['isSensitive'] as bool?,
      roleIdsThatCanBeUsedThisEmojiAsReaction:
          (json['roleIdsThatCanBeUsedThisEmojiAsReaction'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$MisskeyCustomEmojiToJson(MisskeyCustomEmoji instance) =>
    <String, dynamic>{
      'name': instance.shortcode,
      'url': instance.url,
      'category': instance.category,
      'aliases': instance.aliases,
      'localOnly': instance.localOnly,
      'isSensitive': instance.isSensitive,
      'roleIdsThatCanBeUsedThisEmojiAsReaction':
          instance.roleIdsThatCanBeUsedThisEmojiAsReaction,
    };
