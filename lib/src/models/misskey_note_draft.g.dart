// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNoteDraft _$MisskeyNoteDraftFromJson(Map<String, dynamic> json) =>
    MisskeyNoteDraft(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt:
          const SafeDateTimeConverter().fromJson(json['updatedAt'] as String?),
      userId: json['userId'] as String,
      visibility: json['visibility'] as String?,
      visibleUserIds: (json['visibleUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      cw: json['cw'] as String?,
      hashtag: json['hashtag'] as String?,
      localOnly: json['localOnly'] as bool? ?? false,
      reactionAcceptance: json['reactionAcceptance'] as String?,
      replyId: json['replyId'] as String?,
      renoteId: json['renoteId'] as String?,
      channelId: json['channelId'] as String?,
      text: json['text'] as String?,
      fileIds: (json['fileIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      poll: json['poll'] == null
          ? null
          : MisskeyPoll.fromJson(json['poll'] as Map<String, dynamic>),
      scheduledAt: (json['scheduledAt'] as num?)?.toInt(),
      isActuallyScheduled: json['isActuallyScheduled'] as bool? ?? false,
    );
