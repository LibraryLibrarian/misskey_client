import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_user.dart';

part 'misskey_invite_code.g.dart';

/// An invite code (element of the `/api/invite/*` response).
@JsonSerializable()
class MisskeyInviteCode {
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
  final String id;

  /// The invite code string.
  final String code;

  /// The expiration timestamp.
  @SafeDateTimeConverter()
  final DateTime? expiresAt;

  /// The creation timestamp.
  @SafeDateTimeConverter()
  final DateTime createdAt;

  /// The user who created the invite code.
  final MisskeyUser? createdBy;

  /// The user who used the invite code.
  final MisskeyUser? usedBy;

  /// The timestamp when the invite code was used.
  @SafeDateTimeConverter()
  final DateTime? usedAt;

  /// Whether the invite code has been used.
  final bool used;
}
