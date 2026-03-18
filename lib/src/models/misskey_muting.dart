import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_muting.g.dart';

/// A mute relationship (element of the `/api/mute/list` response).
@JsonSerializable()
class MisskeyMuting {
  const MisskeyMuting({
    required this.id,
    required this.createdAt,
    this.expiresAt,
    required this.muteeId,
    this.mutee,
  });

  factory MisskeyMuting.fromJson(Map<String, dynamic> json) =>
      _$MisskeyMutingFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyMutingToJson(this);

  /// The mute record ID.
  final String id;

  /// The creation timestamp.
  final DateTime createdAt;

  /// The mute expiration timestamp, or `null` for indefinite mutes.
  final DateTime? expiresAt;

  /// The muted user's ID.
  final String muteeId;

  /// The muted user.
  final MisskeyUser? mutee;
}
