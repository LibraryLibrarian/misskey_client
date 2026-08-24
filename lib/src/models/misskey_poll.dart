import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_converters.dart';

part 'misskey_poll.freezed.dart';
part 'misskey_poll.g.dart';

/// A poll choice.
@freezed
@JsonSerializable()
class MisskeyPollChoice with _$MisskeyPollChoice {
  const MisskeyPollChoice({
    required this.text,
    required this.votes,
    required this.isVoted,
  });

  factory MisskeyPollChoice.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPollChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyPollChoiceToJson(this);

  /// The display text of this choice.
  @override
  final String text;

  /// The number of votes for this choice.
  @JsonKey(defaultValue: 0)
  @override
  final int votes;

  /// Whether the authenticated user has voted for this choice.
  @JsonKey(defaultValue: false)
  @override
  final bool isVoted;
}

/// A Misskey poll.
@freezed
@JsonSerializable()
class MisskeyPoll with _$MisskeyPoll {
  const MisskeyPoll({required this.choices, this.multiple, this.expiresAt});

  factory MisskeyPoll.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPollFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyPollToJson(this);

  /// The list of poll choices.
  @override
  final List<MisskeyPollChoice> choices;

  /// Whether multiple choices can be selected.
  @JsonKey(defaultValue: false)
  @override
  final bool? multiple;

  /// The expiration date and time of this poll.
  @SafeDateTimeConverter()
  @override
  final DateTime? expiresAt;
}
