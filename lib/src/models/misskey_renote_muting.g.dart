// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_renote_muting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyRenoteMuting _$MisskeyRenoteMutingFromJson(Map<String, dynamic> json) =>
    MisskeyRenoteMuting(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      muteeId: json['muteeId'] as String,
      mutee: json['mutee'] == null
          ? null
          : MisskeyUser.fromJson(json['mutee'] as Map<String, dynamic>),
    );
