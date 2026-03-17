import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';

part 'misskey_poll.g.dart';

/// 投票の選択肢
@JsonSerializable()
class MisskeyPollChoice {
  const MisskeyPollChoice({
    required this.text,
    required this.votes,
    required this.isVoted,
  });

  factory MisskeyPollChoice.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPollChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyPollChoiceToJson(this);

  final String text;

  @JsonKey(defaultValue: 0)
  final int votes;

  @JsonKey(defaultValue: false)
  final bool isVoted;
}

/// Misskey の投票
@JsonSerializable()
class MisskeyPoll {
  const MisskeyPoll({
    required this.choices,
    this.multiple,
    this.expiresAt,
  });

  factory MisskeyPoll.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPollFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyPollToJson(this);

  final List<MisskeyPollChoice> choices;

  @JsonKey(defaultValue: false)
  final bool? multiple;

  @SafeDateTimeConverter()
  final DateTime? expiresAt;
}
