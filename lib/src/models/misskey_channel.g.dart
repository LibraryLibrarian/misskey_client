// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyChannel _$MisskeyChannelFromJson(Map<String, dynamic> json) =>
    MisskeyChannel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['userId'] as String?,
      lastNotedAt: const SafeDateTimeConverter()
          .fromJson(json['lastNotedAt'] as String?),
      bannerUrl: json['bannerUrl'] as String?,
      pinnedNoteIds: (json['pinnedNoteIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      color: json['color'] as String?,
      isArchived: json['isArchived'] as bool? ?? false,
      usersCount: (json['usersCount'] as num?)?.toInt() ?? 0,
      notesCount: (json['notesCount'] as num?)?.toInt() ?? 0,
      isSensitive: json['isSensitive'] as bool? ?? false,
      allowRenoteToExternal: json['allowRenoteToExternal'] as bool? ?? true,
      isFollowing: json['isFollowing'] as bool?,
      isFavorited: json['isFavorited'] as bool?,
      pinnedNotes: (json['pinnedNotes'] as List<dynamic>?)
          ?.map((e) => MisskeyNote.fromJson(e as Map<String, dynamic>))
          .toList(),
      bannerId: json['bannerId'] as String?,
      isMuting: json['isMuting'] as bool?,
    );

Map<String, dynamic> _$MisskeyChannelToJson(MisskeyChannel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'userId': instance.userId,
      'lastNotedAt': const SafeDateTimeConverter().toJson(instance.lastNotedAt),
      'bannerUrl': instance.bannerUrl,
      'pinnedNoteIds': instance.pinnedNoteIds,
      'color': instance.color,
      'isArchived': instance.isArchived,
      'usersCount': instance.usersCount,
      'notesCount': instance.notesCount,
      'isSensitive': instance.isSensitive,
      'allowRenoteToExternal': instance.allowRenoteToExternal,
      'isFollowing': instance.isFollowing,
      'isFavorited': instance.isFavorited,
      'pinnedNotes': instance.pinnedNotes?.map((e) => e.toJson()).toList(),
      'bannerId': instance.bannerId,
      'isMuting': instance.isMuting,
    };
