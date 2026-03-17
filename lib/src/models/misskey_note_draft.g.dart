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

Map<String, dynamic> _$MisskeyNoteDraftToJson(MisskeyNoteDraft instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
      'userId': instance.userId,
      'visibility': instance.visibility,
      'visibleUserIds': instance.visibleUserIds,
      'cw': instance.cw,
      'hashtag': instance.hashtag,
      'localOnly': instance.localOnly,
      'reactionAcceptance': instance.reactionAcceptance,
      'replyId': instance.replyId,
      'renoteId': instance.renoteId,
      'channelId': instance.channelId,
      'text': instance.text,
      'fileIds': instance.fileIds,
      'poll': instance.poll,
      'scheduledAt': instance.scheduledAt,
      'isActuallyScheduled': instance.isActuallyScheduled,
    };
