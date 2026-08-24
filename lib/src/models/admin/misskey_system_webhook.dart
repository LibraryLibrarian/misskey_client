import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_system_webhook.freezed.dart';
part 'misskey_system_webhook.g.dart';

/// A system webhook (`/api/admin/system-webhook/*` responses).
@freezed
@JsonSerializable()
class MisskeySystemWebhook with _$MisskeySystemWebhook {
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
  @override
  final String id;

  /// Whether the webhook is active.
  @override
  final bool isActive;

  /// The date and time when the webhook was last updated.
  @SafeDateTimeConverter()
  @override
  final DateTime? updatedAt;

  /// The date and time of the most recent delivery attempt.
  @SafeDateTimeConverter()
  @override
  final DateTime? latestSentAt;

  /// The HTTP status code of the most recent delivery attempt.
  @override
  final num? latestStatus;

  /// The webhook name.
  @override
  final String name;

  /// The events this webhook subscribes to (e.g. `abuseReport`,
  /// `abuseReportResolved`, `userCreated`, `inactiveModeratorsWarning`,
  /// `inactiveModeratorsInvitationOnlyChanged`).
  @override
  final List<String> on;

  /// The delivery URL.
  @override
  final String url;

  /// The shared secret sent with each delivery.
  @override
  final String? secret;
}
