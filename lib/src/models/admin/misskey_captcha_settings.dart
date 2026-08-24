import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_captcha_settings.freezed.dart';
part 'misskey_captcha_settings.g.dart';

/// The CAPTCHA settings of the instance (`/api/admin/captcha/current`).
@freezed
@JsonSerializable()
class MisskeyCaptchaSettings with _$MisskeyCaptchaSettings {
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
  @override
  final String provider;

  /// The hCaptcha keys.
  @override
  final MisskeyCaptchaKeys? hcaptcha;

  /// The mCaptcha keys.
  @override
  final MisskeyCaptchaKeys? mcaptcha;

  /// The reCAPTCHA keys.
  @override
  final MisskeyCaptchaKeys? recaptcha;

  /// The Turnstile keys.
  @override
  final MisskeyCaptchaKeys? turnstile;
}

/// The site/secret key pair of a CAPTCHA provider.
@freezed
@JsonSerializable()
class MisskeyCaptchaKeys with _$MisskeyCaptchaKeys {
  const MisskeyCaptchaKeys({this.siteKey, this.secretKey, this.instanceUrl});

  factory MisskeyCaptchaKeys.fromJson(Map<String, dynamic> json) =>
      _$MisskeyCaptchaKeysFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyCaptchaKeysToJson(this);

  /// The site key.
  @override
  final String? siteKey;

  /// The secret key.
  @override
  final String? secretKey;

  /// The instance URL (mCaptcha only).
  @override
  final String? instanceUrl;
}
