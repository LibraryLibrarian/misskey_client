// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_invite_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyInviteCode _$MisskeyInviteCodeFromJson(Map<String, dynamic> json) =>
    MisskeyInviteCode(
      id: json['id'] as String,
      code: json['code'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      used: json['used'] as bool,
      expiresAt:
          const SafeDateTimeConverter().fromJson(json['expiresAt'] as String?),
      createdBy: json['createdBy'] == null
          ? null
          : MisskeyUser.fromJson(json['createdBy'] as Map<String, dynamic>),
      usedBy: json['usedBy'] == null
          ? null
          : MisskeyUser.fromJson(json['usedBy'] as Map<String, dynamic>),
      usedAt: const SafeDateTimeConverter().fromJson(json['usedAt'] as String?),
    );

Map<String, dynamic> _$MisskeyInviteCodeToJson(MisskeyInviteCode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'expiresAt': const SafeDateTimeConverter().toJson(instance.expiresAt),
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'usedBy': instance.usedBy,
      'usedAt': const SafeDateTimeConverter().toJson(instance.usedAt),
      'used': instance.used,
    };
