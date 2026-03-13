// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      maintainerName: json['maintainerName'] as String?,
      maintainerEmail: json['maintainerEmail'] as String?,
      version: json['version'] as String?,
      name: json['name'] as String?,
      shortName: json['shortName'] as String?,
      uri: json['uri'] as String?,
      description: json['description'] as String?,
      langs:
          (json['langs'] as List<dynamic>?)?.map((e) => e as String).toList(),
      disableRegistration: json['disableRegistration'] as bool?,
      emailRequiredForSignup: json['emailRequiredForSignup'] as bool?,
      enableHcaptcha: json['enableHcaptcha'] as bool?,
      enableRecaptcha: json['enableRecaptcha'] as bool?,
      enableTurnstile: json['enableTurnstile'] as bool?,
      maxNoteTextLength: (json['maxNoteTextLength'] as num?)?.toInt() ?? 3000,
      enableEmail: json['enableEmail'] as bool?,
      enableServiceWorker: json['enableServiceWorker'] as bool?,
      translatorAvailable: json['translatorAvailable'] as bool?,
      mediaProxy: json['mediaProxy'] as String?,
      cacheRemoteFiles: json['cacheRemoteFiles'] as bool?,
      cacheRemoteSensitiveFiles: json['cacheRemoteSensitiveFiles'] as bool?,
      requireSetup: json['requireSetup'] as bool?,
      notesPerOneAd: (json['notesPerOneAd'] as num?)?.toInt() ?? 0,
    );
