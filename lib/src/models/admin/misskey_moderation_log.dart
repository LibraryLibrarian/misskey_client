import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_moderation_log.g.dart';

/// A moderation log entry (`/api/admin/show-moderation-logs`).
@JsonSerializable()
class MisskeyModerationLog {
  const MisskeyModerationLog({
    required this.id,
    this.createdAt,
    required this.type,
    this.info,
    this.userId,
    this.user,
  });

  factory MisskeyModerationLog.fromJson(Map<String, dynamic> json) =>
      _$MisskeyModerationLogFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyModerationLogToJson(this);

  /// The log entry ID.
  final String id;

  /// The date and time when the action was performed.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The action type (e.g. `suspend`, `createInvitation`, `updateMeta`).
  final String type;

  /// The action-specific payload; its shape depends on [type].
  final Map<String, dynamic>? info;

  /// The ID of the moderator who performed the action.
  final String? userId;

  /// The moderator who performed the action.
  final MisskeyUser? user;
}

/// An IP address record for a user (`/api/admin/get-user-ips`).
@JsonSerializable()
class MisskeyUserIp {
  const MisskeyUserIp({required this.ip, this.createdAt});

  factory MisskeyUserIp.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserIpFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserIpToJson(this);

  /// The IP address.
  final String ip;

  /// The date and time when the address was recorded.
  @SafeDateTimeConverter()
  final DateTime? createdAt;
}

/// A PostgreSQL index statistic (`/api/admin/get-index-stats`).
///
/// Note: the API documentation only declares `tablename` and `indexname`,
/// but Misskey 2026.5.1 also returns `schemaname`, `tablespace`, and
/// `indexdef`.
@JsonSerializable()
class MisskeyIndexStat {
  const MisskeyIndexStat({
    required this.tablename,
    required this.indexname,
    this.schemaname,
    this.tablespace,
    this.indexdef,
  });

  factory MisskeyIndexStat.fromJson(Map<String, dynamic> json) =>
      _$MisskeyIndexStatFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyIndexStatToJson(this);

  /// The table the index belongs to.
  final String tablename;

  /// The index name.
  final String indexname;

  /// The schema name.
  final String? schemaname;

  /// The tablespace, if any.
  final String? tablespace;

  /// The `CREATE INDEX` definition statement.
  final String? indexdef;
}

/// A PostgreSQL table statistic value (`/api/admin/get-table-stats`).
@JsonSerializable()
class MisskeyTableStat {
  const MisskeyTableStat({required this.count, required this.size});

  factory MisskeyTableStat.fromJson(Map<String, dynamic> json) =>
      _$MisskeyTableStatFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyTableStatToJson(this);

  /// The estimated row count (`-1` when unavailable).
  final num count;

  /// The table size in bytes.
  final num size;
}
