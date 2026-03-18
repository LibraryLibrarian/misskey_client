import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

/// Response model for the Misskey `/api/meta` endpoint.
///
/// Provides typed fields while retaining unknown fields in [raw].
@JsonSerializable()
class Meta {
  const Meta({
    this.maintainerName,
    this.maintainerEmail,
    this.version,
    this.name,
    this.shortName,
    this.uri,
    this.description,
    this.langs,
    this.disableRegistration,
    this.emailRequiredForSignup,
    this.enableHcaptcha,
    this.enableRecaptcha,
    this.enableTurnstile,
    this.maxNoteTextLength,
    this.enableEmail,
    this.enableServiceWorker,
    this.translatorAvailable,
    this.mediaProxy,
    this.cacheRemoteFiles,
    this.cacheRemoteSensitiveFiles,
    this.requireSetup,
    this.notesPerOneAd,
    this.raw = const <String, dynamic>{},
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    final instance = _$MetaFromJson(json);
    // Store the full raw JSON for capability detection
    return Meta(
      maintainerName: instance.maintainerName,
      maintainerEmail: instance.maintainerEmail,
      version: instance.version,
      name: instance.name,
      shortName: instance.shortName,
      uri: instance.uri,
      description: instance.description,
      langs: instance.langs,
      disableRegistration: instance.disableRegistration,
      emailRequiredForSignup: instance.emailRequiredForSignup,
      enableHcaptcha: instance.enableHcaptcha,
      enableRecaptcha: instance.enableRecaptcha,
      enableTurnstile: instance.enableTurnstile,
      maxNoteTextLength: instance.maxNoteTextLength,
      enableEmail: instance.enableEmail,
      enableServiceWorker: instance.enableServiceWorker,
      translatorAvailable: instance.translatorAvailable,
      mediaProxy: instance.mediaProxy,
      cacheRemoteFiles: instance.cacheRemoteFiles,
      cacheRemoteSensitiveFiles: instance.cacheRemoteSensitiveFiles,
      requireSetup: instance.requireSetup,
      notesPerOneAd: instance.notesPerOneAd,
      raw: Map<String, dynamic>.from(json),
    );
  }

  /// The instance maintainer's display name.
  final String? maintainerName;

  /// The instance maintainer's email address.
  final String? maintainerEmail;

  /// The Misskey software version.
  final String? version;

  /// The instance name.
  final String? name;

  /// The instance short name.
  final String? shortName;

  /// The instance URI.
  final String? uri;

  /// The instance description.
  final String? description;

  /// The languages supported by the instance.
  final List<String>? langs;

  /// Whether new user registration is disabled.
  final bool? disableRegistration;

  /// Whether email is required for sign-up.
  final bool? emailRequiredForSignup;

  /// Whether hCaptcha is enabled.
  final bool? enableHcaptcha;

  /// Whether reCAPTCHA is enabled.
  final bool? enableRecaptcha;

  /// Whether Turnstile is enabled.
  final bool? enableTurnstile;

  /// The maximum allowed note text length.
  @JsonKey(defaultValue: 3000)
  final int? maxNoteTextLength;

  /// Whether email delivery is enabled.
  final bool? enableEmail;

  /// Whether the service worker is enabled.
  final bool? enableServiceWorker;

  /// Whether the translator feature is available.
  final bool? translatorAvailable;

  /// The media proxy URL.
  final String? mediaProxy;

  /// Whether remote files are cached locally.
  final bool? cacheRemoteFiles;

  /// Whether remote sensitive files are cached locally.
  final bool? cacheRemoteSensitiveFiles;

  /// Whether initial setup is required.
  final bool? requireSetup;

  /// The number of notes displayed per ad insertion.
  @JsonKey(defaultValue: 0)
  final int? notesPerOneAd;

  /// A map holding all response JSON fields for capability detection.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Map<String, dynamic> raw;

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
