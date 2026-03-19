import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_drive_file.dart';
import 'misskey_poll.dart';
import 'misskey_user.dart';

part 'misskey_note.g.dart';

/// The visibility scope of a note.
@JsonEnum()
enum MisskeyNoteVisibility {
  public,
  home,
  followers,
  specified,
}

/// The reaction acceptance setting for a note.
@JsonEnum()
enum MisskeyReactionAcceptance {
  /// null means accept all (we represent this as a default)
  likeOnlyForRemote,
  nonSensitiveOnly,
  nonSensitiveOnlyForLocalLikeOnlyForRemote,
  likeOnly,
}

/// A Misskey note (post).
@JsonSerializable()
class MisskeyNote {
  const MisskeyNote({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.user,
    this.text,
    this.cw,
    this.visibility,
    this.localOnly,
    this.reactionAcceptance,
    this.renoteCount,
    this.repliesCount,
    this.reactionCount,
    this.reactions,
    this.emojis,
    this.fileIds,
    this.files,
    this.replyId,
    this.renoteId,
    this.reply,
    this.renote,
    this.uri,
    this.url,
    this.channelId,
    this.channel,
    this.mentions,
    this.visibleUserIds,
    this.tags,
    this.poll,
    this.myReaction,
    this.clippedCount,
    this.deletedAt,
    this.isHidden,
    this.reactionEmojis,
    this.reactionAndUserPairCache,
  });

  factory MisskeyNote.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteToJson(this);

  /// The unique identifier of this note.
  final String id;

  /// The date and time when this note was created.
  final DateTime createdAt;

  /// The ID of the user who created this note.
  final String userId;

  /// The user who created this note.
  final MisskeyUser user;

  /// The body text in MFM format. Null for pure renotes.
  final String? text;

  /// The content warning (CW) text.
  final String? cw;

  /// The visibility scope of this note.
  @JsonKey(unknownEnumValue: MisskeyNoteVisibility.public)
  final MisskeyNoteVisibility? visibility;

  /// Whether this note is local-only.
  @JsonKey(defaultValue: false)
  final bool? localOnly;

  /// The reaction acceptance setting.
  final MisskeyReactionAcceptance? reactionAcceptance;

  /// The number of renotes.
  @JsonKey(defaultValue: 0)
  final int? renoteCount;

  /// The number of replies.
  @JsonKey(defaultValue: 0)
  final int? repliesCount;

  /// The total number of reactions.
  @JsonKey(defaultValue: 0)
  final int? reactionCount;

  /// A map of reactions where keys are emoji strings and values are counts.
  @JsonKey(defaultValue: <String, int>{})
  final Map<String, int>? reactions;

  /// Custom emoji map where keys are shortcodes and values are URLs.
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String>? emojis;

  /// The IDs of attached files.
  @JsonKey(defaultValue: <String>[])
  final List<String>? fileIds;

  /// The attached drive files.
  @JsonKey(defaultValue: <MisskeyDriveFile>[])
  final List<MisskeyDriveFile>? files;

  /// The ID of the note this is replying to.
  final String? replyId;

  /// The ID of the note this is renoting.
  final String? renoteId;

  /// The note this is replying to.
  final MisskeyNote? reply;

  /// The note this is renoting.
  final MisskeyNote? renote;

  /// The ActivityPub URI.
  final String? uri;

  /// The URL of the note.
  final String? url;

  /// The channel ID this note belongs to.
  final String? channelId;

  /// The channel information.
  final MisskeyNoteChannel? channel;

  /// The list of mentioned user IDs.
  final List<String>? mentions;

  /// The list of user IDs who can see this specified-visibility note.
  final List<String>? visibleUserIds;

  /// The list of hashtags.
  final List<String>? tags;

  /// The poll attached to this note.
  final MisskeyPoll? poll;

  /// The authenticated user's reaction to this note.
  final String? myReaction;

  /// The number of clips containing this note.
  @JsonKey(defaultValue: 0)
  final int? clippedCount;

  /// The date and time when this note was deleted.
  @SafeDateTimeConverter()
  final DateTime? deletedAt;

  /// Whether this note is hidden.
  @JsonKey(defaultValue: false)
  final bool? isHidden;

  /// Reaction emoji map where keys are shortcodes and values are URLs.
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String>? reactionEmojis;

  /// Cached pairs of reactions and user identifiers.
  final List<String>? reactionAndUserPairCache;
}

/// Lightweight channel information embedded in a note.
@JsonSerializable()
class MisskeyNoteChannel {
  const MisskeyNoteChannel({
    required this.id,
    this.name,
    this.color,
    this.isSensitive,
    this.allowRenoteToExternal,
    this.userId,
  });

  factory MisskeyNoteChannel.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteChannelFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyNoteChannelToJson(this);

  /// The unique identifier of this channel.
  final String id;

  /// The name of the channel.
  final String? name;

  /// The theme color of the channel.
  final String? color;

  /// Whether the channel is marked as sensitive.
  final bool? isSensitive;

  /// Whether renotes to external channels are allowed.
  final bool? allowRenoteToExternal;

  /// The ID of the user who owns this channel.
  final String? userId;
}
