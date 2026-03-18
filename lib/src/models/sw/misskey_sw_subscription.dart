import 'package:json_annotation/json_annotation.dart';

part 'misskey_sw_subscription.g.dart';

/// Push notification subscription information.
@JsonSerializable()
class MisskeySwSubscription {
  const MisskeySwSubscription({
    required this.userId,
    required this.endpoint,
    required this.sendReadMessage,
  });

  factory MisskeySwSubscription.fromJson(Map<String, dynamic> json) =>
      _$MisskeySwSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeySwSubscriptionToJson(this);

  /// The user ID associated with the subscription.
  final String userId;

  /// The push notification endpoint URL.
  final String endpoint;

  /// Whether to send notifications for read messages.
  final bool sendReadMessage;
}
