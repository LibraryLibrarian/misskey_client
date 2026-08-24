// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_clip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyClip {

 String get id; DateTime get createdAt; DateTime? get lastClippedAt; String get userId; MisskeyUser? get user; String get name; String? get description; bool? get isPublic; int? get favoritedCount; bool? get isFavorited; int? get notesCount;
/// Create a copy of MisskeyClip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyClipCopyWith<MisskeyClip> get copyWith => _$MisskeyClipCopyWithImpl<MisskeyClip>(this as MisskeyClip, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyClip&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastClippedAt, lastClippedAt) || other.lastClippedAt == lastClippedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.favoritedCount, favoritedCount) || other.favoritedCount == favoritedCount)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&(identical(other.notesCount, notesCount) || other.notesCount == notesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,lastClippedAt,userId,user,name,description,isPublic,favoritedCount,isFavorited,notesCount);

@override
String toString() {
  return 'MisskeyClip(id: $id, createdAt: $createdAt, lastClippedAt: $lastClippedAt, userId: $userId, user: $user, name: $name, description: $description, isPublic: $isPublic, favoritedCount: $favoritedCount, isFavorited: $isFavorited, notesCount: $notesCount)';
}


}

/// @nodoc
abstract mixin class $MisskeyClipCopyWith<$Res>  {
  factory $MisskeyClipCopyWith(MisskeyClip value, $Res Function(MisskeyClip) _then) = _$MisskeyClipCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String userId, String name, DateTime? lastClippedAt, MisskeyUser? user, String? description, bool? isPublic, int? favoritedCount, bool? isFavorited, int? notesCount
});




}
/// @nodoc
class _$MisskeyClipCopyWithImpl<$Res>
    implements $MisskeyClipCopyWith<$Res> {
  _$MisskeyClipCopyWithImpl(this._self, this._then);

  final MisskeyClip _self;
  final $Res Function(MisskeyClip) _then;

/// Create a copy of MisskeyClip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? userId = null,Object? name = null,Object? lastClippedAt = freezed,Object? user = freezed,Object? description = freezed,Object? isPublic = freezed,Object? favoritedCount = freezed,Object? isFavorited = freezed,Object? notesCount = freezed,}) {
  return _then(MisskeyClip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lastClippedAt: freezed == lastClippedAt ? _self.lastClippedAt : lastClippedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isPublic: freezed == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool?,favoritedCount: freezed == favoritedCount ? _self.favoritedCount : favoritedCount // ignore: cast_nullable_to_non_nullable
as int?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,notesCount: freezed == notesCount ? _self.notesCount : notesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyClip].
extension MisskeyClipPatterns on MisskeyClip {
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
