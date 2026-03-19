import 'package:json_annotation/json_annotation.dart';

part 'misskey_totp_registration.g.dart';

/// Response from `/api/i/2fa/register` when initiating TOTP two-factor
/// authentication registration.
@JsonSerializable()
class MisskeyTotpRegistration {
  const MisskeyTotpRegistration({
    required this.qr,
    required this.url,
    required this.secret,
    required this.label,
    required this.issuer,
  });

  factory MisskeyTotpRegistration.fromJson(Map<String, dynamic> json) =>
      _$MisskeyTotpRegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyTotpRegistrationToJson(this);

  /// Data URL of the QR code image.
  final String qr;

  /// The `otpauth` URL for authenticator apps.
  final String url;

  /// The base32-encoded TOTP secret.
  final String secret;

  /// The username label.
  final String label;

  /// The server hostname (issuer).
  final String issuer;
}
