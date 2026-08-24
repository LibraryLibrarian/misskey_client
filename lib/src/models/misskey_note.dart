import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_converters.dart';
import 'misskey_drive_file.dart';
import 'misskey_poll.dart';
import 'misskey_user.dart';

part 'misskey_note.freezed.dart';
part 'misskey_note.g.dart';

/// The visibility scope of a note.
@JsonEnum()
enum MisskeyNoteVisibility { public, home, followers, specified }

/// The reaction acceptance setting for a note.
@JsonEnum()
enum MisskeyReactionAcceptance {
  /// null means accept all (we represent this as a default)
  likeOnlyForRemote,
  nonSensitiveOnly,
  nonSensitiveOnlyForLocalLikeOnlyForRemote,
  likeOnly,

  /// Fallback for a value not yet known to this client (forward
  /// compatibility with server-side additions).
  unknown,
}

/// A Misskey note (post).
@freezed
@JsonSerializable()
class MisskeyNote with _$MisskeyNote {
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
  @override
  final String id;

  /// The date and time when this note was created.
  @override
  final DateTime createdAt;

  /// The ID of the user who created this note.
  @override
  final String userId;

  /// The user who created this note.
  @override
  final MisskeyUser user;

  /// The body text in MFM format. Null for pure renotes.
  @override
  final String? text;

  /// The content warning (CW) text.
  @override
  final String? cw;

  /// The visibility scope of this note.
  @JsonKey(unknownEnumValue: MisskeyNoteVisibility.public)
  @override
  final MisskeyNoteVisibility? visibility;

  /// Whether this note is local-only.
  @JsonKey(defaultValue: false)
  @override
  final bool? localOnly;

  /// The reaction acceptance setting.
  @JsonKey(unknownEnumValue: MisskeyReactionAcceptance.unknown)
  @override
  final MisskeyReactionAcceptance? reactionAcceptance;

  /// The number of renotes.
  @JsonKey(defaultValue: 0)
  @override
  final int? renoteCount;

  /// The number of replies.
  @JsonKey(defaultValue: 0)
  @override
  final int? repliesCount;

  /// The total number of reactions.
  @JsonKey(defaultValue: 0)
  @override
  final int? reactionCount;

  /// A map of reactions where keys are emoji strings and values are counts.
  @JsonKey(defaultValue: <String, int>{})
  @override
  final Map<String, int>? reactions;

  /// Custom emoji map where keys are shortcodes and values are URLs.
  @JsonKey(defaultValue: <String, String>{})
  @override
  final Map<String, String>? emojis;

  /// The IDs of attached files.
  @JsonKey(defaultValue: <String>[])
  @override
  final List<String>? fileIds;

  /// The attached drive files.
  @JsonKey(defaultValue: <MisskeyDriveFile>[])
  @override
  final List<MisskeyDriveFile>? files;

  /// The ID of the note this is replying to.
  @override
  final String? replyId;

  /// The ID of the note this is renoting.
  @override
  final String? renoteId;

  /// The note this is replying to.
  @override
  final MisskeyNote? reply;

  /// The note this is renoting.
  @override
  final MisskeyNote? renote;

  /// The ActivityPub URI.
  @override
  final String? uri;

  /// The URL of the note.
  @override
  final String? url;

  /// The channel ID this note belongs to.
  @override
  final String? channelId;

  /// The channel information.
  @override
  final MisskeyNoteChannel? channel;

  /// The list of mentioned user IDs.
  @override
  final List<String>? mentions;

  /// The list of user IDs who can see this specified-visibility note.
  @override
  final List<String>? visibleUserIds;

  /// The list of hashtags.
  @override
  final List<String>? tags;

  /// The poll attached to this note.
  @override
  final MisskeyPoll? poll;

  /// The authenticated user's reaction to this note.
  @override
  final String? myReaction;

  /// The number of clips containing this note.
  @JsonKey(defaultValue: 0)
  @override
  final int? clippedCount;

  /// The date and time when this note was deleted.
  @SafeDateTimeConverter()
  @override
  final DateTime? deletedAt;

  /// Whether this note is hidden.
  @JsonKey(defaultValue: false)
  @override
  final bool? isHidden;

  /// Reaction emoji map where keys are shortcodes and values are URLs.
  @JsonKey(defaultValue: <String, String>{})
  @override
  final Map<String, String>? reactionEmojis;

  /// Cached pairs of reactions and user identifiers.
  @override
  final List<String>? reactionAndUserPairCache;
}

/// Lightweight channel information embedded in a note.
@freezed
@JsonSerializable()
class MisskeyNoteChannel with _$MisskeyNoteChannel {
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
  @override
  final String id;

  /// The name of the channel.
  @override
  final String? name;

  /// The theme color of the channel.
  @override
  final String? color;

  /// Whether the channel is marked as sensitive.
  @override
  final bool? isSensitive;

  /// Whether renotes to external channels are allowed.
  @override
  final bool? allowRenoteToExternal;

  /// The ID of the user who owns this channel.
  @override
  final String? userId;
}
