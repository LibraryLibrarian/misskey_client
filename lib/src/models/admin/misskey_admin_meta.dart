import 'package:freezed_annotation/freezed_annotation.dart';

import '../raw_meta_payload.dart';

part 'misskey_admin_meta.freezed.dart';
part 'misskey_admin_meta.g.dart';

/// Response model for the Misskey `/api/admin/meta` endpoint.
///
/// The admin meta contains ~130 instance settings. This model types the
/// commonly used moderation / federation / registration fields while
/// retaining the full response in [raw] (following the same pattern
/// as `Meta`).
@freezed
@JsonSerializable()
class MisskeyAdminMeta with _$MisskeyAdminMeta {
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
    this.raw = const RawMetaPayload.empty(),
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
      raw: RawMetaPayload(Map<String, dynamic>.from(json)),
    );
  }

  /// The maintainer's name.
  @override
  final String? maintainerName;

  /// The maintainer's contact email.
  @override
  final String? maintainerEmail;

  /// The instance name.
  @override
  final String? name;

  /// The instance description.
  @override
  final String? description;

  /// The languages supported by the instance.
  @override
  final List<String>? langs;

  /// The Terms of Service URL.
  @override
  final String? tosUrl;

  /// The privacy policy URL.
  @override
  final String? privacyPolicyUrl;

  /// The impressum URL.
  @override
  final String? impressumUrl;

  /// The inquiry URL.
  @override
  final String? inquiryUrl;

  /// The source code repository URL.
  @override
  final String? repositoryUrl;

  /// The feedback URL.
  @override
  final String? feedbackUrl;

  /// Whether new user registration is disabled.
  @override
  final bool? disableRegistration;

  /// Whether email is required for sign-up.
  @override
  final bool? emailRequiredForSignup;

  /// Whether email delivery is enabled.
  @override
  final bool? enableEmail;

  /// Whether the service worker is enabled.
  @override
  final bool? enableServiceWorker;

  /// Whether IP address logging is enabled.
  @override
  final bool? enableIpLogging;

  /// Whether active email validation is enabled.
  @override
  final bool? enableActiveEmailValidation;

  /// Whether remote files are cached locally.
  @override
  final bool? cacheRemoteFiles;

  /// Whether remote sensitive files are cached locally.
  @override
  final bool? cacheRemoteSensitiveFiles;

  /// The federation mode (`all`, `specified`, or `none`).
  @override
  final String? federation;

  /// Hosts allowed to federate when [federation] is `specified`.
  @override
  final List<String>? federationHosts;

  /// Blocked federation hosts.
  @override
  final List<String>? blockedHosts;

  /// Silenced federation hosts.
  @override
  final List<String>? silencedHosts;

  /// Media-silenced federation hosts.
  @override
  final List<String>? mediaSilencedHosts;

  /// Sensitive word patterns.
  @override
  final List<String>? sensitiveWords;

  /// Prohibited word patterns.
  @override
  final List<String>? prohibitedWords;

  /// Hashtags hidden from trends.
  @override
  final List<String>? hiddenTags;

  /// Email domains banned from sign-up.
  @override
  final List<String>? bannedEmailDomains;

  /// Usernames reserved by the instance.
  @override
  final List<String>? preservedUsernames;

  /// The proxy account's user ID.
  @override
  final String? proxyAccountId;

  /// The number of notes displayed per ad insertion.
  @override
  final int? notesPerOneAd;

  /// Whether hCaptcha is enabled.
  @override
  final bool? enableHcaptcha;

  /// Whether reCAPTCHA is enabled.
  @override
  final bool? enableRecaptcha;

  /// Whether Turnstile is enabled.
  @override
  final bool? enableTurnstile;

  /// The service worker VAPID public key.
  @override
  final String? swPublicKey;

  /// A map holding all response JSON fields, including ones not typed above.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final RawMetaPayload raw;

  Map<String, dynamic> toJson() => _$MisskeyAdminMetaToJson(this);
}
