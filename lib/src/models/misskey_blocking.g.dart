// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_blocking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyBlocking _$MisskeyBlockingFromJson(Map<String, dynamic> json) =>
    MisskeyBlocking(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      blockeeId: json['blockeeId'] as String,
      blockee: json['blockee'] == null
          ? null
          : MisskeyUser.fromJson(json['blockee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyBlockingToJson(MisskeyBlocking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'blockeeId': instance.blockeeId,
      'blockee': instance.blockee?.toJson(),
    };
