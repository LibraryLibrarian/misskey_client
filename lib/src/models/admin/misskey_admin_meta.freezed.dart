// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_admin_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MisskeyAdminMeta {

 String? get maintainerName; String? get maintainerEmail; String? get name; String? get description; List<String>? get langs; String? get tosUrl; String? get privacyPolicyUrl; String? get impressumUrl; String? get inquiryUrl; String? get repositoryUrl; String? get feedbackUrl; bool? get disableRegistration; bool? get emailRequiredForSignup; bool? get enableEmail; bool? get enableServiceWorker; bool? get enableIpLogging; bool? get enableActiveEmailValidation; bool? get cacheRemoteFiles; bool? get cacheRemoteSensitiveFiles; String? get federation; List<String>? get federationHosts; List<String>? get blockedHosts; List<String>? get silencedHosts; List<String>? get mediaSilencedHosts; List<String>? get sensitiveWords; List<String>? get prohibitedWords; List<String>? get hiddenTags; List<String>? get bannedEmailDomains; List<String>? get preservedUsernames; String? get proxyAccountId; int? get notesPerOneAd; bool? get enableHcaptcha; bool? get enableRecaptcha; bool? get enableTurnstile; String? get swPublicKey; RawMetaPayload get raw;
/// Create a copy of MisskeyAdminMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAdminMetaCopyWith<MisskeyAdminMeta> get copyWith => _$MisskeyAdminMetaCopyWithImpl<MisskeyAdminMeta>(this as MisskeyAdminMeta, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAdminMeta&&(identical(other.maintainerName, maintainerName) || other.maintainerName == maintainerName)&&(identical(other.maintainerEmail, maintainerEmail) || other.maintainerEmail == maintainerEmail)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.langs, langs)&&(identical(other.tosUrl, tosUrl) || other.tosUrl == tosUrl)&&(identical(other.privacyPolicyUrl, privacyPolicyUrl) || other.privacyPolicyUrl == privacyPolicyUrl)&&(identical(other.impressumUrl, impressumUrl) || other.impressumUrl == impressumUrl)&&(identical(other.inquiryUrl, inquiryUrl) || other.inquiryUrl == inquiryUrl)&&(identical(other.repositoryUrl, repositoryUrl) || other.repositoryUrl == repositoryUrl)&&(identical(other.feedbackUrl, feedbackUrl) || other.feedbackUrl == feedbackUrl)&&(identical(other.disableRegistration, disableRegistration) || other.disableRegistration == disableRegistration)&&(identical(other.emailRequiredForSignup, emailRequiredForSignup) || other.emailRequiredForSignup == emailRequiredForSignup)&&(identical(other.enableEmail, enableEmail) || other.enableEmail == enableEmail)&&(identical(other.enableServiceWorker, enableServiceWorker) || other.enableServiceWorker == enableServiceWorker)&&(identical(other.enableIpLogging, enableIpLogging) || other.enableIpLogging == enableIpLogging)&&(identical(other.enableActiveEmailValidation, enableActiveEmailValidation) || other.enableActiveEmailValidation == enableActiveEmailValidation)&&(identical(other.cacheRemoteFiles, cacheRemoteFiles) || other.cacheRemoteFiles == cacheRemoteFiles)&&(identical(other.cacheRemoteSensitiveFiles, cacheRemoteSensitiveFiles) || other.cacheRemoteSensitiveFiles == cacheRemoteSensitiveFiles)&&(identical(other.federation, federation) || other.federation == federation)&&const DeepCollectionEquality().equals(other.federationHosts, federationHosts)&&const DeepCollectionEquality().equals(other.blockedHosts, blockedHosts)&&const DeepCollectionEquality().equals(other.silencedHosts, silencedHosts)&&const DeepCollectionEquality().equals(other.mediaSilencedHosts, mediaSilencedHosts)&&const DeepCollectionEquality().equals(other.sensitiveWords, sensitiveWords)&&const DeepCollectionEquality().equals(other.prohibitedWords, prohibitedWords)&&const DeepCollectionEquality().equals(other.hiddenTags, hiddenTags)&&const DeepCollectionEquality().equals(other.bannedEmailDomains, bannedEmailDomains)&&const DeepCollectionEquality().equals(other.preservedUsernames, preservedUsernames)&&(identical(other.proxyAccountId, proxyAccountId) || other.proxyAccountId == proxyAccountId)&&(identical(other.notesPerOneAd, notesPerOneAd) || other.notesPerOneAd == notesPerOneAd)&&(identical(other.enableHcaptcha, enableHcaptcha) || other.enableHcaptcha == enableHcaptcha)&&(identical(other.enableRecaptcha, enableRecaptcha) || other.enableRecaptcha == enableRecaptcha)&&(identical(other.enableTurnstile, enableTurnstile) || other.enableTurnstile == enableTurnstile)&&(identical(other.swPublicKey, swPublicKey) || other.swPublicKey == swPublicKey)&&(identical(other.raw, raw) || other.raw == raw));
}


@override
int get hashCode => Object.hashAll([runtimeType,maintainerName,maintainerEmail,name,description,const DeepCollectionEquality().hash(langs),tosUrl,privacyPolicyUrl,impressumUrl,inquiryUrl,repositoryUrl,feedbackUrl,disableRegistration,emailRequiredForSignup,enableEmail,enableServiceWorker,enableIpLogging,enableActiveEmailValidation,cacheRemoteFiles,cacheRemoteSensitiveFiles,federation,const DeepCollectionEquality().hash(federationHosts),const DeepCollectionEquality().hash(blockedHosts),const DeepCollectionEquality().hash(silencedHosts),const DeepCollectionEquality().hash(mediaSilencedHosts),const DeepCollectionEquality().hash(sensitiveWords),const DeepCollectionEquality().hash(prohibitedWords),const DeepCollectionEquality().hash(hiddenTags),const DeepCollectionEquality().hash(bannedEmailDomains),const DeepCollectionEquality().hash(preservedUsernames),proxyAccountId,notesPerOneAd,enableHcaptcha,enableRecaptcha,enableTurnstile,swPublicKey,raw]);

@override
String toString() {
  return 'MisskeyAdminMeta(maintainerName: $maintainerName, maintainerEmail: $maintainerEmail, name: $name, description: $description, langs: $langs, tosUrl: $tosUrl, privacyPolicyUrl: $privacyPolicyUrl, impressumUrl: $impressumUrl, inquiryUrl: $inquiryUrl, repositoryUrl: $repositoryUrl, feedbackUrl: $feedbackUrl, disableRegistration: $disableRegistration, emailRequiredForSignup: $emailRequiredForSignup, enableEmail: $enableEmail, enableServiceWorker: $enableServiceWorker, enableIpLogging: $enableIpLogging, enableActiveEmailValidation: $enableActiveEmailValidation, cacheRemoteFiles: $cacheRemoteFiles, cacheRemoteSensitiveFiles: $cacheRemoteSensitiveFiles, federation: $federation, federationHosts: $federationHosts, blockedHosts: $blockedHosts, silencedHosts: $silencedHosts, mediaSilencedHosts: $mediaSilencedHosts, sensitiveWords: $sensitiveWords, prohibitedWords: $prohibitedWords, hiddenTags: $hiddenTags, bannedEmailDomains: $bannedEmailDomains, preservedUsernames: $preservedUsernames, proxyAccountId: $proxyAccountId, notesPerOneAd: $notesPerOneAd, enableHcaptcha: $enableHcaptcha, enableRecaptcha: $enableRecaptcha, enableTurnstile: $enableTurnstile, swPublicKey: $swPublicKey, raw: $raw)';
}


}

/// @nodoc
abstract mixin class $MisskeyAdminMetaCopyWith<$Res>  {
  factory $MisskeyAdminMetaCopyWith(MisskeyAdminMeta value, $Res Function(MisskeyAdminMeta) _then) = _$MisskeyAdminMetaCopyWithImpl;
@useResult
$Res call({
 String? maintainerName, String? maintainerEmail, String? name, String? description, List<String>? langs, String? tosUrl, String? privacyPolicyUrl, String? impressumUrl, String? inquiryUrl, String? repositoryUrl, String? feedbackUrl, bool? disableRegistration, bool? emailRequiredForSignup, bool? enableEmail, bool? enableServiceWorker, bool? enableIpLogging, bool? enableActiveEmailValidation, bool? cacheRemoteFiles, bool? cacheRemoteSensitiveFiles, String? federation, List<String>? federationHosts, List<String>? blockedHosts, List<String>? silencedHosts, List<String>? mediaSilencedHosts, List<String>? sensitiveWords, List<String>? prohibitedWords, List<String>? hiddenTags, List<String>? bannedEmailDomains, List<String>? preservedUsernames, String? proxyAccountId, int? notesPerOneAd, bool? enableHcaptcha, bool? enableRecaptcha, bool? enableTurnstile, String? swPublicKey, RawMetaPayload raw
});




}
/// @nodoc
class _$MisskeyAdminMetaCopyWithImpl<$Res>
    implements $MisskeyAdminMetaCopyWith<$Res> {
  _$MisskeyAdminMetaCopyWithImpl(this._self, this._then);

  final MisskeyAdminMeta _self;
  final $Res Function(MisskeyAdminMeta) _then;

/// Create a copy of MisskeyAdminMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maintainerName = freezed,Object? maintainerEmail = freezed,Object? name = freezed,Object? description = freezed,Object? langs = freezed,Object? tosUrl = freezed,Object? privacyPolicyUrl = freezed,Object? impressumUrl = freezed,Object? inquiryUrl = freezed,Object? repositoryUrl = freezed,Object? feedbackUrl = freezed,Object? disableRegistration = freezed,Object? emailRequiredForSignup = freezed,Object? enableEmail = freezed,Object? enableServiceWorker = freezed,Object? enableIpLogging = freezed,Object? enableActiveEmailValidation = freezed,Object? cacheRemoteFiles = freezed,Object? cacheRemoteSensitiveFiles = freezed,Object? federation = freezed,Object? federationHosts = freezed,Object? blockedHosts = freezed,Object? silencedHosts = freezed,Object? mediaSilencedHosts = freezed,Object? sensitiveWords = freezed,Object? prohibitedWords = freezed,Object? hiddenTags = freezed,Object? bannedEmailDomains = freezed,Object? preservedUsernames = freezed,Object? proxyAccountId = freezed,Object? notesPerOneAd = freezed,Object? enableHcaptcha = freezed,Object? enableRecaptcha = freezed,Object? enableTurnstile = freezed,Object? swPublicKey = freezed,Object? raw = null,}) {
  return _then(MisskeyAdminMeta(
maintainerName: freezed == maintainerName ? _self.maintainerName : maintainerName // ignore: cast_nullable_to_non_nullable
as String?,maintainerEmail: freezed == maintainerEmail ? _self.maintainerEmail : maintainerEmail // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,langs: freezed == langs ? _self.langs : langs // ignore: cast_nullable_to_non_nullable
as List<String>?,tosUrl: freezed == tosUrl ? _self.tosUrl : tosUrl // ignore: cast_nullable_to_non_nullable
as String?,privacyPolicyUrl: freezed == privacyPolicyUrl ? _self.privacyPolicyUrl : privacyPolicyUrl // ignore: cast_nullable_to_non_nullable
as String?,impressumUrl: freezed == impressumUrl ? _self.impressumUrl : impressumUrl // ignore: cast_nullable_to_non_nullable
as String?,inquiryUrl: freezed == inquiryUrl ? _self.inquiryUrl : inquiryUrl // ignore: cast_nullable_to_non_nullable
as String?,repositoryUrl: freezed == repositoryUrl ? _self.repositoryUrl : repositoryUrl // ignore: cast_nullable_to_non_nullable
as String?,feedbackUrl: freezed == feedbackUrl ? _self.feedbackUrl : feedbackUrl // ignore: cast_nullable_to_non_nullable
as String?,disableRegistration: freezed == disableRegistration ? _self.disableRegistration : disableRegistration // ignore: cast_nullable_to_non_nullable
as bool?,emailRequiredForSignup: freezed == emailRequiredForSignup ? _self.emailRequiredForSignup : emailRequiredForSignup // ignore: cast_nullable_to_non_nullable
as bool?,enableEmail: freezed == enableEmail ? _self.enableEmail : enableEmail // ignore: cast_nullable_to_non_nullable
as bool?,enableServiceWorker: freezed == enableServiceWorker ? _self.enableServiceWorker : enableServiceWorker // ignore: cast_nullable_to_non_nullable
as bool?,enableIpLogging: freezed == enableIpLogging ? _self.enableIpLogging : enableIpLogging // ignore: cast_nullable_to_non_nullable
as bool?,enableActiveEmailValidation: freezed == enableActiveEmailValidation ? _self.enableActiveEmailValidation : enableActiveEmailValidation // ignore: cast_nullable_to_non_nullable
as bool?,cacheRemoteFiles: freezed == cacheRemoteFiles ? _self.cacheRemoteFiles : cacheRemoteFiles // ignore: cast_nullable_to_non_nullable
as bool?,cacheRemoteSensitiveFiles: freezed == cacheRemoteSensitiveFiles ? _self.cacheRemoteSensitiveFiles : cacheRemoteSensitiveFiles // ignore: cast_nullable_to_non_nullable
as bool?,federation: freezed == federation ? _self.federation : federation // ignore: cast_nullable_to_non_nullable
as String?,federationHosts: freezed == federationHosts ? _self.federationHosts : federationHosts // ignore: cast_nullable_to_non_nullable
as List<String>?,blockedHosts: freezed == blockedHosts ? _self.blockedHosts : blockedHosts // ignore: cast_nullable_to_non_nullable
as List<String>?,silencedHosts: freezed == silencedHosts ? _self.silencedHosts : silencedHosts // ignore: cast_nullable_to_non_nullable
as List<String>?,mediaSilencedHosts: freezed == mediaSilencedHosts ? _self.mediaSilencedHosts : mediaSilencedHosts // ignore: cast_nullable_to_non_nullable
as List<String>?,sensitiveWords: freezed == sensitiveWords ? _self.sensitiveWords : sensitiveWords // ignore: cast_nullable_to_non_nullable
as List<String>?,prohibitedWords: freezed == prohibitedWords ? _self.prohibitedWords : prohibitedWords // ignore: cast_nullable_to_non_nullable
as List<String>?,hiddenTags: freezed == hiddenTags ? _self.hiddenTags : hiddenTags // ignore: cast_nullable_to_non_nullable
as List<String>?,bannedEmailDomains: freezed == bannedEmailDomains ? _self.bannedEmailDomains : bannedEmailDomains // ignore: cast_nullable_to_non_nullable
as List<String>?,preservedUsernames: freezed == preservedUsernames ? _self.preservedUsernames : preservedUsernames // ignore: cast_nullable_to_non_nullable
as List<String>?,proxyAccountId: freezed == proxyAccountId ? _self.proxyAccountId : proxyAccountId // ignore: cast_nullable_to_non_nullable
as String?,notesPerOneAd: freezed == notesPerOneAd ? _self.notesPerOneAd : notesPerOneAd // ignore: cast_nullable_to_non_nullable
as int?,enableHcaptcha: freezed == enableHcaptcha ? _self.enableHcaptcha : enableHcaptcha // ignore: cast_nullable_to_non_nullable
as bool?,enableRecaptcha: freezed == enableRecaptcha ? _self.enableRecaptcha : enableRecaptcha // ignore: cast_nullable_to_non_nullable
as bool?,enableTurnstile: freezed == enableTurnstile ? _self.enableTurnstile : enableTurnstile // ignore: cast_nullable_to_non_nullable
as bool?,swPublicKey: freezed == swPublicKey ? _self.swPublicKey : swPublicKey // ignore: cast_nullable_to_non_nullable
as String?,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as RawMetaPayload,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAdminMeta].
extension MisskeyAdminMetaPatterns on MisskeyAdminMeta {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
