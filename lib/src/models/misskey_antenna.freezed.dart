// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_antenna.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyAntenna {

 String get id; DateTime get createdAt; String get name; List<List<String>> get keywords; List<List<String>> get excludeKeywords; String get src; String? get userListId; List<String> get users; bool get caseSensitive; bool get localOnly; bool get excludeBots; bool get withReplies; bool get withFile; bool get excludeNotesInSensitiveChannel; bool get isActive; bool get hasUnreadNote; bool get notify;
/// Create a copy of MisskeyAntenna
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAntennaCopyWith<MisskeyAntenna> get copyWith => _$MisskeyAntennaCopyWithImpl<MisskeyAntenna>(this as MisskeyAntenna, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAntenna&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.keywords, keywords)&&const DeepCollectionEquality().equals(other.excludeKeywords, excludeKeywords)&&(identical(other.src, src) || other.src == src)&&(identical(other.userListId, userListId) || other.userListId == userListId)&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.caseSensitive, caseSensitive) || other.caseSensitive == caseSensitive)&&(identical(other.localOnly, localOnly) || other.localOnly == localOnly)&&(identical(other.excludeBots, excludeBots) || other.excludeBots == excludeBots)&&(identical(other.withReplies, withReplies) || other.withReplies == withReplies)&&(identical(other.withFile, withFile) || other.withFile == withFile)&&(identical(other.excludeNotesInSensitiveChannel, excludeNotesInSensitiveChannel) || other.excludeNotesInSensitiveChannel == excludeNotesInSensitiveChannel)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.hasUnreadNote, hasUnreadNote) || other.hasUnreadNote == hasUnreadNote)&&(identical(other.notify, notify) || other.notify == notify));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,name,const DeepCollectionEquality().hash(keywords),const DeepCollectionEquality().hash(excludeKeywords),src,userListId,const DeepCollectionEquality().hash(users),caseSensitive,localOnly,excludeBots,withReplies,withFile,excludeNotesInSensitiveChannel,isActive,hasUnreadNote,notify);

@override
String toString() {
  return 'MisskeyAntenna(id: $id, createdAt: $createdAt, name: $name, keywords: $keywords, excludeKeywords: $excludeKeywords, src: $src, userListId: $userListId, users: $users, caseSensitive: $caseSensitive, localOnly: $localOnly, excludeBots: $excludeBots, withReplies: $withReplies, withFile: $withFile, excludeNotesInSensitiveChannel: $excludeNotesInSensitiveChannel, isActive: $isActive, hasUnreadNote: $hasUnreadNote, notify: $notify)';
}


}

/// @nodoc
abstract mixin class $MisskeyAntennaCopyWith<$Res>  {
  factory $MisskeyAntennaCopyWith(MisskeyAntenna value, $Res Function(MisskeyAntenna) _then) = _$MisskeyAntennaCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String name, List<List<String>> keywords, List<List<String>> excludeKeywords, String src, String? userListId, List<String> users, bool caseSensitive, bool localOnly, bool excludeBots, bool withReplies, bool withFile, bool excludeNotesInSensitiveChannel, bool isActive, bool hasUnreadNote, bool notify
});




}
/// @nodoc
class _$MisskeyAntennaCopyWithImpl<$Res>
    implements $MisskeyAntennaCopyWith<$Res> {
  _$MisskeyAntennaCopyWithImpl(this._self, this._then);

  final MisskeyAntenna _self;
  final $Res Function(MisskeyAntenna) _then;

/// Create a copy of MisskeyAntenna
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? name = null,Object? keywords = null,Object? excludeKeywords = null,Object? src = null,Object? userListId = freezed,Object? users = null,Object? caseSensitive = null,Object? localOnly = null,Object? excludeBots = null,Object? withReplies = null,Object? withFile = null,Object? excludeNotesInSensitiveChannel = null,Object? isActive = null,Object? hasUnreadNote = null,Object? notify = null,}) {
  return _then(MisskeyAntenna(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<List<String>>,excludeKeywords: null == excludeKeywords ? _self.excludeKeywords : excludeKeywords // ignore: cast_nullable_to_non_nullable
as List<List<String>>,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,userListId: freezed == userListId ? _self.userListId : userListId // ignore: cast_nullable_to_non_nullable
as String?,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<String>,caseSensitive: null == caseSensitive ? _self.caseSensitive : caseSensitive // ignore: cast_nullable_to_non_nullable
as bool,localOnly: null == localOnly ? _self.localOnly : localOnly // ignore: cast_nullable_to_non_nullable
as bool,excludeBots: null == excludeBots ? _self.excludeBots : excludeBots // ignore: cast_nullable_to_non_nullable
as bool,withReplies: null == withReplies ? _self.withReplies : withReplies // ignore: cast_nullable_to_non_nullable
as bool,withFile: null == withFile ? _self.withFile : withFile // ignore: cast_nullable_to_non_nullable
as bool,excludeNotesInSensitiveChannel: null == excludeNotesInSensitiveChannel ? _self.excludeNotesInSensitiveChannel : excludeNotesInSensitiveChannel // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,hasUnreadNote: null == hasUnreadNote ? _self.hasUnreadNote : hasUnreadNote // ignore: cast_nullable_to_non_nullable
as bool,notify: null == notify ? _self.notify : notify // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAntenna].
extension MisskeyAntennaPatterns on MisskeyAntenna {
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
