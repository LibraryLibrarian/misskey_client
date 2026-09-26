import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_security_key.freezed.dart';
part 'misskey_security_key.g.dart';

/// A WebAuthn security key registered to the authenticated user.
@freezed
@JsonSerializable()
class MisskeySecurityKey with _$MisskeySecurityKey {
  const MisskeySecurityKey({
    required this.id,
    required this.name,
    required this.lastUsed,
  });

  factory MisskeySecurityKey.fromJson(Map<String, dynamic> json) =>
      _$MisskeySecurityKeyFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeySecurityKeyToJson(this);

  /// The security key ID.
  @override
  final String id;

  /// The user-assigned security key name.
  @override
  final String name;

  /// The required date and time when the security key was last used.
  ///
  /// Deserialization rejects malformed timestamps with a [FormatException].
  @override
  final DateTime lastUsed;
}
