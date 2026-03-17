// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_antenna.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAntenna _$MisskeyAntennaFromJson(Map<String, dynamic> json) =>
    MisskeyAntenna(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String,
      keywords: (json['keywords'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      excludeKeywords: (json['excludeKeywords'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      src: json['src'] as String,
      userListId: json['userListId'] as String?,
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
      caseSensitive: json['caseSensitive'] as bool,
      localOnly: json['localOnly'] as bool,
      excludeBots: json['excludeBots'] as bool,
      withReplies: json['withReplies'] as bool,
      withFile: json['withFile'] as bool,
      excludeNotesInSensitiveChannel:
          json['excludeNotesInSensitiveChannel'] as bool,
      isActive: json['isActive'] as bool,
      hasUnreadNote: json['hasUnreadNote'] as bool? ?? false,
      notify: json['notify'] as bool? ?? false,
    );

Map<String, dynamic> _$MisskeyAntennaToJson(MisskeyAntenna instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'keywords': instance.keywords,
      'excludeKeywords': instance.excludeKeywords,
      'src': instance.src,
      'userListId': instance.userListId,
      'users': instance.users,
      'caseSensitive': instance.caseSensitive,
      'localOnly': instance.localOnly,
      'excludeBots': instance.excludeBots,
      'withReplies': instance.withReplies,
      'withFile': instance.withFile,
      'excludeNotesInSensitiveChannel': instance.excludeNotesInSensitiveChannel,
      'isActive': instance.isActive,
      'hasUnreadNote': instance.hasUnreadNote,
      'notify': instance.notify,
    };
