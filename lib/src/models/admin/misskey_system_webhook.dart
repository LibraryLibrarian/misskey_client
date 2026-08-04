import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_system_webhook.g.dart';

/// A system webhook (`/api/admin/system-webhook/*` responses).
@JsonSerializable()
class MisskeySystemWebhook {
  const MisskeySystemWebhook({
    required this.id,
    required this.isActive,
    this.updatedAt,
    this.latestSentAt,
    this.latestStatus,
    required this.name,
    required this.on,
    required this.url,
    this.secret,
  });

  factory MisskeySystemWebhook.fromJson(Map<String, dynamic> json) =>
      _$MisskeySystemWebhookFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeySystemWebhookToJson(this);

  /// The webhook ID.
  final String id;

  /// Whether the webhook is active.
  final bool isActive;

  /// The date and time when the webhook was last updated.
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The date and time of the most recent delivery attempt.
  @SafeDateTimeConverter()
  final DateTime? latestSentAt;

  /// The HTTP status code of the most recent delivery attempt.
  final num? latestStatus;

  /// The webhook name.
  final String name;

  /// The events this webhook subscribes to (e.g. `abuseReport`,
  /// `abuseReportResolved`, `userCreated`, `inactiveModeratorsWarning`,
  /// `inactiveModeratorsInvitationOnlyChanged`).
  final List<String> on;

  /// The delivery URL.
  final String url;

  /// The shared secret sent with each delivery.
  final String? secret;
}
