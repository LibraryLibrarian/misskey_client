// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Meta {

 String? get maintainerName; String? get maintainerEmail; String? get version; String? get name; String? get shortName; String? get uri; String? get description; List<String>? get langs; bool? get disableRegistration; bool? get emailRequiredForSignup; bool? get enableHcaptcha; bool? get enableRecaptcha; bool? get enableTurnstile; int? get maxNoteTextLength; bool? get enableEmail; bool? get enableServiceWorker; bool? get translatorAvailable; String? get mediaProxy; bool? get cacheRemoteFiles; bool? get cacheRemoteSensitiveFiles; bool? get requireSetup; int? get notesPerOneAd; RawMetaPayload get raw;
/// Create a copy of Meta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetaCopyWith<Meta> get copyWith => _$MetaCopyWithImpl<Meta>(this as Meta, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meta&&(identical(other.maintainerName, maintainerName) || other.maintainerName == maintainerName)&&(identical(other.maintainerEmail, maintainerEmail) || other.maintainerEmail == maintainerEmail)&&(identical(other.version, version) || other.version == version)&&(identical(other.name, name) || other.name == name)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.langs, langs)&&(identical(other.disableRegistration, disableRegistration) || other.disableRegistration == disableRegistration)&&(identical(other.emailRequiredForSignup, emailRequiredForSignup) || other.emailRequiredForSignup == emailRequiredForSignup)&&(identical(other.enableHcaptcha, enableHcaptcha) || other.enableHcaptcha == enableHcaptcha)&&(identical(other.enableRecaptcha, enableRecaptcha) || other.enableRecaptcha == enableRecaptcha)&&(identical(other.enableTurnstile, enableTurnstile) || other.enableTurnstile == enableTurnstile)&&(identical(other.maxNoteTextLength, maxNoteTextLength) || other.maxNoteTextLength == maxNoteTextLength)&&(identical(other.enableEmail, enableEmail) || other.enableEmail == enableEmail)&&(identical(other.enableServiceWorker, enableServiceWorker) || other.enableServiceWorker == enableServiceWorker)&&(identical(other.translatorAvailable, translatorAvailable) || other.translatorAvailable == translatorAvailable)&&(identical(other.mediaProxy, mediaProxy) || other.mediaProxy == mediaProxy)&&(identical(other.cacheRemoteFiles, cacheRemoteFiles) || other.cacheRemoteFiles == cacheRemoteFiles)&&(identical(other.cacheRemoteSensitiveFiles, cacheRemoteSensitiveFiles) || other.cacheRemoteSensitiveFiles == cacheRemoteSensitiveFiles)&&(identical(other.requireSetup, requireSetup) || other.requireSetup == requireSetup)&&(identical(other.notesPerOneAd, notesPerOneAd) || other.notesPerOneAd == notesPerOneAd)&&(identical(other.raw, raw) || other.raw == raw));
}


@override
int get hashCode => Object.hashAll([runtimeType,maintainerName,maintainerEmail,version,name,shortName,uri,description,const DeepCollectionEquality().hash(langs),disableRegistration,emailRequiredForSignup,enableHcaptcha,enableRecaptcha,enableTurnstile,maxNoteTextLength,enableEmail,enableServiceWorker,translatorAvailable,mediaProxy,cacheRemoteFiles,cacheRemoteSensitiveFiles,requireSetup,notesPerOneAd,raw]);

@override
String toString() {
  return 'Meta(maintainerName: $maintainerName, maintainerEmail: $maintainerEmail, version: $version, name: $name, shortName: $shortName, uri: $uri, description: $description, langs: $langs, disableRegistration: $disableRegistration, emailRequiredForSignup: $emailRequiredForSignup, enableHcaptcha: $enableHcaptcha, enableRecaptcha: $enableRecaptcha, enableTurnstile: $enableTurnstile, maxNoteTextLength: $maxNoteTextLength, enableEmail: $enableEmail, enableServiceWorker: $enableServiceWorker, translatorAvailable: $translatorAvailable, mediaProxy: $mediaProxy, cacheRemoteFiles: $cacheRemoteFiles, cacheRemoteSensitiveFiles: $cacheRemoteSensitiveFiles, requireSetup: $requireSetup, notesPerOneAd: $notesPerOneAd, raw: $raw)';
}


}

/// @nodoc
abstract mixin class $MetaCopyWith<$Res>  {
  factory $MetaCopyWith(Meta value, $Res Function(Meta) _then) = _$MetaCopyWithImpl;
@useResult
$Res call({
 String? maintainerName, String? maintainerEmail, String? version, String? name, String? shortName, String? uri, String? description, List<String>? langs, bool? disableRegistration, bool? emailRequiredForSignup, bool? enableHcaptcha, bool? enableRecaptcha, bool? enableTurnstile, int? maxNoteTextLength, bool? enableEmail, bool? enableServiceWorker, bool? translatorAvailable, String? mediaProxy, bool? cacheRemoteFiles, bool? cacheRemoteSensitiveFiles, bool? requireSetup, int? notesPerOneAd, RawMetaPayload raw
});




}
/// @nodoc
class _$MetaCopyWithImpl<$Res>
    implements $MetaCopyWith<$Res> {
  _$MetaCopyWithImpl(this._self, this._then);

  final Meta _self;
  final $Res Function(Meta) _then;

/// Create a copy of Meta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maintainerName = freezed,Object? maintainerEmail = freezed,Object? version = freezed,Object? name = freezed,Object? shortName = freezed,Object? uri = freezed,Object? description = freezed,Object? langs = freezed,Object? disableRegistration = freezed,Object? emailRequiredForSignup = freezed,Object? enableHcaptcha = freezed,Object? enableRecaptcha = freezed,Object? enableTurnstile = freezed,Object? maxNoteTextLength = freezed,Object? enableEmail = freezed,Object? enableServiceWorker = freezed,Object? translatorAvailable = freezed,Object? mediaProxy = freezed,Object? cacheRemoteFiles = freezed,Object? cacheRemoteSensitiveFiles = freezed,Object? requireSetup = freezed,Object? notesPerOneAd = freezed,Object? raw = null,}) {
  return _then(Meta(
maintainerName: freezed == maintainerName ? _self.maintainerName : maintainerName // ignore: cast_nullable_to_non_nullable
as String?,maintainerEmail: freezed == maintainerEmail ? _self.maintainerEmail : maintainerEmail // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,langs: freezed == langs ? _self.langs : langs // ignore: cast_nullable_to_non_nullable
as List<String>?,disableRegistration: freezed == disableRegistration ? _self.disableRegistration : disableRegistration // ignore: cast_nullable_to_non_nullable
as bool?,emailRequiredForSignup: freezed == emailRequiredForSignup ? _self.emailRequiredForSignup : emailRequiredForSignup // ignore: cast_nullable_to_non_nullable
as bool?,enableHcaptcha: freezed == enableHcaptcha ? _self.enableHcaptcha : enableHcaptcha // ignore: cast_nullable_to_non_nullable
as bool?,enableRecaptcha: freezed == enableRecaptcha ? _self.enableRecaptcha : enableRecaptcha // ignore: cast_nullable_to_non_nullable
as bool?,enableTurnstile: freezed == enableTurnstile ? _self.enableTurnstile : enableTurnstile // ignore: cast_nullable_to_non_nullable
as bool?,maxNoteTextLength: freezed == maxNoteTextLength ? _self.maxNoteTextLength : maxNoteTextLength // ignore: cast_nullable_to_non_nullable
as int?,enableEmail: freezed == enableEmail ? _self.enableEmail : enableEmail // ignore: cast_nullable_to_non_nullable
as bool?,enableServiceWorker: freezed == enableServiceWorker ? _self.enableServiceWorker : enableServiceWorker // ignore: cast_nullable_to_non_nullable
as bool?,translatorAvailable: freezed == translatorAvailable ? _self.translatorAvailable : translatorAvailable // ignore: cast_nullable_to_non_nullable
as bool?,mediaProxy: freezed == mediaProxy ? _self.mediaProxy : mediaProxy // ignore: cast_nullable_to_non_nullable
as String?,cacheRemoteFiles: freezed == cacheRemoteFiles ? _self.cacheRemoteFiles : cacheRemoteFiles // ignore: cast_nullable_to_non_nullable
as bool?,cacheRemoteSensitiveFiles: freezed == cacheRemoteSensitiveFiles ? _self.cacheRemoteSensitiveFiles : cacheRemoteSensitiveFiles // ignore: cast_nullable_to_non_nullable
as bool?,requireSetup: freezed == requireSetup ? _self.requireSetup : requireSetup // ignore: cast_nullable_to_non_nullable
as bool?,notesPerOneAd: freezed == notesPerOneAd ? _self.notesPerOneAd : notesPerOneAd // ignore: cast_nullable_to_non_nullable
as int?,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as RawMetaPayload,
  ));
}

}


/// Adds pattern-matching-related methods to [Meta].
extension MetaPatterns on Meta {
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
