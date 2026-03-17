// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_federation_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyFederationStats _$MisskeyFederationStatsFromJson(
        Map<String, dynamic> json) =>
    MisskeyFederationStats(
      topSubInstances: (json['topSubInstances'] as List<dynamic>)
          .map((e) =>
              MisskeyFederationInstance.fromJson(e as Map<String, dynamic>))
          .toList(),
      otherFollowersCount: (json['otherFollowersCount'] as num).toInt(),
      topPubInstances: (json['topPubInstances'] as List<dynamic>)
          .map((e) =>
              MisskeyFederationInstance.fromJson(e as Map<String, dynamic>))
          .toList(),
      otherFollowingCount: (json['otherFollowingCount'] as num).toInt(),
    );

Map<String, dynamic> _$MisskeyFederationStatsToJson(
        MisskeyFederationStats instance) =>
    <String, dynamic>{
      'topSubInstances': instance.topSubInstances,
      'otherFollowersCount': instance.otherFollowersCount,
      'topPubInstances': instance.topPubInstances,
      'otherFollowingCount': instance.otherFollowingCount,
    };
