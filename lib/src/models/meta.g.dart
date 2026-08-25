// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  maintainerName: json['maintainerName'] as String?,
  maintainerEmail: json['maintainerEmail'] as String?,
  version: json['version'] as String?,
  providesTarball: json['providesTarball'] as bool?,
  name: json['name'] as String?,
  shortName: json['shortName'] as String?,
  uri: json['uri'] as String?,
  description: json['description'] as String?,
  langs: (json['langs'] as List<dynamic>?)?.map((e) => e as String).toList(),
  tosUrl: json['tosUrl'] as String?,
  repositoryUrl: json['repositoryUrl'] as String?,
  feedbackUrl: json['feedbackUrl'] as String?,
  defaultDarkTheme: json['defaultDarkTheme'] as String?,
  defaultLightTheme: json['defaultLightTheme'] as String?,
  clientOptions: json['clientOptions'] == null
      ? null
      : MisskeyMetaClientOptions.fromJson(
          json['clientOptions'] as Map<String, dynamic>,
        ),
  disableRegistration: json['disableRegistration'] as bool?,
  emailRequiredForSignup: json['emailRequiredForSignup'] as bool?,
  enableHcaptcha: json['enableHcaptcha'] as bool?,
  hcaptchaSiteKey: json['hcaptchaSiteKey'] as String?,
  enableMcaptcha: json['enableMcaptcha'] as bool?,
  mcaptchaSiteKey: json['mcaptchaSiteKey'] as String?,
  mcaptchaInstanceUrl: json['mcaptchaInstanceUrl'] as String?,
  enableRecaptcha: json['enableRecaptcha'] as bool?,
  recaptchaSiteKey: json['recaptchaSiteKey'] as String?,
  enableTurnstile: json['enableTurnstile'] as bool?,
  turnstileSiteKey: json['turnstileSiteKey'] as String?,
  enableTestcaptcha: json['enableTestcaptcha'] as bool?,
  googleAnalyticsMeasurementId: json['googleAnalyticsMeasurementId'] as String?,
  swPublickey: json['swPublickey'] as String?,
  mascotImageUrl: json['mascotImageUrl'] as String?,
  bannerUrl: json['bannerUrl'] as String?,
  serverErrorImageUrl: json['serverErrorImageUrl'] as String?,
  infoImageUrl: json['infoImageUrl'] as String?,
  notFoundImageUrl: json['notFoundImageUrl'] as String?,
  iconUrl: json['iconUrl'] as String?,
  maxNoteTextLength: (json['maxNoteTextLength'] as num?)?.toInt() ?? 3000,
  ads: (json['ads'] as List<dynamic>?)
      ?.map((e) => MisskeyMetaAd.fromJson(e as Map<String, dynamic>))
      .toList(),
  enableEmail: json['enableEmail'] as bool?,
  enableServiceWorker: json['enableServiceWorker'] as bool?,
  translatorAvailable: json['translatorAvailable'] as bool?,
  sentryForFrontend: json['sentryForFrontend'] == null
      ? null
      : MisskeyMetaSentryConfig.fromJson(
          json['sentryForFrontend'] as Map<String, dynamic>,
        ),
  mediaProxy: json['mediaProxy'] as String?,
  enableUrlPreview: json['enableUrlPreview'] as bool?,
  backgroundImageUrl: json['backgroundImageUrl'] as String?,
  impressumUrl: json['impressumUrl'] as String?,
  logoImageUrl: json['logoImageUrl'] as String?,
  privacyPolicyUrl: json['privacyPolicyUrl'] as String?,
  inquiryUrl: json['inquiryUrl'] as String?,
  serverRules: (json['serverRules'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  themeColor: json['themeColor'] as String?,
  policies: json['policies'] == null
      ? null
      : MisskeyRolePolicies.fromJson(json['policies'] as Map<String, dynamic>),
  noteSearchableScope: $enumDecodeNullable(
    _$MisskeyNoteSearchableScopeEnumMap,
    json['noteSearchableScope'],
    unknownValue: MisskeyNoteSearchableScope.unknown,
  ),
  maxFileSize: (json['maxFileSize'] as num?)?.toInt(),
  federation: $enumDecodeNullable(
    _$MisskeyFederationModeEnumMap,
    json['federation'],
    unknownValue: MisskeyFederationMode.unknown,
  ),
  features: json['features'] == null
      ? null
      : MisskeyMetaFeatures.fromJson(json['features'] as Map<String, dynamic>),
  proxyAccountName: json['proxyAccountName'] as String?,
  cacheRemoteFiles: json['cacheRemoteFiles'] as bool?,
  cacheRemoteSensitiveFiles: json['cacheRemoteSensitiveFiles'] as bool?,
  requireSetup: json['requireSetup'] as bool?,
  notesPerOneAd: (json['notesPerOneAd'] as num?)?.toInt() ?? 0,
  raw: Meta._readWholeObject(json, 'raw') == null
      ? const RawMetaPayload.empty()
      : Meta._rawFromJson(Meta._readWholeObject(json, 'raw')),
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'maintainerName': instance.maintainerName,
  'maintainerEmail': instance.maintainerEmail,
  'version': instance.version,
  'providesTarball': instance.providesTarball,
  'name': instance.name,
  'shortName': instance.shortName,
  'uri': instance.uri,
  'description': instance.description,
  'langs': instance.langs,
  'tosUrl': instance.tosUrl,
  'repositoryUrl': instance.repositoryUrl,
  'feedbackUrl': instance.feedbackUrl,
  'defaultDarkTheme': instance.defaultDarkTheme,
  'defaultLightTheme': instance.defaultLightTheme,
  'clientOptions': instance.clientOptions?.toJson(),
  'disableRegistration': instance.disableRegistration,
  'emailRequiredForSignup': instance.emailRequiredForSignup,
  'enableHcaptcha': instance.enableHcaptcha,
  'hcaptchaSiteKey': instance.hcaptchaSiteKey,
  'enableMcaptcha': instance.enableMcaptcha,
  'mcaptchaSiteKey': instance.mcaptchaSiteKey,
  'mcaptchaInstanceUrl': instance.mcaptchaInstanceUrl,
  'enableRecaptcha': instance.enableRecaptcha,
  'recaptchaSiteKey': instance.recaptchaSiteKey,
  'enableTurnstile': instance.enableTurnstile,
  'turnstileSiteKey': instance.turnstileSiteKey,
  'enableTestcaptcha': instance.enableTestcaptcha,
  'googleAnalyticsMeasurementId': instance.googleAnalyticsMeasurementId,
  'swPublickey': instance.swPublickey,
  'mascotImageUrl': instance.mascotImageUrl,
  'bannerUrl': instance.bannerUrl,
  'serverErrorImageUrl': instance.serverErrorImageUrl,
  'infoImageUrl': instance.infoImageUrl,
  'notFoundImageUrl': instance.notFoundImageUrl,
  'iconUrl': instance.iconUrl,
  'maxNoteTextLength': instance.maxNoteTextLength,
  'ads': instance.ads?.map((e) => e.toJson()).toList(),
  'enableEmail': instance.enableEmail,
  'enableServiceWorker': instance.enableServiceWorker,
  'translatorAvailable': instance.translatorAvailable,
  'sentryForFrontend': instance.sentryForFrontend?.toJson(),
  'mediaProxy': instance.mediaProxy,
  'enableUrlPreview': instance.enableUrlPreview,
  'backgroundImageUrl': instance.backgroundImageUrl,
  'impressumUrl': instance.impressumUrl,
  'logoImageUrl': instance.logoImageUrl,
  'privacyPolicyUrl': instance.privacyPolicyUrl,
  'inquiryUrl': instance.inquiryUrl,
  'serverRules': instance.serverRules,
  'themeColor': instance.themeColor,
  'policies': instance.policies?.toJson(),
  'noteSearchableScope':
      _$MisskeyNoteSearchableScopeEnumMap[instance.noteSearchableScope],
  'maxFileSize': instance.maxFileSize,
  'federation': _$MisskeyFederationModeEnumMap[instance.federation],
  'features': instance.features?.toJson(),
  'proxyAccountName': instance.proxyAccountName,
  'cacheRemoteFiles': instance.cacheRemoteFiles,
  'cacheRemoteSensitiveFiles': instance.cacheRemoteSensitiveFiles,
  'requireSetup': instance.requireSetup,
  'notesPerOneAd': instance.notesPerOneAd,
};

const _$MisskeyNoteSearchableScopeEnumMap = {
  MisskeyNoteSearchableScope.local: 'local',
  MisskeyNoteSearchableScope.global: 'global',
  MisskeyNoteSearchableScope.unknown: 'unknown',
};

const _$MisskeyFederationModeEnumMap = {
  MisskeyFederationMode.all: 'all',
  MisskeyFederationMode.specified: 'specified',
  MisskeyFederationMode.none: 'none',
  MisskeyFederationMode.unknown: 'unknown',
};

MisskeyMetaClientOptions _$MisskeyMetaClientOptionsFromJson(
  Map<String, dynamic> json,
) => MisskeyMetaClientOptions(
  entrancePageStyle: $enumDecodeNullable(
    _$MisskeyEntrancePageStyleEnumMap,
    json['entrancePageStyle'],
    unknownValue: MisskeyEntrancePageStyle.unknown,
  ),
  showTimelineForVisitor: json['showTimelineForVisitor'] as bool?,
  showActivitiesForVisitor: json['showActivitiesForVisitor'] as bool?,
  raw: MisskeyMetaClientOptions._readWholeObject(json, 'raw') == null
      ? const RawMetaPayload.empty()
      : MisskeyMetaClientOptions._rawFromJson(
          MisskeyMetaClientOptions._readWholeObject(json, 'raw'),
        ),
);

Map<String, dynamic> _$MisskeyMetaClientOptionsToJson(
  MisskeyMetaClientOptions instance,
) => <String, dynamic>{
  'entrancePageStyle':
      ?_$MisskeyEntrancePageStyleEnumMap[instance.entrancePageStyle],
  'showTimelineForVisitor': ?instance.showTimelineForVisitor,
  'showActivitiesForVisitor': ?instance.showActivitiesForVisitor,
};

const _$MisskeyEntrancePageStyleEnumMap = {
  MisskeyEntrancePageStyle.classic: 'classic',
  MisskeyEntrancePageStyle.simple: 'simple',
  MisskeyEntrancePageStyle.unknown: 'unknown',
};

MisskeyMetaFeatures _$MisskeyMetaFeaturesFromJson(Map<String, dynamic> json) =>
    MisskeyMetaFeatures(
      registration: json['registration'] as bool?,
      emailRequiredForSignup: json['emailRequiredForSignup'] as bool?,
      localTimeline: json['localTimeline'] as bool?,
      globalTimeline: json['globalTimeline'] as bool?,
      hcaptcha: json['hcaptcha'] as bool?,
      turnstile: json['turnstile'] as bool?,
      recaptcha: json['recaptcha'] as bool?,
      objectStorage: json['objectStorage'] as bool?,
      serviceWorker: json['serviceWorker'] as bool?,
      miauth: json['miauth'] as bool?,
    );

Map<String, dynamic> _$MisskeyMetaFeaturesToJson(
  MisskeyMetaFeatures instance,
) => <String, dynamic>{
  'registration': ?instance.registration,
  'emailRequiredForSignup': ?instance.emailRequiredForSignup,
  'localTimeline': ?instance.localTimeline,
  'globalTimeline': ?instance.globalTimeline,
  'hcaptcha': ?instance.hcaptcha,
  'turnstile': ?instance.turnstile,
  'recaptcha': ?instance.recaptcha,
  'objectStorage': ?instance.objectStorage,
  'serviceWorker': ?instance.serviceWorker,
  'miauth': ?instance.miauth,
};

MisskeyMetaAd _$MisskeyMetaAdFromJson(Map<String, dynamic> json) =>
    MisskeyMetaAd(
      id: json['id'] as String,
      url: json['url'] as String,
      place: json['place'] as String,
      ratio: json['ratio'] as num,
      imageUrl: json['imageUrl'] as String,
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      isSensitive: json['isSensitive'] as bool?,
    );

Map<String, dynamic> _$MisskeyMetaAdToJson(MisskeyMetaAd instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'place': instance.place,
      'ratio': instance.ratio,
      'imageUrl': instance.imageUrl,
      'dayOfWeek': instance.dayOfWeek,
      'isSensitive': instance.isSensitive,
    };

MisskeyMetaSentryConfig _$MisskeyMetaSentryConfigFromJson(
  Map<String, dynamic> json,
) => MisskeyMetaSentryConfig(
  options: MisskeyMetaSentryOptions.fromJson(
    json['options'] as Map<String, dynamic>,
  ),
  vueIntegration: json['vueIntegration'] as Map<String, dynamic>?,
  browserTracingIntegration:
      json['browserTracingIntegration'] as Map<String, dynamic>?,
  replayIntegration: json['replayIntegration'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$MisskeyMetaSentryConfigToJson(
  MisskeyMetaSentryConfig instance,
) => <String, dynamic>{
  'options': instance.options.toJson(),
  'vueIntegration': instance.vueIntegration,
  'browserTracingIntegration': instance.browserTracingIntegration,
  'replayIntegration': instance.replayIntegration,
};

MisskeyMetaSentryOptions _$MisskeyMetaSentryOptionsFromJson(
  Map<String, dynamic> json,
) => MisskeyMetaSentryOptions(dsn: json['dsn'] as String);

Map<String, dynamic> _$MisskeyMetaSentryOptionsToJson(
  MisskeyMetaSentryOptions instance,
) => <String, dynamic>{'dsn': instance.dsn};
