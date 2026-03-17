import 'package:json_annotation/json_annotation.dart';

part 'misskey_totp_registration.g.dart';

/// TOTP二要素認証の登録開始時レスポンス（`/api/i/2fa/register`）
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

  /// QRコード画像のDataURL
  final String qr;

  /// 認証アプリ用のotpauth URL
  final String url;

  /// base32エンコード済みのTOTPシークレット
  final String secret;

  /// ユーザー名ラベル
  final String label;

  /// サーバーホスト名（発行者）
  final String issuer;
}
