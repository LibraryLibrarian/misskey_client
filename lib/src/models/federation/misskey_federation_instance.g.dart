// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_federation_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyFederationInstance _$MisskeyFederationInstanceFromJson(
        Map<String, dynamic> json) =>
    MisskeyFederationInstance(
      id: json['id'] as String,
      firstRetrievedAt: DateTime.parse(json['firstRetrievedAt'] as String),
      host: json['host'] as String,
      usersCount: (json['usersCount'] as num?)?.toInt(),
      notesCount: (json['notesCount'] as num?)?.toInt(),
      followingCount: (json['followingCount'] as num?)?.toInt(),
      followersCount: (json['followersCount'] as num?)?.toInt(),
      isNotResponding: json['isNotResponding'] as bool?,
      isSuspended: json['isSuspended'] as bool?,
      isBlocked: json['isBlocked'] as bool?,
      isSilenced: json['isSilenced'] as bool?,
      softwareName: json['softwareName'] as String?,
      softwareVersion: json['softwareVersion'] as String?,
      openRegistrations: json['openRegistrations'] as bool?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      maintainerName: json['maintainerName'] as String?,
      maintainerEmail: json['maintainerEmail'] as String?,
      iconUrl: json['iconUrl'] as String?,
      faviconUrl: json['faviconUrl'] as String?,
      themeColor: json['themeColor'] as String?,
      infoUpdatedAt: json['infoUpdatedAt'] == null
          ? null
          : DateTime.parse(json['infoUpdatedAt'] as String),
      latestRequestReceivedAt: json['latestRequestReceivedAt'] == null
          ? null
          : DateTime.parse(json['latestRequestReceivedAt'] as String),
    );

Map<String, dynamic> _$MisskeyFederationInstanceToJson(
        MisskeyFederationInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstRetrievedAt': instance.firstRetrievedAt.toIso8601String(),
      'host': instance.host,
      'usersCount': instance.usersCount,
      'notesCount': instance.notesCount,
      'followingCount': instance.followingCount,
      'followersCount': instance.followersCount,
      'isNotResponding': instance.isNotResponding,
      'isSuspended': instance.isSuspended,
      'isBlocked': instance.isBlocked,
      'isSilenced': instance.isSilenced,
      'softwareName': instance.softwareName,
      'softwareVersion': instance.softwareVersion,
      'openRegistrations': instance.openRegistrations,
      'name': instance.name,
      'description': instance.description,
      'maintainerName': instance.maintainerName,
      'maintainerEmail': instance.maintainerEmail,
      'iconUrl': instance.iconUrl,
      'faviconUrl': instance.faviconUrl,
      'themeColor': instance.themeColor,
      'infoUpdatedAt': instance.infoUpdatedAt?.toIso8601String(),
      'latestRequestReceivedAt':
          instance.latestRequestReceivedAt?.toIso8601String(),
    };
