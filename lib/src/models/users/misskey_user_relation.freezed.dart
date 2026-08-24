// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_user_relation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyUserRelation {

 String get id; bool get isFollowing; bool get hasPendingFollowRequestFromYou; bool get hasPendingFollowRequestToYou; bool get isFollowed; bool get isBlocking; bool get isBlocked; bool get isMuted; bool get isRenoteMuted;
/// Create a copy of MisskeyUserRelation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyUserRelationCopyWith<MisskeyUserRelation> get copyWith => _$MisskeyUserRelationCopyWithImpl<MisskeyUserRelation>(this as MisskeyUserRelation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyUserRelation&&(identical(other.id, id) || other.id == id)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.hasPendingFollowRequestFromYou, hasPendingFollowRequestFromYou) || other.hasPendingFollowRequestFromYou == hasPendingFollowRequestFromYou)&&(identical(other.hasPendingFollowRequestToYou, hasPendingFollowRequestToYou) || other.hasPendingFollowRequestToYou == hasPendingFollowRequestToYou)&&(identical(other.isFollowed, isFollowed) || other.isFollowed == isFollowed)&&(identical(other.isBlocking, isBlocking) || other.isBlocking == isBlocking)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isRenoteMuted, isRenoteMuted) || other.isRenoteMuted == isRenoteMuted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isFollowing,hasPendingFollowRequestFromYou,hasPendingFollowRequestToYou,isFollowed,isBlocking,isBlocked,isMuted,isRenoteMuted);

@override
String toString() {
  return 'MisskeyUserRelation(id: $id, isFollowing: $isFollowing, hasPendingFollowRequestFromYou: $hasPendingFollowRequestFromYou, hasPendingFollowRequestToYou: $hasPendingFollowRequestToYou, isFollowed: $isFollowed, isBlocking: $isBlocking, isBlocked: $isBlocked, isMuted: $isMuted, isRenoteMuted: $isRenoteMuted)';
}


}

/// @nodoc
abstract mixin class $MisskeyUserRelationCopyWith<$Res>  {
  factory $MisskeyUserRelationCopyWith(MisskeyUserRelation value, $Res Function(MisskeyUserRelation) _then) = _$MisskeyUserRelationCopyWithImpl;
@useResult
$Res call({
 String id, bool isFollowing, bool hasPendingFollowRequestFromYou, bool hasPendingFollowRequestToYou, bool isFollowed, bool isBlocking, bool isBlocked, bool isMuted, bool isRenoteMuted
});




}
/// @nodoc
class _$MisskeyUserRelationCopyWithImpl<$Res>
    implements $MisskeyUserRelationCopyWith<$Res> {
  _$MisskeyUserRelationCopyWithImpl(this._self, this._then);

  final MisskeyUserRelation _self;
  final $Res Function(MisskeyUserRelation) _then;

/// Create a copy of MisskeyUserRelation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isFollowing = null,Object? hasPendingFollowRequestFromYou = null,Object? hasPendingFollowRequestToYou = null,Object? isFollowed = null,Object? isBlocking = null,Object? isBlocked = null,Object? isMuted = null,Object? isRenoteMuted = null,}) {
  return _then(MisskeyUserRelation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,hasPendingFollowRequestFromYou: null == hasPendingFollowRequestFromYou ? _self.hasPendingFollowRequestFromYou : hasPendingFollowRequestFromYou // ignore: cast_nullable_to_non_nullable
as bool,hasPendingFollowRequestToYou: null == hasPendingFollowRequestToYou ? _self.hasPendingFollowRequestToYou : hasPendingFollowRequestToYou // ignore: cast_nullable_to_non_nullable
as bool,isFollowed: null == isFollowed ? _self.isFollowed : isFollowed // ignore: cast_nullable_to_non_nullable
as bool,isBlocking: null == isBlocking ? _self.isBlocking : isBlocking // ignore: cast_nullable_to_non_nullable
as bool,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isRenoteMuted: null == isRenoteMuted ? _self.isRenoteMuted : isRenoteMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyUserRelation].
extension MisskeyUserRelationPatterns on MisskeyUserRelation {
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
