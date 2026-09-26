import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_converters.dart';
import 'misskey_drive_file.dart';
import 'misskey_note.dart';
import 'misskey_note_draft_channel.dart';
import 'misskey_note_draft_poll.dart';
import 'misskey_user.dart';

part 'misskey_note_draft.freezed.dart';
part 'misskey_note_draft.g.dart';

/// A note draft (`/api/notes/drafts/*`).
@freezed
@JsonSerializable()
class MisskeyNoteDraft with _$MisskeyNoteDraft {
  const MisskeyNoteDraft({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.user,
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
    this.files,
    this.channel,
    this.renote,
    this.reply,
    this.poll,
    this.scheduledAt,
    this.isActuallyScheduled,
  });

  factory MisskeyNoteDraft.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteDraftFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteDraftToJson(this);

  /// The unique identifier of this draft.
  @override
  final String id;

  /// The date and time when this draft was created.
  @override
  final DateTime createdAt;

  /// The date and time when this draft was last updated.
  @SafeDateTimeConverter()
  @override
  final DateTime? updatedAt;

  /// The ID of the user who owns this draft.
  @override
  final String userId;

  /// The user who owns this draft.
  @override
  final MisskeyUser? user;

  /// The visibility scope (`public` / `home` / `followers` / `specified`).
  @override
  final String? visibility;

  /// The list of user IDs for specified visibility.
  @JsonKey(defaultValue: <String>[])
  @override
  final List<String>? visibleUserIds;

  /// The content warning text.
  @override
  final String? cw;

  /// The hashtag.
  @override
  final String? hashtag;

  /// Whether this draft is local-only.
  @JsonKey(defaultValue: false)
  @override
  final bool? localOnly;

  /// The reaction acceptance setting.
  @override
  final String? reactionAcceptance;

  /// The ID of the note this is replying to.
  @override
  final String? replyId;

  /// The ID of the note this is renoting.
  @override
  final String? renoteId;

  /// The channel ID this draft belongs to.
  @override
  final String? channelId;

  /// The body text.
  @override
  final String? text;

  /// The list of attached file IDs.
  @JsonKey(defaultValue: <String>[])
  @override
  final List<String>? fileIds;

  /// The files attached to this draft.
  @override
  final List<MisskeyDriveFile>? files;

  /// The partial channel information embedded in this draft.
  @override
  final MisskeyNoteDraftChannel? channel;

  /// The note renoted by this draft.
  @override
  final MisskeyNote? renote;

  /// The note replied to by this draft.
  @override
  final MisskeyNote? reply;

  /// The poll attached to this draft.
  ///
  /// Drafts use their own poll shape, not the published-note one: the choices
  /// are plain strings and the deadline may still be relative.
  @override
  final MisskeyNoteDraftPoll? poll;

  /// The scheduled post time as a Unix timestamp in milliseconds.
  @override
  final int? scheduledAt;

  /// Whether the scheduled posting is active.
  @JsonKey(defaultValue: false)
  @override
  final bool? isActuallyScheduled;
}
