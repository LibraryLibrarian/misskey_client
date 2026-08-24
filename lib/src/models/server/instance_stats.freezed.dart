// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instance_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstanceStats {

 int get notesCount; int get originalNotesCount; int get usersCount; int get originalUsersCount; int get instances; int get driveUsageLocal; int get driveUsageRemote; int? get reactionsCount;
/// Create a copy of InstanceStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstanceStatsCopyWith<InstanceStats> get copyWith => _$InstanceStatsCopyWithImpl<InstanceStats>(this as InstanceStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstanceStats&&(identical(other.notesCount, notesCount) || other.notesCount == notesCount)&&(identical(other.originalNotesCount, originalNotesCount) || other.originalNotesCount == originalNotesCount)&&(identical(other.usersCount, usersCount) || other.usersCount == usersCount)&&(identical(other.originalUsersCount, originalUsersCount) || other.originalUsersCount == originalUsersCount)&&(identical(other.instances, instances) || other.instances == instances)&&(identical(other.driveUsageLocal, driveUsageLocal) || other.driveUsageLocal == driveUsageLocal)&&(identical(other.driveUsageRemote, driveUsageRemote) || other.driveUsageRemote == driveUsageRemote)&&(identical(other.reactionsCount, reactionsCount) || other.reactionsCount == reactionsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notesCount,originalNotesCount,usersCount,originalUsersCount,instances,driveUsageLocal,driveUsageRemote,reactionsCount);

@override
String toString() {
  return 'InstanceStats(notesCount: $notesCount, originalNotesCount: $originalNotesCount, usersCount: $usersCount, originalUsersCount: $originalUsersCount, instances: $instances, driveUsageLocal: $driveUsageLocal, driveUsageRemote: $driveUsageRemote, reactionsCount: $reactionsCount)';
}


}

/// @nodoc
abstract mixin class $InstanceStatsCopyWith<$Res>  {
  factory $InstanceStatsCopyWith(InstanceStats value, $Res Function(InstanceStats) _then) = _$InstanceStatsCopyWithImpl;
@useResult
$Res call({
 int notesCount, int originalNotesCount, int usersCount, int originalUsersCount, int instances, int driveUsageLocal, int driveUsageRemote, int? reactionsCount
});




}
/// @nodoc
class _$InstanceStatsCopyWithImpl<$Res>
    implements $InstanceStatsCopyWith<$Res> {
  _$InstanceStatsCopyWithImpl(this._self, this._then);

  final InstanceStats _self;
  final $Res Function(InstanceStats) _then;

/// Create a copy of InstanceStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notesCount = null,Object? originalNotesCount = null,Object? usersCount = null,Object? originalUsersCount = null,Object? instances = null,Object? driveUsageLocal = null,Object? driveUsageRemote = null,Object? reactionsCount = freezed,}) {
  return _then(InstanceStats(
notesCount: null == notesCount ? _self.notesCount : notesCount // ignore: cast_nullable_to_non_nullable
as int,originalNotesCount: null == originalNotesCount ? _self.originalNotesCount : originalNotesCount // ignore: cast_nullable_to_non_nullable
as int,usersCount: null == usersCount ? _self.usersCount : usersCount // ignore: cast_nullable_to_non_nullable
as int,originalUsersCount: null == originalUsersCount ? _self.originalUsersCount : originalUsersCount // ignore: cast_nullable_to_non_nullable
as int,instances: null == instances ? _self.instances : instances // ignore: cast_nullable_to_non_nullable
as int,driveUsageLocal: null == driveUsageLocal ? _self.driveUsageLocal : driveUsageLocal // ignore: cast_nullable_to_non_nullable
as int,driveUsageRemote: null == driveUsageRemote ? _self.driveUsageRemote : driveUsageRemote // ignore: cast_nullable_to_non_nullable
as int,reactionsCount: freezed == reactionsCount ? _self.reactionsCount : reactionsCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstanceStats].
extension InstanceStatsPatterns on InstanceStats {
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
