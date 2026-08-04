import 'package:json_annotation/json_annotation.dart';

part 'misskey_admin_meta.g.dart';

/// Response model for the Misskey `/api/admin/meta` endpoint.
///
/// The admin meta contains ~130 instance settings. This model types the
/// commonly used moderation / federation / registration fields while
/// retaining the full response in [raw] (following the same pattern
/// as `Meta`).
@JsonSerializable()
class MisskeyAdminMeta {
  const MisskeyAdminMeta({
    this.maintainerName,
    this.maintainerEmail,
    this.name,
    this.description,
    this.langs,
    this.tosUrl,
    this.privacyPolicyUrl,
    this.impressumUrl,
    this.inquiryUrl,
    this.repositoryUrl,
    this.feedbackUrl,
    this.disableRegistration,
    this.emailRequiredForSignup,
    this.enableEmail,
    this.enableServiceWorker,
    this.enableIpLogging,
    this.enableActiveEmailValidation,
    this.cacheRemoteFiles,
    this.cacheRemoteSensitiveFiles,
    this.federation,
    this.federationHosts,
    this.blockedHosts,
    this.silencedHosts,
    this.mediaSilencedHosts,
    this.sensitiveWords,
    this.prohibitedWords,
    this.hiddenTags,
    this.bannedEmailDomains,
    this.preservedUsernames,
    this.proxyAccountId,
    this.notesPerOneAd,
    this.enableHcaptcha,
    this.enableRecaptcha,
    this.enableTurnstile,
    this.swPublicKey,
    this.raw = const <String, dynamic>{},
  });

  factory MisskeyAdminMeta.fromJson(Map<String, dynamic> json) {
    final instance = _$MisskeyAdminMetaFromJson(json);
    // 全フィールドを保持しておき、型付けしていない設定値の参照を可能にする
    return MisskeyAdminMeta(
      maintainerName: instance.maintainerName,
      maintainerEmail: instance.maintainerEmail,
      name: instance.name,
      description: instance.description,
      langs: instance.langs,
      tosUrl: instance.tosUrl,
      privacyPolicyUrl: instance.privacyPolicyUrl,
      impressumUrl: instance.impressumUrl,
      inquiryUrl: instance.inquiryUrl,
      repositoryUrl: instance.repositoryUrl,
      feedbackUrl: instance.feedbackUrl,
      disableRegistration: instance.disableRegistration,
      emailRequiredForSignup: instance.emailRequiredForSignup,
      enableEmail: instance.enableEmail,
      enableServiceWorker: instance.enableServiceWorker,
      enableIpLogging: instance.enableIpLogging,
      enableActiveEmailValidation: instance.enableActiveEmailValidation,
      cacheRemoteFiles: instance.cacheRemoteFiles,
      cacheRemoteSensitiveFiles: instance.cacheRemoteSensitiveFiles,
      federation: instance.federation,
      federationHosts: instance.federationHosts,
      blockedHosts: instance.blockedHosts,
      silencedHosts: instance.silencedHosts,
      mediaSilencedHosts: instance.mediaSilencedHosts,
      sensitiveWords: instance.sensitiveWords,
      prohibitedWords: instance.prohibitedWords,
      hiddenTags: instance.hiddenTags,
      bannedEmailDomains: instance.bannedEmailDomains,
      preservedUsernames: instance.preservedUsernames,
      proxyAccountId: instance.proxyAccountId,
      notesPerOneAd: instance.notesPerOneAd,
      enableHcaptcha: instance.enableHcaptcha,
      enableRecaptcha: instance.enableRecaptcha,
      enableTurnstile: instance.enableTurnstile,
      swPublicKey: instance.swPublicKey,
      raw: json,
    );
  }

  /// The maintainer's name.
  final String? maintainerName;

  /// The maintainer's contact email.
  final String? maintainerEmail;

  /// The instance name.
  final String? name;

  /// The instance description.
  final String? description;

  /// The languages supported by the instance.
  final List<String>? langs;

  /// The Terms of Service URL.
  final String? tosUrl;

  /// The privacy policy URL.
  final String? privacyPolicyUrl;

  /// The impressum URL.
  final String? impressumUrl;

  /// The inquiry URL.
  final String? inquiryUrl;

  /// The source code repository URL.
  final String? repositoryUrl;

  /// The feedback URL.
  final String? feedbackUrl;

  /// Whether new user registration is disabled.
  final bool? disableRegistration;

  /// Whether email is required for sign-up.
  final bool? emailRequiredForSignup;

  /// Whether email delivery is enabled.
  final bool? enableEmail;

  /// Whether the service worker is enabled.
  final bool? enableServiceWorker;

  /// Whether IP address logging is enabled.
  final bool? enableIpLogging;

  /// Whether active email validation is enabled.
  final bool? enableActiveEmailValidation;

  /// Whether remote files are cached locally.
  final bool? cacheRemoteFiles;

  /// Whether remote sensitive files are cached locally.
  final bool? cacheRemoteSensitiveFiles;

  /// The federation mode (`all`, `specified`, or `none`).
  final String? federation;

  /// Hosts allowed to federate when [federation] is `specified`.
  final List<String>? federationHosts;

  /// Blocked federation hosts.
  final List<String>? blockedHosts;

  /// Silenced federation hosts.
  final List<String>? silencedHosts;

  /// Media-silenced federation hosts.
  final List<String>? mediaSilencedHosts;

  /// Sensitive word patterns.
  final List<String>? sensitiveWords;

  /// Prohibited word patterns.
  final List<String>? prohibitedWords;

  /// Hashtags hidden from trends.
  final List<String>? hiddenTags;

  /// Email domains banned from sign-up.
  final List<String>? bannedEmailDomains;

  /// Usernames reserved by the instance.
  final List<String>? preservedUsernames;

  /// The proxy account's user ID.
  final String? proxyAccountId;

  /// The number of notes displayed per ad insertion.
  final int? notesPerOneAd;

  /// Whether hCaptcha is enabled.
  final bool? enableHcaptcha;

  /// Whether reCAPTCHA is enabled.
  final bool? enableRecaptcha;

  /// Whether Turnstile is enabled.
  final bool? enableTurnstile;

  /// The service worker VAPID public key.
  final String? swPublicKey;

  /// A map holding all response JSON fields, including ones not typed above.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Map<String, dynamic> raw;

  Map<String, dynamic> toJson() => _$MisskeyAdminMetaToJson(this);
}
