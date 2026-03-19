import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_poll.dart';

part 'misskey_note_draft.g.dart';

/// A note draft (`/api/notes/drafts/*`).
@JsonSerializable()
class MisskeyNoteDraft {
  const MisskeyNoteDraft({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.visibility,
    this.visibleUserIds,
    this.cw,
    this.hashtag,
    this.localOnly,
    this.reactionAcceptance,
    this.replyId,
    this.renoteId,
    this.channelId,
    this.text,
    this.fileIds,
    this.poll,
    this.scheduledAt,
    this.isActuallyScheduled,
  });

  factory MisskeyNoteDraft.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteDraftFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteDraftToJson(this);

  /// The unique identifier of this draft.
  final String id;

  /// The date and time when this draft was created.
  final DateTime createdAt;

  /// The date and time when this draft was last updated.
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The ID of the user who owns this draft.
  final String userId;

  /// The visibility scope (`public` / `home` / `followers` / `specified`).
  final String? visibility;

  /// The list of user IDs for specified visibility.
  @JsonKey(defaultValue: <String>[])
  final List<String>? visibleUserIds;

  /// The content warning text.
  final String? cw;

  /// The hashtag.
  final String? hashtag;

  /// Whether this draft is local-only.
  @JsonKey(defaultValue: false)
  final bool? localOnly;

  /// The reaction acceptance setting.
  final String? reactionAcceptance;

  /// The ID of the note this is replying to.
  final String? replyId;

  /// The ID of the note this is renoting.
  final String? renoteId;

  /// The channel ID this draft belongs to.
  final String? channelId;

  /// The body text.
  final String? text;

  /// The list of attached file IDs.
  @JsonKey(defaultValue: <String>[])
  final List<String>? fileIds;

  /// The poll attached to this draft.
  final MisskeyPoll? poll;

  /// The scheduled post time as a Unix timestamp in milliseconds.
  final int? scheduledAt;

  /// Whether the scheduled posting is active.
  @JsonKey(defaultValue: false)
  final bool? isActuallyScheduled;
}
