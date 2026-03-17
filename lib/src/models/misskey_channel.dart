import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_note.dart';

part 'misskey_channel.g.dart';

/// Misskey のチャンネル
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

  final String id;
  final DateTime createdAt;
  final String name;
  final String? description;
  final String? userId;

  @SafeDateTimeConverter()
  final DateTime? lastNotedAt;

  final String? bannerUrl;

  @JsonKey(defaultValue: <String>[])
  final List<String>? pinnedNoteIds;

  final String? color;

  @JsonKey(defaultValue: false)
  final bool? isArchived;

  @JsonKey(defaultValue: 0)
  final int? usersCount;

  @JsonKey(defaultValue: 0)
  final int? notesCount;

  @JsonKey(defaultValue: false)
  final bool? isSensitive;

  @JsonKey(defaultValue: true)
  final bool? allowRenoteToExternal;

  final bool? isFollowing;
  final bool? isFavorited;

  final List<MisskeyNote>? pinnedNotes;

  final String? bannerId;
  final bool? isMuting;
}
