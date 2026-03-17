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

MisskeyPoll _$MisskeyPollFromJson(Map<String, dynamic> json) => MisskeyPoll(
      choices: (json['choices'] as List<dynamic>)
          .map((e) => MisskeyPollChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      multiple: json['multiple'] as bool? ?? false,
      expiresAt:
          const SafeDateTimeConverter().fromJson(json['expiresAt'] as String?),
    );
