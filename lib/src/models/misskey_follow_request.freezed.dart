// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_follow_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyFollowRequest {

 String get id; MisskeyUser get follower; MisskeyUser get followee;
/// Create a copy of MisskeyFollowRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyFollowRequestCopyWith<MisskeyFollowRequest> get copyWith => _$MisskeyFollowRequestCopyWithImpl<MisskeyFollowRequest>(this as MisskeyFollowRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyFollowRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.follower, follower) || other.follower == follower)&&(identical(other.followee, followee) || other.followee == followee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,follower,followee);

@override
String toString() {
  return 'MisskeyFollowRequest(id: $id, follower: $follower, followee: $followee)';
}


}

/// @nodoc
abstract mixin class $MisskeyFollowRequestCopyWith<$Res>  {
  factory $MisskeyFollowRequestCopyWith(MisskeyFollowRequest value, $Res Function(MisskeyFollowRequest) _then) = _$MisskeyFollowRequestCopyWithImpl;
@useResult
$Res call({
 String id, MisskeyUser follower, MisskeyUser followee
});




}
/// @nodoc
class _$MisskeyFollowRequestCopyWithImpl<$Res>
    implements $MisskeyFollowRequestCopyWith<$Res> {
  _$MisskeyFollowRequestCopyWithImpl(this._self, this._then);

  final MisskeyFollowRequest _self;
  final $Res Function(MisskeyFollowRequest) _then;

/// Create a copy of MisskeyFollowRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? follower = null,Object? followee = null,}) {
  return _then(MisskeyFollowRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,follower: null == follower ? _self.follower : follower // ignore: cast_nullable_to_non_nullable
as MisskeyUser,followee: null == followee ? _self.followee : followee // ignore: cast_nullable_to_non_nullable
as MisskeyUser,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyFollowRequest].
extension MisskeyFollowRequestPatterns on MisskeyFollowRequest {
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
