// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_draft_poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNoteDraftPoll _$MisskeyNoteDraftPollFromJson(
        Map<String, dynamic> json) =>
    MisskeyNoteDraftPoll(
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      multiple: json['multiple'] as bool? ?? false,
      expiresAt:
          const SafeDateTimeConverter().fromJson(json['expiresAt'] as String?),
      expiredAfter: (json['expiredAfter'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MisskeyNoteDraftPollToJson(
        MisskeyNoteDraftPoll instance) =>
    <String, dynamic>{
      'choices': instance.choices,
      'multiple': instance.multiple,
      'expiresAt': const SafeDateTimeConverter().toJson(instance.expiresAt),
      'expiredAfter': instance.expiredAfter,
    };
