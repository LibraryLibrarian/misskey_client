import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_webhook.g.dart';

/// A user-defined webhook.
@JsonSerializable()
class MisskeyWebhook {
  const MisskeyWebhook({
    required this.id,
    required this.userId,
    required this.name,
    required this.on,
    required this.url,
    required this.secret,
    required this.active,
    this.latestSentAt,
    this.latestStatus,
  });

  factory MisskeyWebhook.fromJson(Map<String, dynamic> json) =>
      _$MisskeyWebhookFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyWebhookToJson(this);

  /// The webhook ID.
  final String id;

  /// The user ID of the webhook owner.
  final String userId;

  /// The webhook name.
  final String name;

  /// The event types to subscribe to.
  ///
  /// Valid values: `mention`, `unfollow`, `follow`, `followed`,
  /// `note`, `reply`, `renote`, `reaction`.
  final List<String> on;

  /// The destination URL.
  final String url;

  /// The secret used for request signing.
  final String secret;

  /// Whether the webhook is active.
  final bool active;

  /// The date and time of the last delivery.
  @SafeDateTimeConverter()
  final DateTime? latestSentAt;

  /// The HTTP status code from the last delivery.
  final int? latestStatus;
}
