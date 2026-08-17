import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_totp_registration.freezed.dart';
part 'misskey_totp_registration.g.dart';

/// Response from `/api/i/2fa/register` when initiating TOTP two-factor
/// authentication registration.
@freezed
@JsonSerializable()
class MisskeyTotpRegistration with _$MisskeyTotpRegistration {
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
  @override
  final String qr;

  /// The `otpauth` URL for authenticator apps.
  @override
  final String url;

  /// The base32-encoded TOTP secret.
  @override
  final String secret;

  /// The username label.
  @override
  final String label;

  /// The server hostname (issuer).
  @override
  final String issuer;
}
