// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNote _$MisskeyNoteFromJson(Map<String, dynamic> json) => MisskeyNote(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      user: MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      text: json['text'] as String?,
      cw: json['cw'] as String?,
      visibility: $enumDecodeNullable(
          _$MisskeyNoteVisibilityEnumMap, json['visibility'],
          unknownValue: MisskeyNoteVisibility.public),
      localOnly: json['localOnly'] as bool? ?? false,
      reactionAcceptance: $enumDecodeNullable(
          _$MisskeyReactionAcceptanceEnumMap, json['reactionAcceptance']),
      renoteCount: (json['renoteCount'] as num?)?.toInt() ?? 0,
      repliesCount: (json['repliesCount'] as num?)?.toInt() ?? 0,
      reactionCount: (json['reactionCount'] as num?)?.toInt() ?? 0,
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          {},
      emojis: (json['emojis'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
      fileIds: (json['fileIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      files: (json['files'] as List<dynamic>?)
              ?.map((e) => MisskeyDriveFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      replyId: json['replyId'] as String?,
      renoteId: json['renoteId'] as String?,
      reply: json['reply'] == null
          ? null
          : MisskeyNote.fromJson(json['reply'] as Map<String, dynamic>),
      renote: json['renote'] == null
          ? null
          : MisskeyNote.fromJson(json['renote'] as Map<String, dynamic>),
      uri: json['uri'] as String?,
      url: json['url'] as String?,
      channelId: json['channelId'] as String?,
      channel: json['channel'] == null
          ? null
          : MisskeyNoteChannel.fromJson(
              json['channel'] as Map<String, dynamic>),
      mentions: (json['mentions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      visibleUserIds: (json['visibleUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      poll: json['poll'] == null
          ? null
          : MisskeyPoll.fromJson(json['poll'] as Map<String, dynamic>),
      myReaction: json['myReaction'] as String?,
      clippedCount: (json['clippedCount'] as num?)?.toInt() ?? 0,
      deletedAt:
          const SafeDateTimeConverter().fromJson(json['deletedAt'] as String?),
      isHidden: json['isHidden'] as bool? ?? false,
      reactionEmojis: (json['reactionEmojis'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
      reactionAndUserPairCache:
          (json['reactionAndUserPairCache'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$MisskeyNoteToJson(MisskeyNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'user': instance.user.toJson(),
      'text': instance.text,
      'cw': instance.cw,
      'visibility': _$MisskeyNoteVisibilityEnumMap[instance.visibility],
      'localOnly': instance.localOnly,
      'reactionAcceptance':
          _$MisskeyReactionAcceptanceEnumMap[instance.reactionAcceptance],
      'renoteCount': instance.renoteCount,
      'repliesCount': instance.repliesCount,
      'reactionCount': instance.reactionCount,
      'reactions': instance.reactions,
      'emojis': instance.emojis,
      'fileIds': instance.fileIds,
      'files': instance.files?.map((e) => e.toJson()).toList(),
      'replyId': instance.replyId,
      'renoteId': instance.renoteId,
      'reply': instance.reply?.toJson(),
      'renote': instance.renote?.toJson(),
      'uri': instance.uri,
      'url': instance.url,
      'channelId': instance.channelId,
      'channel': instance.channel?.toJson(),
      'mentions': instance.mentions,
      'visibleUserIds': instance.visibleUserIds,
      'tags': instance.tags,
      'poll': instance.poll?.toJson(),
      'myReaction': instance.myReaction,
      'clippedCount': instance.clippedCount,
      'deletedAt': const SafeDateTimeConverter().toJson(instance.deletedAt),
      'isHidden': instance.isHidden,
      'reactionEmojis': instance.reactionEmojis,
      'reactionAndUserPairCache': instance.reactionAndUserPairCache,
    };

const _$MisskeyNoteVisibilityEnumMap = {
  MisskeyNoteVisibility.public: 'public',
  MisskeyNoteVisibility.home: 'home',
  MisskeyNoteVisibility.followers: 'followers',
  MisskeyNoteVisibility.specified: 'specified',
};

const _$MisskeyReactionAcceptanceEnumMap = {
  MisskeyReactionAcceptance.likeOnlyForRemote: 'likeOnlyForRemote',
  MisskeyReactionAcceptance.nonSensitiveOnly: 'nonSensitiveOnly',
  MisskeyReactionAcceptance.nonSensitiveOnlyForLocalLikeOnlyForRemote:
      'nonSensitiveOnlyForLocalLikeOnlyForRemote',
  MisskeyReactionAcceptance.likeOnly: 'likeOnly',
};

MisskeyNoteChannel _$MisskeyNoteChannelFromJson(Map<String, dynamic> json) =>
    MisskeyNoteChannel(
      id: json['id'] as String,
      name: json['name'] as String?,
      color: json['color'] as String?,
      isSensitive: json['isSensitive'] as bool?,
      allowRenoteToExternal: json['allowRenoteToExternal'] as bool?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$MisskeyNoteChannelToJson(MisskeyNoteChannel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'isSensitive': instance.isSensitive,
      'allowRenoteToExternal': instance.allowRenoteToExternal,
      'userId': instance.userId,
    };
