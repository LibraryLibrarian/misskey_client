import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';
import '../misskey_user.dart';

part 'misskey_abuse_report_notification_recipient.freezed.dart';
part 'misskey_abuse_report_notification_recipient.g.dart';

/// An abuse report notification recipient
/// (`/api/admin/abuse-report/notification-recipient/*` responses).
@freezed
@JsonSerializable()
class MisskeyAbuseReportNotificationRecipient
    with _$MisskeyAbuseReportNotificationRecipient {
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
  ) => _$MisskeyAbuseReportNotificationRecipientFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MisskeyAbuseReportNotificationRecipientToJson(this);

  /// The recipient ID.
  @override
  final String id;

  /// Whether this recipient is active.
  @override
  final bool isActive;

  /// The date and time when the recipient was last updated.
  @SafeDateTimeConverter()
  @override
  final DateTime? updatedAt;

  /// The recipient name.
  @override
  final String name;

  /// The notification method (`email` or `webhook`).
  @override
  final String method;

  /// The target user ID (for the `email` method).
  @override
  final String? userId;

  /// The target user (for the `email` method).
  @override
  final MisskeyUser? user;

  /// The system webhook ID (for the `webhook` method).
  @override
  final String? systemWebhookId;

  /// The system webhook (for the `webhook` method), as raw JSON.
  @override
  final Map<String, dynamic>? systemWebhook;
}
