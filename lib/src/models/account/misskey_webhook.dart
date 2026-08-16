import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_webhook.freezed.dart';
part 'misskey_webhook.g.dart';

/// A user-defined webhook.
@freezed
@JsonSerializable()
class MisskeyWebhook with _$MisskeyWebhook {
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
  @override
  final String id;

  /// The user ID of the webhook owner.
  @override
  final String userId;

  /// The webhook name.
  @override
  final String name;

  /// The event types to subscribe to.
  ///
  /// Valid values: `mention`, `unfollow`, `follow`, `followed`,
  /// `note`, `reply`, `renote`, `reaction`.
  @override
  final List<String> on;

  /// The destination URL.
  @override
  final String url;

  /// The secret used for request signing.
  @override
  final String secret;

  /// Whether the webhook is active.
  @override
  final bool active;

  /// The date and time of the last delivery.
  @SafeDateTimeConverter()
  @override
  final DateTime? latestSentAt;

  /// The HTTP status code from the last delivery.
  @override
  final int? latestStatus;
}
