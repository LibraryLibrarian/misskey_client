// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNoteReaction _$MisskeyNoteReactionFromJson(Map<String, dynamic> json) =>
    MisskeyNoteReaction(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: json['type'] as String,
      user: MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyNoteReactionToJson(
        MisskeyNoteReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': instance.type,
      'user': instance.user.toJson(),
    };
