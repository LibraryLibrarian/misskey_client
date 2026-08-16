// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_invite_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyInviteCode {

 String get id; String get code; DateTime? get expiresAt; DateTime get createdAt; MisskeyUser? get createdBy; MisskeyUser? get usedBy; DateTime? get usedAt; bool get used;
/// Create a copy of MisskeyInviteCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyInviteCodeCopyWith<MisskeyInviteCode> get copyWith => _$MisskeyInviteCodeCopyWithImpl<MisskeyInviteCode>(this as MisskeyInviteCode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyInviteCode&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.usedBy, usedBy) || other.usedBy == usedBy)&&(identical(other.usedAt, usedAt) || other.usedAt == usedAt)&&(identical(other.used, used) || other.used == used));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,expiresAt,createdAt,createdBy,usedBy,usedAt,used);

@override
String toString() {
  return 'MisskeyInviteCode(id: $id, code: $code, expiresAt: $expiresAt, createdAt: $createdAt, createdBy: $createdBy, usedBy: $usedBy, usedAt: $usedAt, used: $used)';
}


}

/// @nodoc
abstract mixin class $MisskeyInviteCodeCopyWith<$Res>  {
  factory $MisskeyInviteCodeCopyWith(MisskeyInviteCode value, $Res Function(MisskeyInviteCode) _then) = _$MisskeyInviteCodeCopyWithImpl;
@useResult
$Res call({
 String id, String code, DateTime createdAt, bool used, DateTime? expiresAt, MisskeyUser? createdBy, MisskeyUser? usedBy, DateTime? usedAt
});




}
/// @nodoc
class _$MisskeyInviteCodeCopyWithImpl<$Res>
    implements $MisskeyInviteCodeCopyWith<$Res> {
  _$MisskeyInviteCodeCopyWithImpl(this._self, this._then);

  final MisskeyInviteCode _self;
  final $Res Function(MisskeyInviteCode) _then;

/// Create a copy of MisskeyInviteCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? createdAt = null,Object? used = null,Object? expiresAt = freezed,Object? createdBy = freezed,Object? usedBy = freezed,Object? usedAt = freezed,}) {
  return _then(MisskeyInviteCode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,usedBy: freezed == usedBy ? _self.usedBy : usedBy // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,usedAt: freezed == usedAt ? _self.usedAt : usedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyInviteCode].
extension MisskeyInviteCodePatterns on MisskeyInviteCode {
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
