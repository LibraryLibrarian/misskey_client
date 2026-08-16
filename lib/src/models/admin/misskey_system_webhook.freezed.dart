// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_system_webhook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeySystemWebhook {

 String get id; bool get isActive; DateTime? get updatedAt; DateTime? get latestSentAt; num? get latestStatus; String get name; List<String> get on; String get url; String? get secret;
/// Create a copy of MisskeySystemWebhook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeySystemWebhookCopyWith<MisskeySystemWebhook> get copyWith => _$MisskeySystemWebhookCopyWithImpl<MisskeySystemWebhook>(this as MisskeySystemWebhook, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeySystemWebhook&&(identical(other.id, id) || other.id == id)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.latestSentAt, latestSentAt) || other.latestSentAt == latestSentAt)&&(identical(other.latestStatus, latestStatus) || other.latestStatus == latestStatus)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.on, on)&&(identical(other.url, url) || other.url == url)&&(identical(other.secret, secret) || other.secret == secret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isActive,updatedAt,latestSentAt,latestStatus,name,const DeepCollectionEquality().hash(on),url,secret);

@override
String toString() {
  return 'MisskeySystemWebhook(id: $id, isActive: $isActive, updatedAt: $updatedAt, latestSentAt: $latestSentAt, latestStatus: $latestStatus, name: $name, on: $on, url: $url, secret: $secret)';
}


}

/// @nodoc
abstract mixin class $MisskeySystemWebhookCopyWith<$Res>  {
  factory $MisskeySystemWebhookCopyWith(MisskeySystemWebhook value, $Res Function(MisskeySystemWebhook) _then) = _$MisskeySystemWebhookCopyWithImpl;
@useResult
$Res call({
 String id, bool isActive, DateTime? updatedAt, DateTime? latestSentAt, num? latestStatus, String name, List<String> on, String url, String? secret
});




}
/// @nodoc
class _$MisskeySystemWebhookCopyWithImpl<$Res>
    implements $MisskeySystemWebhookCopyWith<$Res> {
  _$MisskeySystemWebhookCopyWithImpl(this._self, this._then);

  final MisskeySystemWebhook _self;
  final $Res Function(MisskeySystemWebhook) _then;

/// Create a copy of MisskeySystemWebhook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isActive = null,Object? updatedAt = freezed,Object? latestSentAt = freezed,Object? latestStatus = freezed,Object? name = null,Object? on = null,Object? url = null,Object? secret = freezed,}) {
  return _then(MisskeySystemWebhook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latestSentAt: freezed == latestSentAt ? _self.latestSentAt : latestSentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latestStatus: freezed == latestStatus ? _self.latestStatus : latestStatus // ignore: cast_nullable_to_non_nullable
as num?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,on: null == on ? _self.on : on // ignore: cast_nullable_to_non_nullable
as List<String>,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,secret: freezed == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeySystemWebhook].
extension MisskeySystemWebhookPatterns on MisskeySystemWebhook {
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
