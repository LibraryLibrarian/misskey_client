import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_renote_muting.g.dart';

/// A renote mute record (element of `/api/renote-mute/list` response).
@JsonSerializable()
class MisskeyRenoteMuting {
  const MisskeyRenoteMuting({
    required this.id,
    required this.createdAt,
    required this.muteeId,
    this.mutee,
  });

  factory MisskeyRenoteMuting.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRenoteMutingFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRenoteMutingToJson(this);

  /// The unique identifier of this mute record.
  final String id;

  /// The date and time when this mute was created.
  final DateTime createdAt;

  /// The ID of the muted user.
  final String muteeId;

  /// The muted user.
  final MisskeyUser? mutee;
}
