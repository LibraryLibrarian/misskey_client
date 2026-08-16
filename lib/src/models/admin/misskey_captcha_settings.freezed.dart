// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_captcha_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyCaptchaSettings {

 String get provider; MisskeyCaptchaKeys? get hcaptcha; MisskeyCaptchaKeys? get mcaptcha; MisskeyCaptchaKeys? get recaptcha; MisskeyCaptchaKeys? get turnstile;
/// Create a copy of MisskeyCaptchaSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyCaptchaSettingsCopyWith<MisskeyCaptchaSettings> get copyWith => _$MisskeyCaptchaSettingsCopyWithImpl<MisskeyCaptchaSettings>(this as MisskeyCaptchaSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyCaptchaSettings&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.hcaptcha, hcaptcha) || other.hcaptcha == hcaptcha)&&(identical(other.mcaptcha, mcaptcha) || other.mcaptcha == mcaptcha)&&(identical(other.recaptcha, recaptcha) || other.recaptcha == recaptcha)&&(identical(other.turnstile, turnstile) || other.turnstile == turnstile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,hcaptcha,mcaptcha,recaptcha,turnstile);

@override
String toString() {
  return 'MisskeyCaptchaSettings(provider: $provider, hcaptcha: $hcaptcha, mcaptcha: $mcaptcha, recaptcha: $recaptcha, turnstile: $turnstile)';
}


}

/// @nodoc
abstract mixin class $MisskeyCaptchaSettingsCopyWith<$Res>  {
  factory $MisskeyCaptchaSettingsCopyWith(MisskeyCaptchaSettings value, $Res Function(MisskeyCaptchaSettings) _then) = _$MisskeyCaptchaSettingsCopyWithImpl;
@useResult
$Res call({
 String provider, MisskeyCaptchaKeys? hcaptcha, MisskeyCaptchaKeys? mcaptcha, MisskeyCaptchaKeys? recaptcha, MisskeyCaptchaKeys? turnstile
});




}
/// @nodoc
class _$MisskeyCaptchaSettingsCopyWithImpl<$Res>
    implements $MisskeyCaptchaSettingsCopyWith<$Res> {
  _$MisskeyCaptchaSettingsCopyWithImpl(this._self, this._then);

  final MisskeyCaptchaSettings _self;
  final $Res Function(MisskeyCaptchaSettings) _then;

/// Create a copy of MisskeyCaptchaSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? hcaptcha = freezed,Object? mcaptcha = freezed,Object? recaptcha = freezed,Object? turnstile = freezed,}) {
  return _then(MisskeyCaptchaSettings(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,hcaptcha: freezed == hcaptcha ? _self.hcaptcha : hcaptcha // ignore: cast_nullable_to_non_nullable
as MisskeyCaptchaKeys?,mcaptcha: freezed == mcaptcha ? _self.mcaptcha : mcaptcha // ignore: cast_nullable_to_non_nullable
as MisskeyCaptchaKeys?,recaptcha: freezed == recaptcha ? _self.recaptcha : recaptcha // ignore: cast_nullable_to_non_nullable
as MisskeyCaptchaKeys?,turnstile: freezed == turnstile ? _self.turnstile : turnstile // ignore: cast_nullable_to_non_nullable
as MisskeyCaptchaKeys?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyCaptchaSettings].
extension MisskeyCaptchaSettingsPatterns on MisskeyCaptchaSettings {
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


/// @nodoc
mixin _$MisskeyCaptchaKeys {

 String? get siteKey; String? get secretKey; String? get instanceUrl;
/// Create a copy of MisskeyCaptchaKeys
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyCaptchaKeysCopyWith<MisskeyCaptchaKeys> get copyWith => _$MisskeyCaptchaKeysCopyWithImpl<MisskeyCaptchaKeys>(this as MisskeyCaptchaKeys, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyCaptchaKeys&&(identical(other.siteKey, siteKey) || other.siteKey == siteKey)&&(identical(other.secretKey, secretKey) || other.secretKey == secretKey)&&(identical(other.instanceUrl, instanceUrl) || other.instanceUrl == instanceUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteKey,secretKey,instanceUrl);

@override
String toString() {
  return 'MisskeyCaptchaKeys(siteKey: $siteKey, secretKey: $secretKey, instanceUrl: $instanceUrl)';
}


}

/// @nodoc
abstract mixin class $MisskeyCaptchaKeysCopyWith<$Res>  {
  factory $MisskeyCaptchaKeysCopyWith(MisskeyCaptchaKeys value, $Res Function(MisskeyCaptchaKeys) _then) = _$MisskeyCaptchaKeysCopyWithImpl;
@useResult
$Res call({
 String? siteKey, String? secretKey, String? instanceUrl
});




}
/// @nodoc
class _$MisskeyCaptchaKeysCopyWithImpl<$Res>
    implements $MisskeyCaptchaKeysCopyWith<$Res> {
  _$MisskeyCaptchaKeysCopyWithImpl(this._self, this._then);

  final MisskeyCaptchaKeys _self;
  final $Res Function(MisskeyCaptchaKeys) _then;

/// Create a copy of MisskeyCaptchaKeys
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? siteKey = freezed,Object? secretKey = freezed,Object? instanceUrl = freezed,}) {
  return _then(MisskeyCaptchaKeys(
siteKey: freezed == siteKey ? _self.siteKey : siteKey // ignore: cast_nullable_to_non_nullable
as String?,secretKey: freezed == secretKey ? _self.secretKey : secretKey // ignore: cast_nullable_to_non_nullable
as String?,instanceUrl: freezed == instanceUrl ? _self.instanceUrl : instanceUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyCaptchaKeys].
extension MisskeyCaptchaKeysPatterns on MisskeyCaptchaKeys {
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
