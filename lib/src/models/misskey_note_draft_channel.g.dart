// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_draft_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNoteDraftChannel _$MisskeyNoteDraftChannelFromJson(
  Map<String, dynamic> json,
) => MisskeyNoteDraftChannel(
  id: json['id'] as String,
  name: json['name'] as String,
  color: json['color'] as String,
  isSensitive: json['isSensitive'] as bool,
  allowRenoteToExternal: json['allowRenoteToExternal'] as bool,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$MisskeyNoteDraftChannelToJson(
  MisskeyNoteDraftChannel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
  'isSensitive': instance.isSensitive,
  'allowRenoteToExternal': instance.allowRenoteToExternal,
  'userId': instance.userId,
};
