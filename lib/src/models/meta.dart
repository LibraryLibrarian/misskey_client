import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

/// Misskey `/api/meta` レスポンスモデル
///
/// 型付きフィールドを提供しつつ、未知フィールドを [raw] に保持する。
@JsonSerializable(createToJson: false)
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

  final String? maintainerName;
  final String? maintainerEmail;
  final String? version;
  final String? name;
  final String? shortName;
  final String? uri;
  final String? description;
  final List<String>? langs;
  final bool? disableRegistration;
  final bool? emailRequiredForSignup;
  final bool? enableHcaptcha;
  final bool? enableRecaptcha;
  final bool? enableTurnstile;

  @JsonKey(defaultValue: 3000)
  final int? maxNoteTextLength;

  final bool? enableEmail;
  final bool? enableServiceWorker;
  final bool? translatorAvailable;
  final String? mediaProxy;
  final bool? cacheRemoteFiles;
  final bool? cacheRemoteSensitiveFiles;
  final bool? requireSetup;

  @JsonKey(defaultValue: 0)
  final int? notesPerOneAd;

  /// レスポンス JSON の全フィールドを保持するマップ（能力検出用）
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Map<String, dynamic> raw;
}
