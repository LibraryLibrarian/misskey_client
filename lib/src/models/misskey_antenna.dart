import 'package:json_annotation/json_annotation.dart';

part 'misskey_antenna.g.dart';

/// A Misskey antenna (custom timeline filter).
@JsonSerializable()
class MisskeyAntenna {
  const MisskeyAntenna({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.keywords,
    required this.excludeKeywords,
    required this.src,
    this.userListId,
    required this.users,
    required this.caseSensitive,
    required this.localOnly,
    required this.excludeBots,
    required this.withReplies,
    required this.withFile,
    required this.excludeNotesInSensitiveChannel,
    required this.isActive,
    this.hasUnreadNote = false,
    this.notify = false,
  });

  factory MisskeyAntenna.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAntennaFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAntennaToJson(this);

  /// The antenna ID.
  final String id;

  /// The creation timestamp.
  final DateTime createdAt;

  /// The antenna name (1--100 characters).
  final String name;

  /// The keywords to match (outer list is OR, inner list is AND).
  final List<List<String>> keywords;

  /// The keywords to exclude (outer list is OR, inner list is AND).
  final List<List<String>> excludeKeywords;

  /// The source type (`home` / `all` / `users` / `list` / `users_blacklist`).
  final String src;

  /// The user list ID when [src] is `list`.
  final String? userListId;

  /// The target usernames when [src] is `users` or `users_blacklist`.
  final List<String> users;

  /// Whether keyword matching is case-sensitive.
  final bool caseSensitive;

  /// Whether only local notes are targeted.
  final bool localOnly;

  /// Whether bot accounts are excluded.
  final bool excludeBots;

  /// Whether replies are included.
  final bool withReplies;

  /// Whether only notes with files are targeted.
  final bool withFile;

  /// Whether notes in sensitive channels are excluded.
  final bool excludeNotesInSensitiveChannel;

  /// Whether the antenna is currently active.
  final bool isActive;

  /// Whether there are unread notes.
  @JsonKey(defaultValue: false)
  final bool hasUnreadNote;

  /// Whether notifications are enabled.
  @JsonKey(defaultValue: false)
  final bool notify;
}
