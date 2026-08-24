import 'package:freezed_annotation/freezed_annotation.dart';

import 'raw_meta_payload.dart';

part 'meta.freezed.dart';
part 'meta.g.dart';

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
    this.raw = const RawMetaPayload.empty(),
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
      raw: RawMetaPayload(Map<String, dynamic>.from(json)),
    );
  }

  /// The instance maintainer's display name.
  @override
  final String? maintainerName;

  /// The instance maintainer's email address.
  @override
  final String? maintainerEmail;

  /// The Misskey software version.
  @override
  final String? version;

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

  /// Whether new user registration is disabled.
  @override
  final bool? disableRegistration;

  /// Whether email is required for sign-up.
  @override
  final bool? emailRequiredForSignup;

  /// Whether hCaptcha is enabled.
  @override
  final bool? enableHcaptcha;

  /// Whether reCAPTCHA is enabled.
  @override
  final bool? enableRecaptcha;

  /// Whether Turnstile is enabled.
  @override
  final bool? enableTurnstile;

  /// The maximum allowed note text length.
  @override
  @JsonKey(defaultValue: 3000)
  final int? maxNoteTextLength;

  /// Whether email delivery is enabled.
  @override
  final bool? enableEmail;

  /// Whether the service worker is enabled.
  @override
  final bool? enableServiceWorker;

  /// Whether the translator feature is available.
  @override
  final bool? translatorAvailable;

  /// The media proxy URL.
  @override
  final String? mediaProxy;

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
  @JsonKey(includeFromJson: false, includeToJson: false)
  final RawMetaPayload raw;

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
