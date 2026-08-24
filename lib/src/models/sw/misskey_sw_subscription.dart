import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_sw_subscription.freezed.dart';
part 'misskey_sw_subscription.g.dart';

/// Push notification subscription information.
@freezed
@JsonSerializable()
class MisskeySwSubscription with _$MisskeySwSubscription {
  const MisskeySwSubscription({
    required this.userId,
    required this.endpoint,
    required this.sendReadMessage,
  });

  factory MisskeySwSubscription.fromJson(Map<String, dynamic> json) =>
      _$MisskeySwSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeySwSubscriptionToJson(this);

  /// The user ID associated with the subscription.
  @override
  final String userId;

  /// The push notification endpoint URL.
  @override
  final String endpoint;

  /// Whether to send notifications for read messages.
  @override
  final bool sendReadMessage;
}
