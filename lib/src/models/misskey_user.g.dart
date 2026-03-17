// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyUser _$MisskeyUserFromJson(Map<String, dynamic> json) => MisskeyUser(
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String? ?? '',
      host: json['host'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      avatarBlurhash: json['avatarBlurhash'] as String?,
      isBot: json['isBot'] as bool? ?? false,
      isCat: json['isCat'] as bool? ?? false,
      emojis: (json['emojis'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
      onlineStatus: $enumDecodeNullable(
          _$MisskeyOnlineStatusEnumMap, json['onlineStatus'],
          unknownValue: MisskeyOnlineStatus.unknown),
      createdAt:
          const SafeDateTimeConverter().fromJson(json['createdAt'] as String?),
      description: json['description'] as String?,
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      notesCount: (json['notesCount'] as num?)?.toInt() ?? 0,
      isLocked: json['isLocked'] as bool? ?? false,
      isSuspended: json['isSuspended'] as bool? ?? false,
      isSilenced: json['isSilenced'] as bool? ?? false,
      pinnedNoteIds: (json['pinnedNoteIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pinnedNotes: (json['pinnedNotes'] as List<dynamic>?)
          ?.map((e) => MisskeyNote.fromJson(e as Map<String, dynamic>))
          .toList(),
      bannerUrl: json['bannerUrl'] as String?,
      bannerBlurhash: json['bannerBlurhash'] as String?,
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) => MisskeyUserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isFollowing: json['isFollowing'] as bool?,
      isFollowed: json['isFollowed'] as bool?,
      hasPendingFollowRequestFromYou:
          json['hasPendingFollowRequestFromYou'] as bool?,
      hasPendingFollowRequestToYou:
          json['hasPendingFollowRequestToYou'] as bool?,
      isBlocking: json['isBlocking'] as bool?,
      isBlocked: json['isBlocked'] as bool?,
      isMuted: json['isMuted'] as bool?,
      isRenoteMuted: json['isRenoteMuted'] as bool?,
      avatarDecorations: (json['avatarDecorations'] as List<dynamic>?)
          ?.map((e) =>
              MisskeyAvatarDecoration.fromJson(e as Map<String, dynamic>))
          .toList(),
      requireSigninToViewContents:
          json['requireSigninToViewContents'] as bool? ?? false,
      makeNotesFollowersOnlyBefore:
          (json['makeNotesFollowersOnlyBefore'] as num?)?.toInt(),
      makeNotesHiddenBefore: (json['makeNotesHiddenBefore'] as num?)?.toInt(),
      instance: json['instance'] == null
          ? null
          : MisskeyUserInstance.fromJson(
              json['instance'] as Map<String, dynamic>),
      badgeRoles: (json['badgeRoles'] as List<dynamic>?)
          ?.map((e) => MisskeyBadgeRole.fromJson(e as Map<String, dynamic>))
          .toList(),
      url: json['url'] as String?,
      uri: json['uri'] as String?,
      movedTo: json['movedTo'] as String?,
      alsoKnownAs: (json['alsoKnownAs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedAt:
          const SafeDateTimeConverter().fromJson(json['updatedAt'] as String?),
      lastFetchedAt: const SafeDateTimeConverter()
          .fromJson(json['lastFetchedAt'] as String?),
      location: json['location'] as String?,
      birthday: json['birthday'] as String?,
      lang: json['lang'] as String?,
      verifiedLinks: (json['verifiedLinks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      publicReactions: json['publicReactions'] as bool? ?? false,
      followingVisibility: json['followingVisibility'] as String?,
      followersVisibility: json['followersVisibility'] as String?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => MisskeyRoleLite.fromJson(e as Map<String, dynamic>))
          .toList(),
      memo: json['memo'] as String?,
      notify: json['notify'] as String?,
      withReplies: json['withReplies'] as bool? ?? false,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      usePasswordLessLogin: json['usePasswordLessLogin'] as bool? ?? false,
      securityKeys: json['securityKeys'] as bool? ?? false,
    );

Map<String, dynamic> _$MisskeyUserToJson(MisskeyUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'host': instance.host,
      'avatarUrl': instance.avatarUrl,
      'avatarBlurhash': instance.avatarBlurhash,
      'isBot': instance.isBot,
      'isCat': instance.isCat,
      'emojis': instance.emojis,
      'onlineStatus': _$MisskeyOnlineStatusEnumMap[instance.onlineStatus],
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'description': instance.description,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'notesCount': instance.notesCount,
      'isLocked': instance.isLocked,
      'isSuspended': instance.isSuspended,
      'isSilenced': instance.isSilenced,
      'pinnedNoteIds': instance.pinnedNoteIds,
      'pinnedNotes': instance.pinnedNotes,
      'bannerUrl': instance.bannerUrl,
      'bannerBlurhash': instance.bannerBlurhash,
      'fields': instance.fields,
      'isFollowing': instance.isFollowing,
      'isFollowed': instance.isFollowed,
      'hasPendingFollowRequestFromYou': instance.hasPendingFollowRequestFromYou,
      'hasPendingFollowRequestToYou': instance.hasPendingFollowRequestToYou,
      'isBlocking': instance.isBlocking,
      'isBlocked': instance.isBlocked,
      'isMuted': instance.isMuted,
      'isRenoteMuted': instance.isRenoteMuted,
      'avatarDecorations': instance.avatarDecorations,
      'requireSigninToViewContents': instance.requireSigninToViewContents,
      'makeNotesFollowersOnlyBefore': instance.makeNotesFollowersOnlyBefore,
      'makeNotesHiddenBefore': instance.makeNotesHiddenBefore,
      'instance': instance.instance,
      'badgeRoles': instance.badgeRoles,
      'url': instance.url,
      'uri': instance.uri,
      'movedTo': instance.movedTo,
      'alsoKnownAs': instance.alsoKnownAs,
      'updatedAt': const SafeDateTimeConverter().toJson(instance.updatedAt),
      'lastFetchedAt':
          const SafeDateTimeConverter().toJson(instance.lastFetchedAt),
      'location': instance.location,
      'birthday': instance.birthday,
      'lang': instance.lang,
      'verifiedLinks': instance.verifiedLinks,
      'publicReactions': instance.publicReactions,
      'followingVisibility': instance.followingVisibility,
      'followersVisibility': instance.followersVisibility,
      'roles': instance.roles,
      'memo': instance.memo,
      'notify': instance.notify,
      'withReplies': instance.withReplies,
      'twoFactorEnabled': instance.twoFactorEnabled,
      'usePasswordLessLogin': instance.usePasswordLessLogin,
      'securityKeys': instance.securityKeys,
    };

const _$MisskeyOnlineStatusEnumMap = {
  MisskeyOnlineStatus.unknown: 'unknown',
  MisskeyOnlineStatus.online: 'online',
  MisskeyOnlineStatus.active: 'active',
  MisskeyOnlineStatus.offline: 'offline',
};

MisskeyUserField _$MisskeyUserFieldFromJson(Map<String, dynamic> json) =>
    MisskeyUserField(
      name: json['name'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$MisskeyUserFieldToJson(MisskeyUserField instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

MisskeyAvatarDecoration _$MisskeyAvatarDecorationFromJson(
        Map<String, dynamic> json) =>
    MisskeyAvatarDecoration(
      id: json['id'] as String,
      angle: (json['angle'] as num?)?.toDouble(),
      flipH: json['flipH'] as bool?,
      url: json['url'] as String,
      offsetX: (json['offsetX'] as num?)?.toDouble(),
      offsetY: (json['offsetY'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MisskeyAvatarDecorationToJson(
        MisskeyAvatarDecoration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'angle': instance.angle,
      'flipH': instance.flipH,
      'url': instance.url,
      'offsetX': instance.offsetX,
      'offsetY': instance.offsetY,
    };

MisskeyUserInstance _$MisskeyUserInstanceFromJson(Map<String, dynamic> json) =>
    MisskeyUserInstance(
      name: json['name'] as String?,
      softwareName: json['softwareName'] as String?,
      softwareVersion: json['softwareVersion'] as String?,
      iconUrl: json['iconUrl'] as String?,
      faviconUrl: json['faviconUrl'] as String?,
      themeColor: json['themeColor'] as String?,
    );

Map<String, dynamic> _$MisskeyUserInstanceToJson(
        MisskeyUserInstance instance) =>
    <String, dynamic>{
      'name': instance.name,
      'softwareName': instance.softwareName,
      'softwareVersion': instance.softwareVersion,
      'iconUrl': instance.iconUrl,
      'faviconUrl': instance.faviconUrl,
      'themeColor': instance.themeColor,
    };

MisskeyBadgeRole _$MisskeyBadgeRoleFromJson(Map<String, dynamic> json) =>
    MisskeyBadgeRole(
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MisskeyBadgeRoleToJson(MisskeyBadgeRole instance) =>
    <String, dynamic>{
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'displayOrder': instance.displayOrder,
    };

MisskeyRoleLite _$MisskeyRoleLiteFromJson(Map<String, dynamic> json) =>
    MisskeyRoleLite(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String?,
      iconUrl: json['iconUrl'] as String?,
      description: json['description'] as String?,
      isModerator: json['isModerator'] as bool? ?? false,
      isAdministrator: json['isAdministrator'] as bool? ?? false,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MisskeyRoleLiteToJson(MisskeyRoleLite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'iconUrl': instance.iconUrl,
      'description': instance.description,
      'isModerator': instance.isModerator,
      'isAdministrator': instance.isAdministrator,
      'displayOrder': instance.displayOrder,
    };
