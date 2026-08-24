// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_custom_emoji.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyCustomEmoji {

 String get shortcode; String get url; String? get category; List<String>? get aliases; bool? get localOnly; bool? get isSensitive; List<String>? get roleIdsThatCanBeUsedThisEmojiAsReaction;
/// Create a copy of MisskeyCustomEmoji
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyCustomEmojiCopyWith<MisskeyCustomEmoji> get copyWith => _$MisskeyCustomEmojiCopyWithImpl<MisskeyCustomEmoji>(this as MisskeyCustomEmoji, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyCustomEmoji&&(identical(other.shortcode, shortcode) || other.shortcode == shortcode)&&(identical(other.url, url) || other.url == url)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.aliases, aliases)&&(identical(other.localOnly, localOnly) || other.localOnly == localOnly)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&const DeepCollectionEquality().equals(other.roleIdsThatCanBeUsedThisEmojiAsReaction, roleIdsThatCanBeUsedThisEmojiAsReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shortcode,url,category,const DeepCollectionEquality().hash(aliases),localOnly,isSensitive,const DeepCollectionEquality().hash(roleIdsThatCanBeUsedThisEmojiAsReaction));

@override
String toString() {
  return 'MisskeyCustomEmoji(shortcode: $shortcode, url: $url, category: $category, aliases: $aliases, localOnly: $localOnly, isSensitive: $isSensitive, roleIdsThatCanBeUsedThisEmojiAsReaction: $roleIdsThatCanBeUsedThisEmojiAsReaction)';
}


}

/// @nodoc
abstract mixin class $MisskeyCustomEmojiCopyWith<$Res>  {
  factory $MisskeyCustomEmojiCopyWith(MisskeyCustomEmoji value, $Res Function(MisskeyCustomEmoji) _then) = _$MisskeyCustomEmojiCopyWithImpl;
@useResult
$Res call({
 String shortcode, String url, String? category, List<String>? aliases, bool? localOnly, bool? isSensitive, List<String>? roleIdsThatCanBeUsedThisEmojiAsReaction
});




}
/// @nodoc
class _$MisskeyCustomEmojiCopyWithImpl<$Res>
    implements $MisskeyCustomEmojiCopyWith<$Res> {
  _$MisskeyCustomEmojiCopyWithImpl(this._self, this._then);

  final MisskeyCustomEmoji _self;
  final $Res Function(MisskeyCustomEmoji) _then;

/// Create a copy of MisskeyCustomEmoji
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shortcode = null,Object? url = null,Object? category = freezed,Object? aliases = freezed,Object? localOnly = freezed,Object? isSensitive = freezed,Object? roleIdsThatCanBeUsedThisEmojiAsReaction = freezed,}) {
  return _then(MisskeyCustomEmoji(
shortcode: null == shortcode ? _self.shortcode : shortcode // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,localOnly: freezed == localOnly ? _self.localOnly : localOnly // ignore: cast_nullable_to_non_nullable
as bool?,isSensitive: freezed == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool?,roleIdsThatCanBeUsedThisEmojiAsReaction: freezed == roleIdsThatCanBeUsedThisEmojiAsReaction ? _self.roleIdsThatCanBeUsedThisEmojiAsReaction : roleIdsThatCanBeUsedThisEmojiAsReaction // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyCustomEmoji].
extension MisskeyCustomEmojiPatterns on MisskeyCustomEmoji {
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
