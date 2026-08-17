// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_renote_muting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyRenoteMuting {

 String get id; DateTime get createdAt; String get muteeId; MisskeyUser? get mutee;
/// Create a copy of MisskeyRenoteMuting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyRenoteMutingCopyWith<MisskeyRenoteMuting> get copyWith => _$MisskeyRenoteMutingCopyWithImpl<MisskeyRenoteMuting>(this as MisskeyRenoteMuting, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyRenoteMuting&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.muteeId, muteeId) || other.muteeId == muteeId)&&(identical(other.mutee, mutee) || other.mutee == mutee));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,muteeId,mutee);

@override
String toString() {
  return 'MisskeyRenoteMuting(id: $id, createdAt: $createdAt, muteeId: $muteeId, mutee: $mutee)';
}


}

/// @nodoc
abstract mixin class $MisskeyRenoteMutingCopyWith<$Res>  {
  factory $MisskeyRenoteMutingCopyWith(MisskeyRenoteMuting value, $Res Function(MisskeyRenoteMuting) _then) = _$MisskeyRenoteMutingCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String muteeId, MisskeyUser? mutee
});




}
/// @nodoc
class _$MisskeyRenoteMutingCopyWithImpl<$Res>
    implements $MisskeyRenoteMutingCopyWith<$Res> {
  _$MisskeyRenoteMutingCopyWithImpl(this._self, this._then);

  final MisskeyRenoteMuting _self;
  final $Res Function(MisskeyRenoteMuting) _then;

/// Create a copy of MisskeyRenoteMuting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? muteeId = null,Object? mutee = freezed,}) {
  return _then(MisskeyRenoteMuting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,muteeId: null == muteeId ? _self.muteeId : muteeId // ignore: cast_nullable_to_non_nullable
as String,mutee: freezed == mutee ? _self.mutee : mutee // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyRenoteMuting].
extension MisskeyRenoteMutingPatterns on MisskeyRenoteMuting {
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
