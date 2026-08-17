import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_converters.dart';
import 'misskey_note.dart';

part 'misskey_channel.freezed.dart';
part 'misskey_channel.g.dart';

/// A Misskey channel.
@freezed
@JsonSerializable()
class MisskeyChannel with _$MisskeyChannel {
  const MisskeyChannel({
    required this.id,
    required this.createdAt,
    required this.name,
    this.description,
    this.userId,
    this.lastNotedAt,
    this.bannerUrl,
    this.pinnedNoteIds,
    this.color,
    this.isArchived,
    this.usersCount,
    this.notesCount,
    this.isSensitive,
    this.allowRenoteToExternal,
    this.isFollowing,
    this.isFavorited,
    this.pinnedNotes,
    this.bannerId,
    this.isMuting,
    this.hasUnreadNote,
  });

  factory MisskeyChannel.fromJson(Map<String, dynamic> json) =>
      _$MisskeyChannelFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyChannelToJson(this);

  /// The channel ID.
  @override
  final String id;

  /// The creation timestamp.
  @override
  final DateTime createdAt;

  /// The channel name.
  @override
  final String name;

  /// The channel description.
  @override
  final String? description;

  /// The owner user's ID.
  @override
  final String? userId;

  /// The timestamp of the last note posted in this channel.
  @SafeDateTimeConverter()
  @override
  final DateTime? lastNotedAt;

  /// The banner image URL.
  @override
  final String? bannerUrl;

  /// The IDs of pinned notes.
  @JsonKey(defaultValue: <String>[])
  @override
  final List<String>? pinnedNoteIds;

  /// The channel theme color.
  @override
  final String? color;

  /// Whether the channel is archived.
  @JsonKey(defaultValue: false)
  @override
  final bool? isArchived;

  /// The number of users following this channel.
  @JsonKey(defaultValue: 0)
  @override
  final int? usersCount;

  /// The number of notes in this channel.
  @JsonKey(defaultValue: 0)
  @override
  final int? notesCount;

  /// Whether the channel is marked as sensitive.
  @JsonKey(defaultValue: false)
  @override
  final bool? isSensitive;

  /// Whether renotes to external channels are allowed.
  @JsonKey(defaultValue: true)
  @override
  final bool? allowRenoteToExternal;

  /// Whether the current user is following this channel.
  @override
  final bool? isFollowing;

  /// Whether the current user has favorited this channel.
  @override
  final bool? isFavorited;

  /// The pinned notes.
  @override
  final List<MisskeyNote>? pinnedNotes;

  /// The banner image drive file ID.
  @override
  final String? bannerId;

  /// Whether the current user is muting this channel.
  @override
  final bool? isMuting;

  /// Whether there are unread notes in this channel for the current user.
  @JsonKey(defaultValue: false)
  @override
  final bool? hasUnreadNote;
}
