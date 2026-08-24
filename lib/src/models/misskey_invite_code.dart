import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_converters.dart';
import 'misskey_user.dart';

part 'misskey_invite_code.freezed.dart';
part 'misskey_invite_code.g.dart';

/// An invite code (element of the `/api/invite/*` response).
@freezed
@JsonSerializable()
class MisskeyInviteCode with _$MisskeyInviteCode {
  const MisskeyInviteCode({
    required this.id,
    required this.code,
    required this.createdAt,
    required this.used,
    this.expiresAt,
    this.createdBy,
    this.usedBy,
    this.usedAt,
  });

  factory MisskeyInviteCode.fromJson(Map<String, dynamic> json) =>
      _$MisskeyInviteCodeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyInviteCodeToJson(this);

  /// The invite code record ID.
  @override
  final String id;

  /// The invite code string.
  @override
  final String code;

  /// The expiration timestamp.
  @SafeDateTimeConverter()
  @override
  final DateTime? expiresAt;

  /// The creation timestamp.
  @SafeDateTimeConverter()
  @override
  final DateTime createdAt;

  /// The user who created the invite code.
  @override
  final MisskeyUser? createdBy;

  /// The user who used the invite code.
  @override
  final MisskeyUser? usedBy;

  /// The timestamp when the invite code was used.
  @SafeDateTimeConverter()
  @override
  final DateTime? usedAt;

  /// Whether the invite code has been used.
  @override
  final bool used;
}
