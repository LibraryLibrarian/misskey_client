// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyPollChoice _$MisskeyPollChoiceFromJson(Map<String, dynamic> json) =>
    MisskeyPollChoice(
      text: json['text'] as String,
      votes: (json['votes'] as num?)?.toInt() ?? 0,
      isVoted: json['isVoted'] as bool? ?? false,
    );

Map<String, dynamic> _$MisskeyPollChoiceToJson(MisskeyPollChoice instance) =>
    <String, dynamic>{
      'text': instance.text,
      'votes': instance.votes,
      'isVoted': instance.isVoted,
    };

MisskeyPoll _$MisskeyPollFromJson(Map<String, dynamic> json) => MisskeyPoll(
      choices: (json['choices'] as List<dynamic>)
          .map((e) => MisskeyPollChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      multiple: json['multiple'] as bool? ?? false,
      expiresAt:
          const SafeDateTimeConverter().fromJson(json['expiresAt'] as String?),
    );

Map<String, dynamic> _$MisskeyPollToJson(MisskeyPoll instance) =>
    <String, dynamic>{
      'choices': instance.choices.map((e) => e.toJson()).toList(),
      'multiple': instance.multiple,
      'expiresAt': const SafeDateTimeConverter().toJson(instance.expiresAt),
    };
