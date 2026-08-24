// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_following.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyFollowing {

 String get id; DateTime get createdAt; String get followeeId; String get followerId; MisskeyUser? get followee; MisskeyUser? get follower;
/// Create a copy of MisskeyFollowing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyFollowingCopyWith<MisskeyFollowing> get copyWith => _$MisskeyFollowingCopyWithImpl<MisskeyFollowing>(this as MisskeyFollowing, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyFollowing&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.followeeId, followeeId) || other.followeeId == followeeId)&&(identical(other.followerId, followerId) || other.followerId == followerId)&&(identical(other.followee, followee) || other.followee == followee)&&(identical(other.follower, follower) || other.follower == follower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,followeeId,followerId,followee,follower);

@override
String toString() {
  return 'MisskeyFollowing(id: $id, createdAt: $createdAt, followeeId: $followeeId, followerId: $followerId, followee: $followee, follower: $follower)';
}


}

/// @nodoc
abstract mixin class $MisskeyFollowingCopyWith<$Res>  {
  factory $MisskeyFollowingCopyWith(MisskeyFollowing value, $Res Function(MisskeyFollowing) _then) = _$MisskeyFollowingCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String followeeId, String followerId, MisskeyUser? followee, MisskeyUser? follower
});




}
/// @nodoc
class _$MisskeyFollowingCopyWithImpl<$Res>
    implements $MisskeyFollowingCopyWith<$Res> {
  _$MisskeyFollowingCopyWithImpl(this._self, this._then);

  final MisskeyFollowing _self;
  final $Res Function(MisskeyFollowing) _then;

/// Create a copy of MisskeyFollowing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? followeeId = null,Object? followerId = null,Object? followee = freezed,Object? follower = freezed,}) {
  return _then(MisskeyFollowing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,followeeId: null == followeeId ? _self.followeeId : followeeId // ignore: cast_nullable_to_non_nullable
as String,followerId: null == followerId ? _self.followerId : followerId // ignore: cast_nullable_to_non_nullable
as String,followee: freezed == followee ? _self.followee : followee // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,follower: freezed == follower ? _self.follower : follower // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyFollowing].
extension MisskeyFollowingPatterns on MisskeyFollowing {
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
