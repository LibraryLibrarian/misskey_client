// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_ad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAd _$MisskeyAdFromJson(Map<String, dynamic> json) => MisskeyAd(
      id: json['id'] as String,
      expiresAt:
          const SafeDateTimeConverter().fromJson(json['expiresAt'] as String?),
      startsAt:
          const SafeDateTimeConverter().fromJson(json['startsAt'] as String?),
      place: json['place'] as String,
      priority: json['priority'] as String,
      ratio: json['ratio'] as num,
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String,
      memo: json['memo'] as String,
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      isSensitive: json['isSensitive'] as bool?,
    );

Map<String, dynamic> _$MisskeyAdToJson(MisskeyAd instance) => <String, dynamic>{
      'id': instance.id,
      'expiresAt': const SafeDateTimeConverter().toJson(instance.expiresAt),
      'startsAt': const SafeDateTimeConverter().toJson(instance.startsAt),
      'place': instance.place,
      'priority': instance.priority,
      'ratio': instance.ratio,
      'url': instance.url,
      'imageUrl': instance.imageUrl,
      'memo': instance.memo,
      'dayOfWeek': instance.dayOfWeek,
      'isSensitive': instance.isSensitive,
    };
