// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_role_policies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyRolePolicies _$MisskeyRolePoliciesFromJson(Map<String, dynamic> json) =>
    MisskeyRolePolicies(
      gtlAvailable: json['gtlAvailable'] as bool?,
      ltlAvailable: json['ltlAvailable'] as bool?,
      canPublicNote: json['canPublicNote'] as bool?,
      mentionLimit: (json['mentionLimit'] as num?)?.toInt(),
      canInvite: json['canInvite'] as bool?,
      inviteLimit: (json['inviteLimit'] as num?)?.toInt(),
      inviteLimitCycle: (json['inviteLimitCycle'] as num?)?.toInt(),
      inviteExpirationTime: (json['inviteExpirationTime'] as num?)?.toInt(),
      canManageCustomEmojis: json['canManageCustomEmojis'] as bool?,
      canManageAvatarDecorations: json['canManageAvatarDecorations'] as bool?,
      canSearchNotes: json['canSearchNotes'] as bool?,
      canSearchUsers: json['canSearchUsers'] as bool?,
      canUseTranslator: json['canUseTranslator'] as bool?,
      canHideAds: json['canHideAds'] as bool?,
      canCreateChannel: json['canCreateChannel'] as bool?,
      driveCapacityMb: (json['driveCapacityMb'] as num?)?.toInt(),
      maxFileSizeMb: (json['maxFileSizeMb'] as num?)?.toInt(),
      alwaysMarkNsfw: json['alwaysMarkNsfw'] as bool?,
      canUpdateBioMedia: json['canUpdateBioMedia'] as bool?,
      pinLimit: (json['pinLimit'] as num?)?.toInt(),
      antennaLimit: (json['antennaLimit'] as num?)?.toInt(),
      wordMuteLimit: (json['wordMuteLimit'] as num?)?.toInt(),
      webhookLimit: (json['webhookLimit'] as num?)?.toInt(),
      clipLimit: (json['clipLimit'] as num?)?.toInt(),
      noteEachClipsLimit: (json['noteEachClipsLimit'] as num?)?.toInt(),
      userListLimit: (json['userListLimit'] as num?)?.toInt(),
      userEachUserListsLimit: (json['userEachUserListsLimit'] as num?)?.toInt(),
      rateLimitFactor: json['rateLimitFactor'] as num?,
      avatarDecorationLimit: (json['avatarDecorationLimit'] as num?)?.toInt(),
      canImportAntennas: json['canImportAntennas'] as bool?,
      canImportBlocking: json['canImportBlocking'] as bool?,
      canImportFollowing: json['canImportFollowing'] as bool?,
      canImportMuting: json['canImportMuting'] as bool?,
      canImportUserLists: json['canImportUserLists'] as bool?,
      chatAvailability: $enumDecodeNullable(
        _$MisskeyChatAvailabilityEnumMap,
        json['chatAvailability'],
        unknownValue: MisskeyChatAvailability.unknown,
      ),
      uploadableFileTypes: (json['uploadableFileTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      noteDraftLimit: (json['noteDraftLimit'] as num?)?.toInt(),
      scheduledNoteLimit: (json['scheduledNoteLimit'] as num?)?.toInt(),
      watermarkAvailable: json['watermarkAvailable'] as bool?,
      raw: MisskeyRolePolicies._readWholeObject(json, 'raw') == null
          ? const RawMetaPayload.empty()
          : MisskeyRolePolicies._rawFromJson(
              MisskeyRolePolicies._readWholeObject(json, 'raw'),
            ),
    );

Map<String, dynamic> _$MisskeyRolePoliciesToJson(
  MisskeyRolePolicies instance,
) => <String, dynamic>{
  'gtlAvailable': instance.gtlAvailable,
  'ltlAvailable': instance.ltlAvailable,
  'canPublicNote': instance.canPublicNote,
  'mentionLimit': instance.mentionLimit,
  'canInvite': instance.canInvite,
  'inviteLimit': instance.inviteLimit,
  'inviteLimitCycle': instance.inviteLimitCycle,
  'inviteExpirationTime': instance.inviteExpirationTime,
  'canManageCustomEmojis': instance.canManageCustomEmojis,
  'canManageAvatarDecorations': instance.canManageAvatarDecorations,
  'canSearchNotes': instance.canSearchNotes,
  'canSearchUsers': instance.canSearchUsers,
  'canUseTranslator': instance.canUseTranslator,
  'canHideAds': instance.canHideAds,
  'canCreateChannel': instance.canCreateChannel,
  'driveCapacityMb': instance.driveCapacityMb,
  'maxFileSizeMb': instance.maxFileSizeMb,
  'alwaysMarkNsfw': instance.alwaysMarkNsfw,
  'canUpdateBioMedia': instance.canUpdateBioMedia,
  'pinLimit': instance.pinLimit,
  'antennaLimit': instance.antennaLimit,
  'wordMuteLimit': instance.wordMuteLimit,
  'webhookLimit': instance.webhookLimit,
  'clipLimit': instance.clipLimit,
  'noteEachClipsLimit': instance.noteEachClipsLimit,
  'userListLimit': instance.userListLimit,
  'userEachUserListsLimit': instance.userEachUserListsLimit,
  'rateLimitFactor': instance.rateLimitFactor,
  'avatarDecorationLimit': instance.avatarDecorationLimit,
  'canImportAntennas': instance.canImportAntennas,
  'canImportBlocking': instance.canImportBlocking,
  'canImportFollowing': instance.canImportFollowing,
  'canImportMuting': instance.canImportMuting,
  'canImportUserLists': instance.canImportUserLists,
  'chatAvailability':
      _$MisskeyChatAvailabilityEnumMap[instance.chatAvailability],
  'uploadableFileTypes': instance.uploadableFileTypes,
  'noteDraftLimit': instance.noteDraftLimit,
  'scheduledNoteLimit': instance.scheduledNoteLimit,
  'watermarkAvailable': instance.watermarkAvailable,
};

const _$MisskeyChatAvailabilityEnumMap = {
  MisskeyChatAvailability.available: 'available',
  MisskeyChatAvailability.readonly: 'readonly',
  MisskeyChatAvailability.unavailable: 'unavailable',
  MisskeyChatAvailability.unknown: 'unknown',
};

MisskeyRolePolicyOverride _$MisskeyRolePolicyOverrideFromJson(
  Map<String, dynamic> json,
) => MisskeyRolePolicyOverride(
  value: json['value'],
  priority: (json['priority'] as num?)?.toInt(),
  useDefault: json['useDefault'] as bool?,
);

Map<String, dynamic> _$MisskeyRolePolicyOverrideToJson(
  MisskeyRolePolicyOverride instance,
) => <String, dynamic>{
  'value': instance.value,
  'priority': instance.priority,
  'useDefault': instance.useDefault,
};
