import 'package:json_annotation/json_annotation.dart';

import 'misskey_user.dart';

part 'misskey_blocking.g.dart';

/// A block relationship (element of the `/api/blocking/list` response).
@JsonSerializable()
class MisskeyBlocking {
  const MisskeyBlocking({
    required this.id,
    required this.createdAt,
    required this.blockeeId,
    this.blockee,
  });

  factory MisskeyBlocking.fromJson(Map<String, dynamic> json) =>
      _$MisskeyBlockingFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyBlockingToJson(this);

  /// The block record ID.
  final String id;

  /// The creation timestamp.
  final DateTime createdAt;

  /// The blocked user's ID.
  final String blockeeId;

  /// The blocked user.
  final MisskeyUser? blockee;
}
