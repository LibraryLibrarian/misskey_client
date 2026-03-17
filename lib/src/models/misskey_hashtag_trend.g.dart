// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_hashtag_trend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyHashtagTrend _$MisskeyHashtagTrendFromJson(Map<String, dynamic> json) =>
    MisskeyHashtagTrend(
      tag: json['tag'] as String,
      chart: (json['chart'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      usersCount: (json['usersCount'] as num).toInt(),
    );
