import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_role_policies.dart';
import 'raw_meta_payload.dart';

part 'meta.freezed.dart';
part 'meta.g.dart';

/// The scope in which notes can be searched.
@JsonEnum()
enum MisskeyNoteSearchableScope { local, global, unknown }

/// The instance federation mode.
@JsonEnum()
enum MisskeyFederationMode { all, specified, none, unknown }

/// The entrance page layout offered to visitors.
@JsonEnum()
enum MisskeyEntrancePageStyle { classic, simple, unknown }

/// Response model for the Misskey `/api/meta` endpoint.
///
/// Provides typed fields while retaining unknown fields in [raw].
@freezed
@JsonSerializable()
class Meta with _$Meta {
  const Meta({
    this.maintainerName,
    this.maintainerEmail,
    this.version,
    this.providesTarball,
    this.name,
    this.shortName,
    this.uri,
    this.description,
    this.langs,
    this.tosUrl,
    this.repositoryUrl,
    this.feedbackUrl,
    this.defaultDarkTheme,
    this.defaultLightTheme,
    this.clientOptions,
    this.disableRegistration,
    this.emailRequiredForSignup,
    this.enableHcaptcha,
    this.hcaptchaSiteKey,
    this.enableMcaptcha,
    this.mcaptchaSiteKey,
    this.mcaptchaInstanceUrl,
    this.enableRecaptcha,
    this.recaptchaSiteKey,
    this.enableTurnstile,
    this.turnstileSiteKey,
    this.enableTestcaptcha,
    this.googleAnalyticsMeasurementId,
    this.swPublickey,
    this.mascotImageUrl,
    this.bannerUrl,
    this.serverErrorImageUrl,
    this.infoImageUrl,
    this.notFoundImageUrl,
    this.iconUrl,
    this.maxNoteTextLength,
    this.ads,
    this.enableEmail,
    this.enableServiceWorker,
    this.translatorAvailable,
    this.sentryForFrontend,
    this.mediaProxy,
    this.enableUrlPreview,
    this.backgroundImageUrl,
    this.impressumUrl,
    this.logoImageUrl,
    this.privacyPolicyUrl,
    this.inquiryUrl,
    this.serverRules,
    this.themeColor,
    this.policies,
    this.noteSearchableScope,
    this.maxFileSize,
    this.federation,
    this.features,
    this.proxyAccountName,
    this.cacheRemoteFiles,
    this.cacheRemoteSensitiveFiles,
    this.requireSetup,
    this.notesPerOneAd,
    this.raw = const RawMetaPayload.empty(),
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  /// The instance maintainer's display name.
  @override
  final String? maintainerName;

  /// The instance maintainer's email address.
  @override
  final String? maintainerEmail;

  /// The Misskey software version.
  @override
  final String? version;

  /// Whether the server provides source tarballs.
  @override
  final bool? providesTarball;

  /// The instance name.
  @override
  final String? name;

  /// The instance short name.
  @override
  final String? shortName;

  /// The instance URI.
  @override
  final String? uri;

  /// The instance description.
  @override
  final String? description;

  /// The languages supported by the instance.
  @override
  final List<String>? langs;

  /// The Terms of Service URL.
  @override
  final String? tosUrl;

  /// The source code repository URL.
  @override
  final String? repositoryUrl;

  /// The feedback URL.
  @override
  final String? feedbackUrl;

  /// The serialized default dark theme.
  @override
  final String? defaultDarkTheme;

  /// The serialized default light theme.
  @override
  final String? defaultLightTheme;

  /// Options controlling the visitor-facing web client.
  @override
  final MisskeyMetaClientOptions? clientOptions;

  /// Whether new user registration is disabled.
  @override
  final bool? disableRegistration;

  /// Whether email is required for sign-up.
  @override
  final bool? emailRequiredForSignup;

  /// Whether hCaptcha is enabled.
  @override
  final bool? enableHcaptcha;

  /// The hCaptcha site key.
  @override
  final String? hcaptchaSiteKey;

  /// Whether mCaptcha is enabled.
  @override
  final bool? enableMcaptcha;

  /// The mCaptcha site key.
  @override
  final String? mcaptchaSiteKey;

  /// The mCaptcha server URL.
  @override
  final String? mcaptchaInstanceUrl;

  /// Whether reCAPTCHA is enabled.
  @override
  final bool? enableRecaptcha;

  /// The reCAPTCHA site key.
  @override
  final String? recaptchaSiteKey;

  /// Whether Turnstile is enabled.
  @override
  final bool? enableTurnstile;

  /// The Turnstile site key.
  @override
  final String? turnstileSiteKey;

  /// Whether the test CAPTCHA is enabled.
  @override
  final bool? enableTestcaptcha;

  /// The Google Analytics measurement ID.
  @override
  final String? googleAnalyticsMeasurementId;

  /// The service worker VAPID public key.
  @override
  final String? swPublickey;

  /// The mascot image URL.
  @override
  final String? mascotImageUrl;

  /// The banner image URL.
  @override
  final String? bannerUrl;

  /// The image URL displayed on server errors.
  @override
  final String? serverErrorImageUrl;

  /// The image URL displayed for informational states.
  @override
  final String? infoImageUrl;

  /// The image URL displayed for missing pages.
  @override
  final String? notFoundImageUrl;

  /// The instance icon URL.
  @override
  final String? iconUrl;

  /// The maximum allowed note text length.
  @override
  @JsonKey(defaultValue: 3000)
  final int? maxNoteTextLength;

  /// Advertisements configured for the instance.
  @override
  final List<MisskeyMetaAd>? ads;

  /// Whether email delivery is enabled.
  @override
  final bool? enableEmail;

  /// Whether the service worker is enabled.
  @override
  final bool? enableServiceWorker;

  /// Whether the translator feature is available.
  @override
  final bool? translatorAvailable;

  /// Sentry configuration exposed to the web client.
  @override
  final MisskeyMetaSentryConfig? sentryForFrontend;

  /// The media proxy URL.
  @override
  final String? mediaProxy;

  /// Whether URL previews are enabled.
  @override
  final bool? enableUrlPreview;

  /// The background image URL.
  @override
  final String? backgroundImageUrl;

  /// The legal notice URL.
  @override
  final String? impressumUrl;

  /// The logo image URL.
  @override
  final String? logoImageUrl;

  /// The privacy policy URL.
  @override
  final String? privacyPolicyUrl;

  /// The inquiry URL.
  @override
  final String? inquiryUrl;

  /// Rules shown to instance users.
  @override
  final List<String>? serverRules;

  /// The instance theme color.
  @override
  final String? themeColor;

  /// The effective policies applied to instance visitors.
  @override
  final MisskeyRolePolicies? policies;

  /// The scope in which notes can be searched.
  @override
  @JsonKey(unknownEnumValue: MisskeyNoteSearchableScope.unknown)
  final MisskeyNoteSearchableScope? noteSearchableScope;

  /// The maximum upload size in bytes.
  @override
  final int? maxFileSize;

  /// The instance federation mode.
  @override
  @JsonKey(unknownEnumValue: MisskeyFederationMode.unknown)
  final MisskeyFederationMode? federation;

  /// Feature flags advertised by the instance.
  @override
  final MisskeyMetaFeatures? features;

  /// The proxy account username.
  @override
  final String? proxyAccountName;

  /// Whether remote files are cached locally.
  @override
  final bool? cacheRemoteFiles;

  /// Whether remote sensitive files are cached locally.
  @override
  final bool? cacheRemoteSensitiveFiles;

  /// Whether initial setup is required.
  @override
  final bool? requireSetup;

  /// The number of notes displayed per ad insertion.
  @override
  @JsonKey(defaultValue: 0)
  final int? notesPerOneAd;

  /// A map holding all response JSON fields for capability detection.
  @override
  @JsonKey(
    includeToJson: false,
    readValue: _readWholeObject,
    fromJson: _rawFromJson,
  )
  final RawMetaPayload raw;

  /// Converts this model to JSON while preserving unknown response fields and
  /// the original wire values of unknown enums.
  Map<String, dynamic> toJson() {
    final typed = _$MetaToJson(this);
    if (federation == MisskeyFederationMode.unknown &&
        raw.json.containsKey('federation')) {
      typed.remove('federation');
    }
    if (noteSearchableScope == MisskeyNoteSearchableScope.unknown &&
        raw.json.containsKey('noteSearchableScope')) {
      typed.remove('noteSearchableScope');
    }
    return <String, dynamic>{...raw.json, ...typed};
  }

  static Object? _readWholeObject(Map<dynamic, dynamic> json, String _) => json;

  static RawMetaPayload _rawFromJson(Object? json) =>
      RawMetaPayload(Map<String, dynamic>.from(json! as Map));
}

/// Options controlling the visitor-facing Misskey web client.
@freezed
@JsonSerializable(includeIfNull: false)
class MisskeyMetaClientOptions with _$MisskeyMetaClientOptions {
  const MisskeyMetaClientOptions({
    this.entrancePageStyle,
    this.showTimelineForVisitor,
    this.showActivitiesForVisitor,
    this.raw = const RawMetaPayload.empty(),
  });

  factory MisskeyMetaClientOptions.fromJson(Map<String, dynamic> json) =>
      _$MisskeyMetaClientOptionsFromJson(json);

  /// Converts this model to JSON while retaining fork-specific fields and the
  /// original wire value of an unknown [entrancePageStyle].
  Map<String, dynamic> toJson() {
    final typed = _$MisskeyMetaClientOptionsToJson(this);
    if (entrancePageStyle == MisskeyEntrancePageStyle.unknown &&
        raw.json.containsKey('entrancePageStyle')) {
      typed.remove('entrancePageStyle');
    }
    return <String, dynamic>{...raw.json, ...typed};
  }

  /// The entrance page layout.
  @override
  @JsonKey(unknownEnumValue: MisskeyEntrancePageStyle.unknown)
  final MisskeyEntrancePageStyle? entrancePageStyle;

  /// Whether the timeline is visible to visitors.
  @override
  final bool? showTimelineForVisitor;

  /// Whether user activities are visible to visitors.
  @override
  final bool? showActivitiesForVisitor;

  /// The immutable original client options, including unknown fields.
  @override
  @JsonKey(
    includeToJson: false,
    readValue: _readWholeObject,
    fromJson: _rawFromJson,
  )
  final RawMetaPayload raw;

  static Object? _readWholeObject(Map<dynamic, dynamic> json, String _) => json;

  static RawMetaPayload _rawFromJson(Object? json) =>
      RawMetaPayload(Map<String, dynamic>.from(json! as Map));
}

/// Feature flags advertised by a detailed `/api/meta` response.
@freezed
@JsonSerializable(includeIfNull: false)
class MisskeyMetaFeatures with _$MisskeyMetaFeatures {
  const MisskeyMetaFeatures({
    this.registration,
    this.emailRequiredForSignup,
    this.localTimeline,
    this.globalTimeline,
    this.hcaptcha,
    this.turnstile,
    this.recaptcha,
    this.objectStorage,
    this.serviceWorker,
    this.miauth,
  });

  factory MisskeyMetaFeatures.fromJson(Map<String, dynamic> json) =>
      _$MisskeyMetaFeaturesFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyMetaFeaturesToJson(this);

  /// Whether registration is available.
  @override
  final bool? registration;

  /// Whether an email address is required for registration.
  @override
  final bool? emailRequiredForSignup;

  /// Whether the local timeline is available.
  @override
  final bool? localTimeline;

  /// Whether the global timeline is available.
  @override
  final bool? globalTimeline;

  /// Whether hCaptcha is available.
  @override
  final bool? hcaptcha;

  /// Whether Turnstile is available.
  @override
  final bool? turnstile;

  /// Whether reCAPTCHA is available.
  @override
  final bool? recaptcha;

  /// Whether object storage is enabled.
  @override
  final bool? objectStorage;

  /// Whether the service worker is enabled.
  @override
  final bool? serviceWorker;

  /// Whether MiAuth is available.
  @override
  final bool? miauth;
}

/// An advertisement returned by `/api/meta`.
@freezed
@JsonSerializable()
class MisskeyMetaAd with _$MisskeyMetaAd {
  const MisskeyMetaAd({
    required this.id,
    required this.url,
    required this.place,
    required this.ratio,
    required this.imageUrl,
    required this.dayOfWeek,
    this.isSensitive,
  });

  factory MisskeyMetaAd.fromJson(Map<String, dynamic> json) =>
      _$MisskeyMetaAdFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyMetaAdToJson(this);

  /// The advertisement ID.
  @override
  final String id;

  /// The destination URL.
  @override
  final String url;

  /// The placement identifier.
  @override
  final String place;

  /// The relative display ratio.
  @override
  final num ratio;

  /// The advertisement image URL.
  @override
  final String imageUrl;

  /// The day-of-week bit mask.
  @override
  final int dayOfWeek;

  /// Whether the advertisement is sensitive.
  @override
  final bool? isSensitive;
}

/// Sentry settings exposed to the Misskey web client.
@freezed
@JsonSerializable()
class MisskeyMetaSentryConfig with _$MisskeyMetaSentryConfig {
  const MisskeyMetaSentryConfig({
    required this.options,
    this.vueIntegration,
    this.browserTracingIntegration,
    this.replayIntegration,
  });

  factory MisskeyMetaSentryConfig.fromJson(Map<String, dynamic> json) =>
      _$MisskeyMetaSentryConfigFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyMetaSentryConfigToJson(this);

  /// Core Sentry client options.
  @override
  final MisskeyMetaSentryOptions options;

  /// Additional options for the Vue integration.
  @override
  final Map<String, dynamic>? vueIntegration;

  /// Additional options for browser tracing.
  @override
  final Map<String, dynamic>? browserTracingIntegration;

  /// Additional options for session replay.
  @override
  final Map<String, dynamic>? replayIntegration;
}

/// Core Sentry options exposed by an instance.
@freezed
@JsonSerializable()
class MisskeyMetaSentryOptions with _$MisskeyMetaSentryOptions {
  const MisskeyMetaSentryOptions({required this.dsn});

  factory MisskeyMetaSentryOptions.fromJson(Map<String, dynamic> json) =>
      _$MisskeyMetaSentryOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyMetaSentryOptionsToJson(this);

  /// The Sentry data source name.
  @override
  final String dsn;
}
