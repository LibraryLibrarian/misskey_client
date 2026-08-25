// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_admin_emoji_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAdminEmojiListQuery _$MisskeyAdminEmojiListQueryFromJson(
  Map<String, dynamic> json,
) => MisskeyAdminEmojiListQuery(
  updatedAtFrom: json['updatedAtFrom'] as String?,
  updatedAtTo: json['updatedAtTo'] as String?,
  name: json['name'] as String?,
  host: json['host'] as String?,
  uri: json['uri'] as String?,
  publicUrl: json['publicUrl'] as String?,
  originalUrl: json['originalUrl'] as String?,
  type: json['type'] as String?,
  aliases: json['aliases'] as String?,
  category: json['category'] as String?,
  license: json['license'] as String?,
  isSensitive: json['isSensitive'] as bool?,
  localOnly: json['localOnly'] as bool?,
  hostType: json['hostType'] as String?,
  roleIds: (json['roleIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$MisskeyAdminEmojiListQueryToJson(
  MisskeyAdminEmojiListQuery instance,
) => <String, dynamic>{
  'updatedAtFrom': ?instance.updatedAtFrom,
  'updatedAtTo': ?instance.updatedAtTo,
  'name': ?instance.name,
  'host': ?instance.host,
  'uri': ?instance.uri,
  'publicUrl': ?instance.publicUrl,
  'originalUrl': ?instance.originalUrl,
  'type': ?instance.type,
  'aliases': ?instance.aliases,
  'category': ?instance.category,
  'license': ?instance.license,
  'isSensitive': ?instance.isSensitive,
  'localOnly': ?instance.localOnly,
  'hostType': ?instance.hostType,
  'roleIds': ?instance.roleIds,
};

MisskeyAdminEmojiRole _$MisskeyAdminEmojiRoleFromJson(
  Map<String, dynamic> json,
) => MisskeyAdminEmojiRole(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$MisskeyAdminEmojiRoleToJson(
  MisskeyAdminEmojiRole instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

MisskeyAdminEmojiDetailed _$MisskeyAdminEmojiDetailedFromJson(
  Map<String, dynamic> json,
) => MisskeyAdminEmojiDetailed(
  id: json['id'] as String,
  updatedAt: const SafeDateTimeConverter().fromJson(
    json['updatedAt'] as String?,
  ),
  name: json['name'] as String,
  host: json['host'] as String?,
  publicUrl: json['publicUrl'] as String,
  originalUrl: json['originalUrl'] as String,
  uri: json['uri'] as String?,
  type: json['type'] as String?,
  aliases: (json['aliases'] as List<dynamic>).map((e) => e as String).toList(),
  category: json['category'] as String?,
  license: json['license'] as String?,
  localOnly: json['localOnly'] as bool,
  isSensitive: json['isSensitive'] as bool,
  roleIdsThatCanBeUsedThisEmojiAsReaction:
      (json['roleIdsThatCanBeUsedThisEmojiAsReaction'] as List<dynamic>)
          .map((e) => MisskeyAdminEmojiRole.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$MisskeyAdminEmojiDetailedToJson(
  MisskeyAdminEmojiDetailed instance,
) => <String, dynamic>{
  'id': instance.id,
  'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
  'name': instance.name,
  'host': instance.host,
  'publicUrl': instance.publicUrl,
  'originalUrl': instance.originalUrl,
  'uri': instance.uri,
  'type': instance.type,
  'aliases': instance.aliases,
  'category': instance.category,
  'license': instance.license,
  'localOnly': instance.localOnly,
  'isSensitive': instance.isSensitive,
  'roleIdsThatCanBeUsedThisEmojiAsReaction': instance
      .roleIdsThatCanBeUsedThisEmojiAsReaction
      .map((e) => e.toJson())
      .toList(),
};

MisskeyAdminEmojiListResult _$MisskeyAdminEmojiListResultFromJson(
  Map<String, dynamic> json,
) => MisskeyAdminEmojiListResult(
  emojis: (json['emojis'] as List<dynamic>)
      .map((e) => MisskeyAdminEmojiDetailed.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: (json['count'] as num).toInt(),
  allCount: (json['allCount'] as num).toInt(),
  allPages: (json['allPages'] as num).toInt(),
);

Map<String, dynamic> _$MisskeyAdminEmojiListResultToJson(
  MisskeyAdminEmojiListResult instance,
) => <String, dynamic>{
  'emojis': instance.emojis.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'allCount': instance.allCount,
  'allPages': instance.allPages,
};
