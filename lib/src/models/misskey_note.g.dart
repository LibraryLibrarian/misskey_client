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
