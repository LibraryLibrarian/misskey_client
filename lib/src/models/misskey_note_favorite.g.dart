// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNoteFavorite _$MisskeyNoteFavoriteFromJson(Map<String, dynamic> json) =>
    MisskeyNoteFavorite(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      noteId: json['noteId'] as String,
      note: json['note'] == null
          ? null
          : MisskeyNote.fromJson(json['note'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyNoteFavoriteToJson(
        MisskeyNoteFavorite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'noteId': instance.noteId,
      'note': instance.note?.toJson(),
    };
