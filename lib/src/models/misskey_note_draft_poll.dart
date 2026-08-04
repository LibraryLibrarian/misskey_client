import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';

part 'misskey_note_draft_poll.g.dart';

/// A poll attached to a note draft.
///
/// This is not the same shape as `MisskeyPoll`, which represents a poll on a
/// published note. A draft only stores what was typed into the composer, so
/// its choices are plain strings with no vote counts, and the deadline may be
/// expressed as a relative duration that has not been resolved yet.
@JsonSerializable()
class MisskeyNoteDraftPoll {
  const MisskeyNoteDraftPoll({
    required this.choices,
    this.multiple,
    this.expiresAt,
    this.expiredAfter,
  });

  factory MisskeyNoteDraftPoll.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteDraftPollFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteDraftPollToJson(this);

  /// The poll choices, as plain text.
  @JsonKey(defaultValue: <String>[])
  final List<String> choices;

  /// Whether multiple choices can be selected.
  @JsonKey(defaultValue: false)
  final bool? multiple;

  /// The absolute expiration date and time, when one was set.
  @SafeDateTimeConverter()
  final DateTime? expiresAt;

  /// The expiration period in milliseconds, relative to the time the draft is
  /// posted, when a relative deadline was set instead of [expiresAt].
  final int? expiredAfter;
}
