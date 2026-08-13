// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_admin_user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAdminUserDetail _$MisskeyAdminUserDetailFromJson(
  Map<String, dynamic> json,
) => MisskeyAdminUserDetail(
  email: json['email'] as String?,
  emailVerified: json['emailVerified'] as bool?,
  followedMessage: json['followedMessage'] as String?,
  autoAcceptFollowed: json['autoAcceptFollowed'] as bool?,
  noCrawle: json['noCrawle'] as bool?,
  preventAiLearning: json['preventAiLearning'] as bool?,
  alwaysMarkNsfw: json['alwaysMarkNsfw'] as bool?,
  autoSensitive: json['autoSensitive'] as bool?,
  carefulBot: json['carefulBot'] as bool?,
  injectFeaturedNote: json['injectFeaturedNote'] as bool?,
  receiveAnnouncementEmail: json['receiveAnnouncementEmail'] as bool?,
  mutedWords: json['mutedWords'] as List<dynamic>?,
  mutedInstances: (json['mutedInstances'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  notificationRecieveConfig:
      json['notificationRecieveConfig'] as Map<String, dynamic>?,
  isModerator: json['isModerator'] as bool?,
  isSilenced: json['isSilenced'] as bool?,
  isSuspended: json['isSuspended'] as bool?,
  isHibernated: json['isHibernated'] as bool?,
  lastActiveDate: const SafeDateTimeConverter().fromJson(
    json['lastActiveDate'] as String?,
  ),
  moderationNote: json['moderationNote'] as String?,
  signins: (json['signins'] as List<dynamic>?)
      ?.map((e) => MisskeySignin.fromJson(e as Map<String, dynamic>))
      .toList(),
  policies: json['policies'] as Map<String, dynamic>?,
  roles: (json['roles'] as List<dynamic>?)
      ?.map((e) => MisskeyRole.fromJson(e as Map<String, dynamic>))
      .toList(),
  roleAssigns: (json['roleAssigns'] as List<dynamic>?)
      ?.map((e) => MisskeyRoleAssign.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MisskeyAdminUserDetailToJson(
  MisskeyAdminUserDetail instance,
) => <String, dynamic>{
  'email': instance.email,
  'emailVerified': instance.emailVerified,
  'followedMessage': instance.followedMessage,
  'autoAcceptFollowed': instance.autoAcceptFollowed,
  'noCrawle': instance.noCrawle,
  'preventAiLearning': instance.preventAiLearning,
  'alwaysMarkNsfw': instance.alwaysMarkNsfw,
  'autoSensitive': instance.autoSensitive,
  'carefulBot': instance.carefulBot,
  'injectFeaturedNote': instance.injectFeaturedNote,
  'receiveAnnouncementEmail': instance.receiveAnnouncementEmail,
  'mutedWords': instance.mutedWords,
  'mutedInstances': instance.mutedInstances,
  'notificationRecieveConfig': instance.notificationRecieveConfig,
  'isModerator': instance.isModerator,
  'isSilenced': instance.isSilenced,
  'isSuspended': instance.isSuspended,
  'isHibernated': instance.isHibernated,
  'lastActiveDate': const SafeDateTimeConverter().toJson(
    instance.lastActiveDate,
  ),
  'moderationNote': instance.moderationNote,
  'signins': instance.signins?.map((e) => e.toJson()).toList(),
  'policies': instance.policies,
  'roles': instance.roles?.map((e) => e.toJson()).toList(),
  'roleAssigns': instance.roleAssigns?.map((e) => e.toJson()).toList(),
};

MisskeySignin _$MisskeySigninFromJson(Map<String, dynamic> json) =>
    MisskeySignin(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      createdAt: const SafeDateTimeConverter().fromJson(
        json['createdAt'] as String?,
      ),
      ip: json['ip'] as String?,
      headers: json['headers'] as Map<String, dynamic>?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$MisskeySigninToJson(MisskeySignin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'ip': instance.ip,
      'headers': instance.headers,
      'success': instance.success,
    };

MisskeyRoleAssign _$MisskeyRoleAssignFromJson(Map<String, dynamic> json) =>
    MisskeyRoleAssign(
      id: json['id'] as String,
      createdAt: const SafeDateTimeConverter().fromJson(
        json['createdAt'] as String?,
      ),
      expiresAt: const SafeDateTimeConverter().fromJson(
        json['expiresAt'] as String?,
      ),
      roleId: json['roleId'] as String?,
    );

Map<String, dynamic> _$MisskeyRoleAssignToJson(MisskeyRoleAssign instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'expiresAt': const SafeDateTimeConverter().toJson(instance.expiresAt),
      'roleId': instance.roleId,
    };
