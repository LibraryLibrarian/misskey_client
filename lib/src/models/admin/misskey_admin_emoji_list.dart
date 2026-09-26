import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_admin_emoji_list.freezed.dart';
part 'misskey_admin_emoji_list.g.dart';

/// Filters accepted by `/api/v2/admin/emoji/list`.
@freezed
@JsonSerializable(includeIfNull: false)
class MisskeyAdminEmojiListQuery with _$MisskeyAdminEmojiListQuery {
  const MisskeyAdminEmojiListQuery({
    this.updatedAtFrom,
    this.updatedAtTo,
    this.name,
    this.host,
    this.uri,
    this.publicUrl,
    this.originalUrl,
    this.type,
    this.aliases,
    this.category,
    this.license,
    this.isSensitive,
    this.localOnly,
    this.hostType,
    this.roleIds,
  });

  factory MisskeyAdminEmojiListQuery.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdminEmojiListQueryFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdminEmojiListQueryToJson(this);

  /// Inclusive lower bound for the emoji update timestamp.
  @override
  final String? updatedAtFrom;

  /// Inclusive upper bound for the emoji update timestamp.
  @override
  final String? updatedAtTo;

  /// Name search text.
  @override
  final String? name;

  /// Host search text.
  @override
  final String? host;

  /// ActivityPub URI search text.
  @override
  final String? uri;

  /// Public image URL search text.
  @override
  final String? publicUrl;

  /// Original image URL search text.
  ///
  /// The current upstream schema accepts this field, but the develop handler
  /// does not apply it to the search query. It therefore has no effect until
  /// that upstream behavior changes.
  @override
  final String? originalUrl;

  /// MIME type search text.
  @override
  final String? type;

  /// Alias search text.
  @override
  final String? aliases;

  /// Category search text.
  @override
  final String? category;

  /// License search text.
  @override
  final String? license;

  /// Filters by the sensitive flag.
  @override
  final bool? isSensitive;

  /// Filters by the local-only flag.
  @override
  final bool? localOnly;

  /// Host scope: `local`, `remote`, or `all` (the server default).
  @override
  final String? hostType;

  /// Role IDs allowed to use the emoji as a reaction.
  @override
  final List<String>? roleIds;
}

/// A role summarized in an admin emoji response.
@freezed
@JsonSerializable()
class MisskeyAdminEmojiRole with _$MisskeyAdminEmojiRole {
  const MisskeyAdminEmojiRole({required this.id, required this.name});

  factory MisskeyAdminEmojiRole.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdminEmojiRoleFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdminEmojiRoleToJson(this);

  /// The role ID.
  @override
  final String id;

  /// The role name.
  @override
  final String name;
}

/// Detailed custom emoji returned by `/api/v2/admin/emoji/list`.
@freezed
@JsonSerializable()
class MisskeyAdminEmojiDetailed with _$MisskeyAdminEmojiDetailed {
  const MisskeyAdminEmojiDetailed({
    required this.id,
    required this.updatedAt,
    required this.name,
    required this.host,
    required this.publicUrl,
    required this.originalUrl,
    required this.uri,
    required this.type,
    required this.aliases,
    required this.category,
    required this.license,
    required this.localOnly,
    required this.isSensitive,
    required this.roleIdsThatCanBeUsedThisEmojiAsReaction,
  });

  factory MisskeyAdminEmojiDetailed.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdminEmojiDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdminEmojiDetailedToJson(this);

  /// The emoji ID.
  @override
  final String id;

  /// The most recent update time, if recorded by the server.
  @override
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The emoji shortcode.
  @override
  final String name;

  /// The remote host, or `null` for a local emoji.
  @override
  final String? host;

  /// The public image URL.
  @override
  final String publicUrl;

  /// The original image URL.
  @override
  final String originalUrl;

  /// The ActivityPub URI, if the emoji is federated.
  @override
  final String? uri;

  /// The image MIME type, if known.
  @override
  final String? type;

  /// The emoji aliases.
  @override
  final List<String> aliases;

  /// The emoji category.
  @override
  final String? category;

  /// The emoji license information.
  @override
  final String? license;

  /// Whether the emoji is restricted to local use.
  @override
  final bool localOnly;

  /// Whether the emoji is marked as sensitive.
  @override
  final bool isSensitive;

  /// Roles permitted to use the emoji as a reaction.
  ///
  /// The upstream wire key retains the historical `roleIds...` name even
  /// though v2 returns role summaries rather than bare IDs.
  @override
  final List<MisskeyAdminEmojiRole> roleIdsThatCanBeUsedThisEmojiAsReaction;
}

/// Paginated response returned by `/api/v2/admin/emoji/list`.
@freezed
@JsonSerializable()
class MisskeyAdminEmojiListResult with _$MisskeyAdminEmojiListResult {
  const MisskeyAdminEmojiListResult({
    required this.emojis,
    required this.count,
    required this.allCount,
    required this.allPages,
  });

  factory MisskeyAdminEmojiListResult.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdminEmojiListResultFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdminEmojiListResultToJson(this);

  /// Emojis on the current page.
  @override
  final List<MisskeyAdminEmojiDetailed> emojis;

  /// Number of emojis in [emojis].
  @override
  final int count;

  /// Total number of emojis matching the query.
  @override
  final int allCount;

  /// Total number of pages matching the query.
  @override
  final int allPages;
}
