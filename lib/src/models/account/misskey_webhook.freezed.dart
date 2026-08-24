// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_webhook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyWebhook {

 String get id; String get userId; String get name; List<String> get on; String get url; String get secret; bool get active; DateTime? get latestSentAt; int? get latestStatus;
/// Create a copy of MisskeyWebhook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyWebhookCopyWith<MisskeyWebhook> get copyWith => _$MisskeyWebhookCopyWithImpl<MisskeyWebhook>(this as MisskeyWebhook, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyWebhook&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.on, on)&&(identical(other.url, url) || other.url == url)&&(identical(other.secret, secret) || other.secret == secret)&&(identical(other.active, active) || other.active == active)&&(identical(other.latestSentAt, latestSentAt) || other.latestSentAt == latestSentAt)&&(identical(other.latestStatus, latestStatus) || other.latestStatus == latestStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,const DeepCollectionEquality().hash(on),url,secret,active,latestSentAt,latestStatus);

@override
String toString() {
  return 'MisskeyWebhook(id: $id, userId: $userId, name: $name, on: $on, url: $url, secret: $secret, active: $active, latestSentAt: $latestSentAt, latestStatus: $latestStatus)';
}


}

/// @nodoc
abstract mixin class $MisskeyWebhookCopyWith<$Res>  {
  factory $MisskeyWebhookCopyWith(MisskeyWebhook value, $Res Function(MisskeyWebhook) _then) = _$MisskeyWebhookCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, List<String> on, String url, String secret, bool active, DateTime? latestSentAt, int? latestStatus
});




}
/// @nodoc
class _$MisskeyWebhookCopyWithImpl<$Res>
    implements $MisskeyWebhookCopyWith<$Res> {
  _$MisskeyWebhookCopyWithImpl(this._self, this._then);

  final MisskeyWebhook _self;
  final $Res Function(MisskeyWebhook) _then;

/// Create a copy of MisskeyWebhook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? on = null,Object? url = null,Object? secret = null,Object? active = null,Object? latestSentAt = freezed,Object? latestStatus = freezed,}) {
  return _then(MisskeyWebhook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,on: null == on ? _self.on : on // ignore: cast_nullable_to_non_nullable
as List<String>,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,latestSentAt: freezed == latestSentAt ? _self.latestSentAt : latestSentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latestStatus: freezed == latestStatus ? _self.latestStatus : latestStatus // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyWebhook].
extension MisskeyWebhookPatterns on MisskeyWebhook {
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
