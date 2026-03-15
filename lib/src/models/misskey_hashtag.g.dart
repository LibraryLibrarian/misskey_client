// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_hashtag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyHashtag _$MisskeyHashtagFromJson(Map<String, dynamic> json) =>
    MisskeyHashtag(
      tag: json['tag'] as String,
      mentionedUsersCount: (json['mentionedUsersCount'] as num).toInt(),
      mentionedLocalUsersCount:
          (json['mentionedLocalUsersCount'] as num).toInt(),
      mentionedRemoteUsersCount:
          (json['mentionedRemoteUsersCount'] as num).toInt(),
      attachedUsersCount: (json['attachedUsersCount'] as num).toInt(),
      attachedLocalUsersCount: (json['attachedLocalUsersCount'] as num).toInt(),
      attachedRemoteUsersCount:
          (json['attachedRemoteUsersCount'] as num).toInt(),
    );
