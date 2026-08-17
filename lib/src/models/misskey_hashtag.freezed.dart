// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_hashtag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyHashtag {

 String get tag; int get mentionedUsersCount; int get mentionedLocalUsersCount; int get mentionedRemoteUsersCount; int get attachedUsersCount; int get attachedLocalUsersCount; int get attachedRemoteUsersCount;
/// Create a copy of MisskeyHashtag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyHashtagCopyWith<MisskeyHashtag> get copyWith => _$MisskeyHashtagCopyWithImpl<MisskeyHashtag>(this as MisskeyHashtag, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyHashtag&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.mentionedUsersCount, mentionedUsersCount) || other.mentionedUsersCount == mentionedUsersCount)&&(identical(other.mentionedLocalUsersCount, mentionedLocalUsersCount) || other.mentionedLocalUsersCount == mentionedLocalUsersCount)&&(identical(other.mentionedRemoteUsersCount, mentionedRemoteUsersCount) || other.mentionedRemoteUsersCount == mentionedRemoteUsersCount)&&(identical(other.attachedUsersCount, attachedUsersCount) || other.attachedUsersCount == attachedUsersCount)&&(identical(other.attachedLocalUsersCount, attachedLocalUsersCount) || other.attachedLocalUsersCount == attachedLocalUsersCount)&&(identical(other.attachedRemoteUsersCount, attachedRemoteUsersCount) || other.attachedRemoteUsersCount == attachedRemoteUsersCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,mentionedUsersCount,mentionedLocalUsersCount,mentionedRemoteUsersCount,attachedUsersCount,attachedLocalUsersCount,attachedRemoteUsersCount);

@override
String toString() {
  return 'MisskeyHashtag(tag: $tag, mentionedUsersCount: $mentionedUsersCount, mentionedLocalUsersCount: $mentionedLocalUsersCount, mentionedRemoteUsersCount: $mentionedRemoteUsersCount, attachedUsersCount: $attachedUsersCount, attachedLocalUsersCount: $attachedLocalUsersCount, attachedRemoteUsersCount: $attachedRemoteUsersCount)';
}


}

/// @nodoc
abstract mixin class $MisskeyHashtagCopyWith<$Res>  {
  factory $MisskeyHashtagCopyWith(MisskeyHashtag value, $Res Function(MisskeyHashtag) _then) = _$MisskeyHashtagCopyWithImpl;
@useResult
$Res call({
 String tag, int mentionedUsersCount, int mentionedLocalUsersCount, int mentionedRemoteUsersCount, int attachedUsersCount, int attachedLocalUsersCount, int attachedRemoteUsersCount
});




}
/// @nodoc
class _$MisskeyHashtagCopyWithImpl<$Res>
    implements $MisskeyHashtagCopyWith<$Res> {
  _$MisskeyHashtagCopyWithImpl(this._self, this._then);

  final MisskeyHashtag _self;
  final $Res Function(MisskeyHashtag) _then;

/// Create a copy of MisskeyHashtag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tag = null,Object? mentionedUsersCount = null,Object? mentionedLocalUsersCount = null,Object? mentionedRemoteUsersCount = null,Object? attachedUsersCount = null,Object? attachedLocalUsersCount = null,Object? attachedRemoteUsersCount = null,}) {
  return _then(MisskeyHashtag(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,mentionedUsersCount: null == mentionedUsersCount ? _self.mentionedUsersCount : mentionedUsersCount // ignore: cast_nullable_to_non_nullable
as int,mentionedLocalUsersCount: null == mentionedLocalUsersCount ? _self.mentionedLocalUsersCount : mentionedLocalUsersCount // ignore: cast_nullable_to_non_nullable
as int,mentionedRemoteUsersCount: null == mentionedRemoteUsersCount ? _self.mentionedRemoteUsersCount : mentionedRemoteUsersCount // ignore: cast_nullable_to_non_nullable
as int,attachedUsersCount: null == attachedUsersCount ? _self.attachedUsersCount : attachedUsersCount // ignore: cast_nullable_to_non_nullable
as int,attachedLocalUsersCount: null == attachedLocalUsersCount ? _self.attachedLocalUsersCount : attachedLocalUsersCount // ignore: cast_nullable_to_non_nullable
as int,attachedRemoteUsersCount: null == attachedRemoteUsersCount ? _self.attachedRemoteUsersCount : attachedRemoteUsersCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyHashtag].
extension MisskeyHashtagPatterns on MisskeyHashtag {
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
