import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_abuse_user_report.g.dart';

/// An abuse report (element of the `/api/admin/abuse-user-reports` response).
@JsonSerializable()
class MisskeyAbuseUserReport {
  const MisskeyAbuseUserReport({
    required this.id,
    this.createdAt,
    required this.comment,
    required this.resolved,
    this.reporterId,
    this.targetUserId,
    this.assigneeId,
    this.reporter,
    this.targetUser,
    this.assignee,
    this.forwarded,
    this.resolvedAs,
    this.moderationNote,
  });

  factory MisskeyAbuseUserReport.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAbuseUserReportFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAbuseUserReportToJson(this);

  /// The report ID.
  final String id;

  /// The date and time when the report was created.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The report comment written by the reporter.
  final String comment;

  /// Whether the report has been resolved.
  final bool resolved;

  /// The reporter's user ID.
  final String? reporterId;

  /// The reported user's ID.
  final String? targetUserId;

  /// The assigned moderator's user ID.
  final String? assigneeId;

  /// The reporter.
  final MisskeyUser? reporter;

  /// The reported user.
  final MisskeyUser? targetUser;

  /// The assigned moderator.
  final MisskeyUser? assignee;

  /// Whether the report was forwarded to the remote instance.
  final bool? forwarded;

  /// The resolution kind (`accept`, `reject`, or `null`).
  final String? resolvedAs;

  /// The moderation note visible only to moderators.
  final String? moderationNote;
}
