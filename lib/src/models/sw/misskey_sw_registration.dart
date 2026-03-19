import 'package:json_annotation/json_annotation.dart';

part 'misskey_sw_registration.g.dart';

/// The result of a push notification registration.
@JsonSerializable()
class MisskeySwRegistration {
  const MisskeySwRegistration({
    required this.state,
    required this.key,
    required this.userId,
    required this.endpoint,
    required this.sendReadMessage,
  });

  factory MisskeySwRegistration.fromJson(Map<String, dynamic> json) =>
      _$MisskeySwRegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeySwRegistrationToJson(this);

  /// The registration state (`'subscribed'` or `'already-subscribed'`).
  final String state;

  /// The server's VAPID public key.
  final String? key;

  /// The user ID associated with the subscription.
  final String userId;

  /// The push notification endpoint URL.
  final String endpoint;

  /// Whether to send notifications for read messages.
  final bool sendReadMessage;

  /// Whether this is a newly created subscription.
  bool get isNewSubscription => state == 'subscribed';

  /// Whether the subscription already existed.
  bool get isAlreadySubscribed => state == 'already-subscribed';
}
