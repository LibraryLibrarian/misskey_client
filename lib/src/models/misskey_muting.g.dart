// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_muting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyMuting _$MisskeyMutingFromJson(Map<String, dynamic> json) =>
    MisskeyMuting(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      muteeId: json['muteeId'] as String,
      mutee: json['mutee'] == null
          ? null
          : MisskeyUser.fromJson(json['mutee'] as Map<String, dynamic>),
    );
