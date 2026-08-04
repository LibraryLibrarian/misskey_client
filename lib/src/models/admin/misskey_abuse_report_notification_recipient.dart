import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_abuse_report_notification_recipient.g.dart';

/// An abuse report notification recipient
/// (`/api/admin/abuse-report/notification-recipient/*` responses).
@JsonSerializable()
class MisskeyAbuseReportNotificationRecipient {
  const MisskeyAbuseReportNotificationRecipient({
    required this.id,
    required this.isActive,
    this.updatedAt,
    required this.name,
    required this.method,
    this.userId,
    this.user,
    this.systemWebhookId,
    this.systemWebhook,
  });

  factory MisskeyAbuseReportNotificationRecipient.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MisskeyAbuseReportNotificationRecipientFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MisskeyAbuseReportNotificationRecipientToJson(this);

  /// The recipient ID.
  final String id;

  /// Whether this recipient is active.
  final bool isActive;

  /// The date and time when the recipient was last updated.
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The recipient name.
  final String name;

  /// The notification method (`email` or `webhook`).
  final String method;

  /// The target user ID (for the `email` method).
  final String? userId;

  /// The target user (for the `email` method).
  final MisskeyUser? user;

  /// The system webhook ID (for the `webhook` method).
  final String? systemWebhookId;

  /// The system webhook (for the `webhook` method), as raw JSON.
  final Map<String, dynamic>? systemWebhook;
}
