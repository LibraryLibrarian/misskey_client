// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_totp_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyTotpRegistration _$MisskeyTotpRegistrationFromJson(
        Map<String, dynamic> json) =>
    MisskeyTotpRegistration(
      qr: json['qr'] as String,
      url: json['url'] as String,
      secret: json['secret'] as String,
      label: json['label'] as String,
      issuer: json['issuer'] as String,
    );
