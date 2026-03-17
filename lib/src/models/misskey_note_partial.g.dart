// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_partial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNotePartial _$MisskeyNotePartialFromJson(Map<String, dynamic> json) =>
    MisskeyNotePartial(
      id: json['id'] as String,
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          {},
      reactionEmojis: (json['reactionEmojis'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
    );

Map<String, dynamic> _$MisskeyNotePartialToJson(MisskeyNotePartial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reactions': instance.reactions,
      'reactionEmojis': instance.reactionEmojis,
    };
