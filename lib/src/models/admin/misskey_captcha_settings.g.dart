// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_captcha_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyCaptchaSettings _$MisskeyCaptchaSettingsFromJson(
  Map<String, dynamic> json,
) => MisskeyCaptchaSettings(
  provider: json['provider'] as String,
  hcaptcha: json['hcaptcha'] == null
      ? null
      : MisskeyCaptchaKeys.fromJson(json['hcaptcha'] as Map<String, dynamic>),
  mcaptcha: json['mcaptcha'] == null
      ? null
      : MisskeyCaptchaKeys.fromJson(json['mcaptcha'] as Map<String, dynamic>),
  recaptcha: json['recaptcha'] == null
      ? null
      : MisskeyCaptchaKeys.fromJson(json['recaptcha'] as Map<String, dynamic>),
  turnstile: json['turnstile'] == null
      ? null
      : MisskeyCaptchaKeys.fromJson(json['turnstile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MisskeyCaptchaSettingsToJson(
  MisskeyCaptchaSettings instance,
) => <String, dynamic>{
  'provider': instance.provider,
  'hcaptcha': instance.hcaptcha?.toJson(),
  'mcaptcha': instance.mcaptcha?.toJson(),
  'recaptcha': instance.recaptcha?.toJson(),
  'turnstile': instance.turnstile?.toJson(),
};

MisskeyCaptchaKeys _$MisskeyCaptchaKeysFromJson(Map<String, dynamic> json) =>
    MisskeyCaptchaKeys(
      siteKey: json['siteKey'] as String?,
      secretKey: json['secretKey'] as String?,
      instanceUrl: json['instanceUrl'] as String?,
    );

Map<String, dynamic> _$MisskeyCaptchaKeysToJson(MisskeyCaptchaKeys instance) =>
    <String, dynamic>{
      'siteKey': instance.siteKey,
      'secretKey': instance.secretKey,
      'instanceUrl': instance.instanceUrl,
    };
