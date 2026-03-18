import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';

part 'misskey_poll.g.dart';

/// A poll choice.
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

  /// The display text of this choice.
  final String text;

  /// The number of votes for this choice.
  @JsonKey(defaultValue: 0)
  final int votes;

  /// Whether the authenticated user has voted for this choice.
  @JsonKey(defaultValue: false)
  final bool isVoted;
}

/// A Misskey poll.
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

  /// The list of poll choices.
  final List<MisskeyPollChoice> choices;

  /// Whether multiple choices can be selected.
  @JsonKey(defaultValue: false)
  final bool? multiple;

  /// The expiration date and time of this poll.
  @SafeDateTimeConverter()
  final DateTime? expiresAt;
}
