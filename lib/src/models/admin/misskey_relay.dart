import 'package:json_annotation/json_annotation.dart';

part 'misskey_relay.g.dart';

/// The subscription status of a relay.
@JsonEnum()
enum MisskeyRelayStatus { requesting, accepted, rejected }

/// A relay (`/api/admin/relays/*` responses).
@JsonSerializable()
class MisskeyRelay {
  const MisskeyRelay({
    required this.id,
    required this.inbox,
    required this.status,
  });

  factory MisskeyRelay.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRelayFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRelayToJson(this);

  /// The relay ID.
  final String id;

  /// The relay's inbox URL.
  final String inbox;

  /// The subscription status.
  @JsonKey(unknownEnumValue: MisskeyRelayStatus.requesting)
  final MisskeyRelayStatus status;
}
