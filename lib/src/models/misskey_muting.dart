import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_user.dart';

part 'misskey_muting.freezed.dart';
part 'misskey_muting.g.dart';

/// A mute relationship (element of the `/api/mute/list` response).
@freezed
@JsonSerializable()
class MisskeyMuting with _$MisskeyMuting {
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
  @override
  final String id;

  /// The creation timestamp.
  @override
  final DateTime createdAt;

  /// The mute expiration timestamp, or `null` for indefinite mutes.
  @override
  final DateTime? expiresAt;

  /// The muted user's ID.
  @override
  final String muteeId;

  /// The muted user.
  @override
  final MisskeyUser? mutee;
}
