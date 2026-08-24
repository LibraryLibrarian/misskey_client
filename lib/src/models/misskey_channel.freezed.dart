// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_channel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyChannel {

 String get id; DateTime get createdAt; String get name; String? get description; String? get userId; DateTime? get lastNotedAt; String? get bannerUrl; List<String>? get pinnedNoteIds; String? get color; bool? get isArchived; int? get usersCount; int? get notesCount; bool? get isSensitive; bool? get allowRenoteToExternal; bool? get isFollowing; bool? get isFavorited; List<MisskeyNote>? get pinnedNotes; String? get bannerId; bool? get isMuting; bool? get hasUnreadNote;
/// Create a copy of MisskeyChannel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyChannelCopyWith<MisskeyChannel> get copyWith => _$MisskeyChannelCopyWithImpl<MisskeyChannel>(this as MisskeyChannel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyChannel&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastNotedAt, lastNotedAt) || other.lastNotedAt == lastNotedAt)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&const DeepCollectionEquality().equals(other.pinnedNoteIds, pinnedNoteIds)&&(identical(other.color, color) || other.color == color)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.usersCount, usersCount) || other.usersCount == usersCount)&&(identical(other.notesCount, notesCount) || other.notesCount == notesCount)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&(identical(other.allowRenoteToExternal, allowRenoteToExternal) || other.allowRenoteToExternal == allowRenoteToExternal)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&const DeepCollectionEquality().equals(other.pinnedNotes, pinnedNotes)&&(identical(other.bannerId, bannerId) || other.bannerId == bannerId)&&(identical(other.isMuting, isMuting) || other.isMuting == isMuting)&&(identical(other.hasUnreadNote, hasUnreadNote) || other.hasUnreadNote == hasUnreadNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,createdAt,name,description,userId,lastNotedAt,bannerUrl,const DeepCollectionEquality().hash(pinnedNoteIds),color,isArchived,usersCount,notesCount,isSensitive,allowRenoteToExternal,isFollowing,isFavorited,const DeepCollectionEquality().hash(pinnedNotes),bannerId,isMuting,hasUnreadNote]);

@override
String toString() {
  return 'MisskeyChannel(id: $id, createdAt: $createdAt, name: $name, description: $description, userId: $userId, lastNotedAt: $lastNotedAt, bannerUrl: $bannerUrl, pinnedNoteIds: $pinnedNoteIds, color: $color, isArchived: $isArchived, usersCount: $usersCount, notesCount: $notesCount, isSensitive: $isSensitive, allowRenoteToExternal: $allowRenoteToExternal, isFollowing: $isFollowing, isFavorited: $isFavorited, pinnedNotes: $pinnedNotes, bannerId: $bannerId, isMuting: $isMuting, hasUnreadNote: $hasUnreadNote)';
}


}

/// @nodoc
abstract mixin class $MisskeyChannelCopyWith<$Res>  {
  factory $MisskeyChannelCopyWith(MisskeyChannel value, $Res Function(MisskeyChannel) _then) = _$MisskeyChannelCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String name, String? description, String? userId, DateTime? lastNotedAt, String? bannerUrl, List<String>? pinnedNoteIds, String? color, bool? isArchived, int? usersCount, int? notesCount, bool? isSensitive, bool? allowRenoteToExternal, bool? isFollowing, bool? isFavorited, List<MisskeyNote>? pinnedNotes, String? bannerId, bool? isMuting, bool? hasUnreadNote
});




}
/// @nodoc
class _$MisskeyChannelCopyWithImpl<$Res>
    implements $MisskeyChannelCopyWith<$Res> {
  _$MisskeyChannelCopyWithImpl(this._self, this._then);

  final MisskeyChannel _self;
  final $Res Function(MisskeyChannel) _then;

/// Create a copy of MisskeyChannel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? name = null,Object? description = freezed,Object? userId = freezed,Object? lastNotedAt = freezed,Object? bannerUrl = freezed,Object? pinnedNoteIds = freezed,Object? color = freezed,Object? isArchived = freezed,Object? usersCount = freezed,Object? notesCount = freezed,Object? isSensitive = freezed,Object? allowRenoteToExternal = freezed,Object? isFollowing = freezed,Object? isFavorited = freezed,Object? pinnedNotes = freezed,Object? bannerId = freezed,Object? isMuting = freezed,Object? hasUnreadNote = freezed,}) {
  return _then(MisskeyChannel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,lastNotedAt: freezed == lastNotedAt ? _self.lastNotedAt : lastNotedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,pinnedNoteIds: freezed == pinnedNoteIds ? _self.pinnedNoteIds : pinnedNoteIds // ignore: cast_nullable_to_non_nullable
as List<String>?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isArchived: freezed == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool?,usersCount: freezed == usersCount ? _self.usersCount : usersCount // ignore: cast_nullable_to_non_nullable
as int?,notesCount: freezed == notesCount ? _self.notesCount : notesCount // ignore: cast_nullable_to_non_nullable
as int?,isSensitive: freezed == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool?,allowRenoteToExternal: freezed == allowRenoteToExternal ? _self.allowRenoteToExternal : allowRenoteToExternal // ignore: cast_nullable_to_non_nullable
as bool?,isFollowing: freezed == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,pinnedNotes: freezed == pinnedNotes ? _self.pinnedNotes : pinnedNotes // ignore: cast_nullable_to_non_nullable
as List<MisskeyNote>?,bannerId: freezed == bannerId ? _self.bannerId : bannerId // ignore: cast_nullable_to_non_nullable
as String?,isMuting: freezed == isMuting ? _self.isMuting : isMuting // ignore: cast_nullable_to_non_nullable
as bool?,hasUnreadNote: freezed == hasUnreadNote ? _self.hasUnreadNote : hasUnreadNote // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyChannel].
extension MisskeyChannelPatterns on MisskeyChannel {
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
