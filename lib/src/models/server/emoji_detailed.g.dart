// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_detailed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmojiDetailed _$EmojiDetailedFromJson(Map<String, dynamic> json) =>
    EmojiDetailed(
      id: json['id'] as String,
      aliases:
          (json['aliases'] as List<dynamic>).map((e) => e as String).toList(),
      name: json['name'] as String,
      category: json['category'] as String?,
      host: json['host'] as String?,
      url: json['url'] as String,
      license: json['license'] as String?,
      isSensitive: json['isSensitive'] as bool,
      localOnly: json['localOnly'] as bool,
      roleIdsThatCanBeUsedThisEmojiAsReaction:
          (json['roleIdsThatCanBeUsedThisEmojiAsReaction'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );
