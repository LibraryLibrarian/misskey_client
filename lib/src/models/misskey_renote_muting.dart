import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_user.dart';

part 'misskey_renote_muting.freezed.dart';
part 'misskey_renote_muting.g.dart';

/// A renote mute record (element of `/api/renote-mute/list` response).
@freezed
@JsonSerializable()
class MisskeyRenoteMuting with _$MisskeyRenoteMuting {
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
  @override
  final String id;

  /// The date and time when this mute was created.
  @override
  final DateTime createdAt;

  /// The ID of the muted user.
  @override
  final String muteeId;

  /// The muted user.
  @override
  final MisskeyUser? mutee;
}
