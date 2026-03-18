// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_frequent_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyFrequentUser _$MisskeyFrequentUserFromJson(Map<String, dynamic> json) =>
    MisskeyFrequentUser(
      user: MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$MisskeyFrequentUserToJson(
        MisskeyFrequentUser instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'weight': instance.weight,
    };
