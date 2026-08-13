// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_admin_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAdminMeta _$MisskeyAdminMetaFromJson(Map<String, dynamic> json) =>
    MisskeyAdminMeta(
      maintainerName: json['maintainerName'] as String?,
      maintainerEmail: json['maintainerEmail'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      langs: (json['langs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tosUrl: json['tosUrl'] as String?,
      privacyPolicyUrl: json['privacyPolicyUrl'] as String?,
      impressumUrl: json['impressumUrl'] as String?,
      inquiryUrl: json['inquiryUrl'] as String?,
      repositoryUrl: json['repositoryUrl'] as String?,
      feedbackUrl: json['feedbackUrl'] as String?,
      disableRegistration: json['disableRegistration'] as bool?,
      emailRequiredForSignup: json['emailRequiredForSignup'] as bool?,
      enableEmail: json['enableEmail'] as bool?,
      enableServiceWorker: json['enableServiceWorker'] as bool?,
      enableIpLogging: json['enableIpLogging'] as bool?,
      enableActiveEmailValidation: json['enableActiveEmailValidation'] as bool?,
      cacheRemoteFiles: json['cacheRemoteFiles'] as bool?,
      cacheRemoteSensitiveFiles: json['cacheRemoteSensitiveFiles'] as bool?,
      federation: json['federation'] as String?,
      federationHosts: (json['federationHosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      blockedHosts: (json['blockedHosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      silencedHosts: (json['silencedHosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mediaSilencedHosts: (json['mediaSilencedHosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sensitiveWords: (json['sensitiveWords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      prohibitedWords: (json['prohibitedWords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hiddenTags: (json['hiddenTags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bannedEmailDomains: (json['bannedEmailDomains'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      preservedUsernames: (json['preservedUsernames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      proxyAccountId: json['proxyAccountId'] as String?,
      notesPerOneAd: (json['notesPerOneAd'] as num?)?.toInt(),
      enableHcaptcha: json['enableHcaptcha'] as bool?,
      enableRecaptcha: json['enableRecaptcha'] as bool?,
      enableTurnstile: json['enableTurnstile'] as bool?,
      swPublicKey: json['swPublicKey'] as String?,
    );

Map<String, dynamic> _$MisskeyAdminMetaToJson(MisskeyAdminMeta instance) =>
    <String, dynamic>{
      'maintainerName': instance.maintainerName,
      'maintainerEmail': instance.maintainerEmail,
      'name': instance.name,
      'description': instance.description,
      'langs': instance.langs,
      'tosUrl': instance.tosUrl,
      'privacyPolicyUrl': instance.privacyPolicyUrl,
      'impressumUrl': instance.impressumUrl,
      'inquiryUrl': instance.inquiryUrl,
      'repositoryUrl': instance.repositoryUrl,
      'feedbackUrl': instance.feedbackUrl,
      'disableRegistration': instance.disableRegistration,
      'emailRequiredForSignup': instance.emailRequiredForSignup,
      'enableEmail': instance.enableEmail,
      'enableServiceWorker': instance.enableServiceWorker,
      'enableIpLogging': instance.enableIpLogging,
      'enableActiveEmailValidation': instance.enableActiveEmailValidation,
      'cacheRemoteFiles': instance.cacheRemoteFiles,
      'cacheRemoteSensitiveFiles': instance.cacheRemoteSensitiveFiles,
      'federation': instance.federation,
      'federationHosts': instance.federationHosts,
      'blockedHosts': instance.blockedHosts,
      'silencedHosts': instance.silencedHosts,
      'mediaSilencedHosts': instance.mediaSilencedHosts,
      'sensitiveWords': instance.sensitiveWords,
      'prohibitedWords': instance.prohibitedWords,
      'hiddenTags': instance.hiddenTags,
      'bannedEmailDomains': instance.bannedEmailDomains,
      'preservedUsernames': instance.preservedUsernames,
      'proxyAccountId': instance.proxyAccountId,
      'notesPerOneAd': instance.notesPerOneAd,
      'enableHcaptcha': instance.enableHcaptcha,
      'enableRecaptcha': instance.enableRecaptcha,
      'enableTurnstile': instance.enableTurnstile,
      'swPublicKey': instance.swPublicKey,
    };
