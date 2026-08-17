import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_moderation_log.freezed.dart';
part 'misskey_moderation_log.g.dart';

/// A moderation log entry (`/api/admin/show-moderation-logs`).
@freezed
@JsonSerializable()
class MisskeyModerationLog with _$MisskeyModerationLog {
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
  @override
  final String id;

  /// The date and time when the action was performed.
  @SafeDateTimeConverter()
  @override
  final DateTime? createdAt;

  /// The action type (e.g. `suspend`, `createInvitation`, `updateMeta`).
  @override
  final String type;

  /// The action-specific payload; its shape depends on [type].
  @override
  final Map<String, dynamic>? info;

  /// The ID of the moderator who performed the action.
  @override
  final String? userId;

  /// The moderator who performed the action.
  @override
  final MisskeyUser? user;
}

/// An IP address record for a user (`/api/admin/get-user-ips`).
@freezed
@JsonSerializable()
class MisskeyUserIp with _$MisskeyUserIp {
  const MisskeyUserIp({required this.ip, this.createdAt});

  factory MisskeyUserIp.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserIpFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserIpToJson(this);

  /// The IP address.
  @override
  final String ip;

  /// The date and time when the address was recorded.
  @SafeDateTimeConverter()
  @override
  final DateTime? createdAt;
}

/// A PostgreSQL index statistic (`/api/admin/get-index-stats`).
///
/// Note: the API documentation only declares `tablename` and `indexname`,
/// but Misskey 2026.5.1 also returns `schemaname`, `tablespace`, and
/// `indexdef`.
@freezed
@JsonSerializable()
class MisskeyIndexStat with _$MisskeyIndexStat {
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
  @override
  final String tablename;

  /// The index name.
  @override
  final String indexname;

  /// The schema name.
  @override
  final String? schemaname;

  /// The tablespace, if any.
  @override
  final String? tablespace;

  /// The `CREATE INDEX` definition statement.
  @override
  final String? indexdef;
}

/// A PostgreSQL table statistic value (`/api/admin/get-table-stats`).
@freezed
@JsonSerializable()
class MisskeyTableStat with _$MisskeyTableStat {
  const MisskeyTableStat({required this.count, required this.size});

  factory MisskeyTableStat.fromJson(Map<String, dynamic> json) =>
      _$MisskeyTableStatFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyTableStatToJson(this);

  /// The estimated row count (`-1` when unavailable).
  @override
  final num count;

  /// The table size in bytes.
  @override
  final num size;
}
