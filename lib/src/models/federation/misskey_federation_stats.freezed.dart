// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_federation_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyFederationStats {

 List<MisskeyFederationInstance> get topSubInstances; int get otherFollowersCount; List<MisskeyFederationInstance> get topPubInstances; int get otherFollowingCount;
/// Create a copy of MisskeyFederationStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyFederationStatsCopyWith<MisskeyFederationStats> get copyWith => _$MisskeyFederationStatsCopyWithImpl<MisskeyFederationStats>(this as MisskeyFederationStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyFederationStats&&const DeepCollectionEquality().equals(other.topSubInstances, topSubInstances)&&(identical(other.otherFollowersCount, otherFollowersCount) || other.otherFollowersCount == otherFollowersCount)&&const DeepCollectionEquality().equals(other.topPubInstances, topPubInstances)&&(identical(other.otherFollowingCount, otherFollowingCount) || other.otherFollowingCount == otherFollowingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(topSubInstances),otherFollowersCount,const DeepCollectionEquality().hash(topPubInstances),otherFollowingCount);

@override
String toString() {
  return 'MisskeyFederationStats(topSubInstances: $topSubInstances, otherFollowersCount: $otherFollowersCount, topPubInstances: $topPubInstances, otherFollowingCount: $otherFollowingCount)';
}


}

/// @nodoc
abstract mixin class $MisskeyFederationStatsCopyWith<$Res>  {
  factory $MisskeyFederationStatsCopyWith(MisskeyFederationStats value, $Res Function(MisskeyFederationStats) _then) = _$MisskeyFederationStatsCopyWithImpl;
@useResult
$Res call({
 List<MisskeyFederationInstance> topSubInstances, int otherFollowersCount, List<MisskeyFederationInstance> topPubInstances, int otherFollowingCount
});




}
/// @nodoc
class _$MisskeyFederationStatsCopyWithImpl<$Res>
    implements $MisskeyFederationStatsCopyWith<$Res> {
  _$MisskeyFederationStatsCopyWithImpl(this._self, this._then);

  final MisskeyFederationStats _self;
  final $Res Function(MisskeyFederationStats) _then;

/// Create a copy of MisskeyFederationStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topSubInstances = null,Object? otherFollowersCount = null,Object? topPubInstances = null,Object? otherFollowingCount = null,}) {
  return _then(MisskeyFederationStats(
topSubInstances: null == topSubInstances ? _self.topSubInstances : topSubInstances // ignore: cast_nullable_to_non_nullable
as List<MisskeyFederationInstance>,otherFollowersCount: null == otherFollowersCount ? _self.otherFollowersCount : otherFollowersCount // ignore: cast_nullable_to_non_nullable
as int,topPubInstances: null == topPubInstances ? _self.topPubInstances : topPubInstances // ignore: cast_nullable_to_non_nullable
as List<MisskeyFederationInstance>,otherFollowingCount: null == otherFollowingCount ? _self.otherFollowingCount : otherFollowingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyFederationStats].
extension MisskeyFederationStatsPatterns on MisskeyFederationStats {
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
