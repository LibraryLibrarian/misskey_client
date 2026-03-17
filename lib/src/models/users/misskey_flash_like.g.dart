// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_flash_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyFlashLike _$MisskeyFlashLikeFromJson(Map<String, dynamic> json) =>
    MisskeyFlashLike(
      id: json['id'] as String,
      flash: MisskeyFlash.fromJson(json['flash'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyFlashLikeToJson(MisskeyFlashLike instance) =>
    <String, dynamic>{
      'id': instance.id,
      'flash': instance.flash,
    };
