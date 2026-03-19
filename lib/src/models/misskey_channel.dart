import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_note.dart';

part 'misskey_channel.g.dart';

/// A Misskey channel.
@JsonSerializable()
class MisskeyChannel {
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
  });

  factory MisskeyChannel.fromJson(Map<String, dynamic> json) =>
      _$MisskeyChannelFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyChannelToJson(this);

  /// The channel ID.
  final String id;

  /// The creation timestamp.
  final DateTime createdAt;

  /// The channel name.
  final String name;

  /// The channel description.
  final String? description;

  /// The owner user's ID.
  final String? userId;

  /// The timestamp of the last note posted in this channel.
  @SafeDateTimeConverter()
  final DateTime? lastNotedAt;

  /// The banner image URL.
  final String? bannerUrl;

  /// The IDs of pinned notes.
  @JsonKey(defaultValue: <String>[])
  final List<String>? pinnedNoteIds;

  /// The channel theme color.
  final String? color;

  /// Whether the channel is archived.
  @JsonKey(defaultValue: false)
  final bool? isArchived;

  /// The number of users following this channel.
  @JsonKey(defaultValue: 0)
  final int? usersCount;

  /// The number of notes in this channel.
  @JsonKey(defaultValue: 0)
  final int? notesCount;

  /// Whether the channel is marked as sensitive.
  @JsonKey(defaultValue: false)
  final bool? isSensitive;

  /// Whether renotes to external channels are allowed.
  @JsonKey(defaultValue: true)
  final bool? allowRenoteToExternal;

  /// Whether the current user is following this channel.
  final bool? isFollowing;

  /// Whether the current user has favorited this channel.
  final bool? isFavorited;

  /// The pinned notes.
  final List<MisskeyNote>? pinnedNotes;

  /// The banner image drive file ID.
  final String? bannerId;

  /// Whether the current user is muting this channel.
  final bool? isMuting;
}
