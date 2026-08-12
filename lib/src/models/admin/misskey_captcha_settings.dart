import 'package:json_annotation/json_annotation.dart';

part 'misskey_captcha_settings.g.dart';

/// The CAPTCHA settings of the instance (`/api/admin/captcha/current`).
@JsonSerializable()
class MisskeyCaptchaSettings {
  const MisskeyCaptchaSettings({
    required this.provider,
    this.hcaptcha,
    this.mcaptcha,
    this.recaptcha,
    this.turnstile,
  });

  factory MisskeyCaptchaSettings.fromJson(Map<String, dynamic> json) =>
      _$MisskeyCaptchaSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyCaptchaSettingsToJson(this);

  /// The active provider (`none`, `hcaptcha`, `mcaptcha`, `recaptcha`,
  /// `turnstile`, or `testcaptcha`).
  final String provider;

  /// The hCaptcha keys.
  final MisskeyCaptchaKeys? hcaptcha;

  /// The mCaptcha keys.
  final MisskeyCaptchaKeys? mcaptcha;

  /// The reCAPTCHA keys.
  final MisskeyCaptchaKeys? recaptcha;

  /// The Turnstile keys.
  final MisskeyCaptchaKeys? turnstile;
}

/// The site/secret key pair of a CAPTCHA provider.
@JsonSerializable()
class MisskeyCaptchaKeys {
  const MisskeyCaptchaKeys({this.siteKey, this.secretKey, this.instanceUrl});

  factory MisskeyCaptchaKeys.fromJson(Map<String, dynamic> json) =>
      _$MisskeyCaptchaKeysFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyCaptchaKeysToJson(this);

  /// The site key.
  final String? siteKey;

  /// The secret key.
  final String? secretKey;

  /// The instance URL (mCaptcha only).
  final String? instanceUrl;
}
