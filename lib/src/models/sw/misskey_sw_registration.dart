import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_sw_registration.freezed.dart';
part 'misskey_sw_registration.g.dart';

/// The result of a push notification registration.
@freezed
@JsonSerializable()
class MisskeySwRegistration with _$MisskeySwRegistration {
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
  @override
  final String state;

  /// The server's VAPID public key.
  @override
  final String? key;

  /// The user ID associated with the subscription.
  @override
  final String userId;

  /// The push notification endpoint URL.
  @override
  final String endpoint;

  /// Whether to send notifications for read messages.
  @override
  final bool sendReadMessage;

  /// Whether this is a newly created subscription.
  bool get isNewSubscription => state == 'subscribed';

  /// Whether the subscription already existed.
  bool get isAlreadySubscribed => state == 'already-subscribed';
}
