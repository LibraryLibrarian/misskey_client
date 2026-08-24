import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_user.dart';

part 'misskey_blocking.freezed.dart';
part 'misskey_blocking.g.dart';

/// A block relationship (element of the `/api/blocking/list` response).
@freezed
@JsonSerializable()
class MisskeyBlocking with _$MisskeyBlocking {
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
  @override
  final String id;

  /// The creation timestamp.
  @override
  final DateTime createdAt;

  /// The blocked user's ID.
  @override
  final String blockeeId;

  /// The blocked user.
  @override
  final MisskeyUser? blockee;
}
