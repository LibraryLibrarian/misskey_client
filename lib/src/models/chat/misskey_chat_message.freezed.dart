// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyChatMessage {

 String get id; DateTime get createdAt; String get fromUserId; MisskeyUser? get fromUser; String? get toUserId; MisskeyUser? get toUser; String? get toRoomId; MisskeyChatRoom? get toRoom; String? get text; String? get fileId; MisskeyDriveFile? get file; bool? get isRead; List<MisskeyChatMessageReaction> get reactions;
/// Create a copy of MisskeyChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyChatMessageCopyWith<MisskeyChatMessage> get copyWith => _$MisskeyChatMessageCopyWithImpl<MisskeyChatMessage>(this as MisskeyChatMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.fromUser, fromUser) || other.fromUser == fromUser)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.toUser, toUser) || other.toUser == toUser)&&(identical(other.toRoomId, toRoomId) || other.toRoomId == toRoomId)&&(identical(other.toRoom, toRoom) || other.toRoom == toRoom)&&(identical(other.text, text) || other.text == text)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.file, file) || other.file == file)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&const DeepCollectionEquality().equals(other.reactions, reactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,fromUserId,fromUser,toUserId,toUser,toRoomId,toRoom,text,fileId,file,isRead,const DeepCollectionEquality().hash(reactions));

@override
String toString() {
  return 'MisskeyChatMessage(id: $id, createdAt: $createdAt, fromUserId: $fromUserId, fromUser: $fromUser, toUserId: $toUserId, toUser: $toUser, toRoomId: $toRoomId, toRoom: $toRoom, text: $text, fileId: $fileId, file: $file, isRead: $isRead, reactions: $reactions)';
}


}

/// @nodoc
abstract mixin class $MisskeyChatMessageCopyWith<$Res>  {
  factory $MisskeyChatMessageCopyWith(MisskeyChatMessage value, $Res Function(MisskeyChatMessage) _then) = _$MisskeyChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String fromUserId, MisskeyUser? fromUser, String? toUserId, MisskeyUser? toUser, String? toRoomId, MisskeyChatRoom? toRoom, String? text, String? fileId, MisskeyDriveFile? file, bool? isRead, List<MisskeyChatMessageReaction> reactions
});




}
/// @nodoc
class _$MisskeyChatMessageCopyWithImpl<$Res>
    implements $MisskeyChatMessageCopyWith<$Res> {
  _$MisskeyChatMessageCopyWithImpl(this._self, this._then);

  final MisskeyChatMessage _self;
  final $Res Function(MisskeyChatMessage) _then;

/// Create a copy of MisskeyChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? fromUserId = null,Object? fromUser = freezed,Object? toUserId = freezed,Object? toUser = freezed,Object? toRoomId = freezed,Object? toRoom = freezed,Object? text = freezed,Object? fileId = freezed,Object? file = freezed,Object? isRead = freezed,Object? reactions = null,}) {
  return _then(MisskeyChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,fromUser: freezed == fromUser ? _self.fromUser : fromUser // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,toUserId: freezed == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String?,toUser: freezed == toUser ? _self.toUser : toUser // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,toRoomId: freezed == toRoomId ? _self.toRoomId : toRoomId // ignore: cast_nullable_to_non_nullable
as String?,toRoom: freezed == toRoom ? _self.toRoom : toRoom // ignore: cast_nullable_to_non_nullable
as MisskeyChatRoom?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,fileId: freezed == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String?,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as MisskeyDriveFile?,isRead: freezed == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool?,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<MisskeyChatMessageReaction>,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyChatMessage].
extension MisskeyChatMessagePatterns on MisskeyChatMessage {
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


/// @nodoc
mixin _$MisskeyChatMessageReaction {

 String get reaction; MisskeyUser? get user;
/// Create a copy of MisskeyChatMessageReaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyChatMessageReactionCopyWith<MisskeyChatMessageReaction> get copyWith => _$MisskeyChatMessageReactionCopyWithImpl<MisskeyChatMessageReaction>(this as MisskeyChatMessageReaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyChatMessageReaction&&(identical(other.reaction, reaction) || other.reaction == reaction)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reaction,user);

@override
String toString() {
  return 'MisskeyChatMessageReaction(reaction: $reaction, user: $user)';
}


}

/// @nodoc
abstract mixin class $MisskeyChatMessageReactionCopyWith<$Res>  {
  factory $MisskeyChatMessageReactionCopyWith(MisskeyChatMessageReaction value, $Res Function(MisskeyChatMessageReaction) _then) = _$MisskeyChatMessageReactionCopyWithImpl;
@useResult
$Res call({
 String reaction, MisskeyUser? user
});




}
/// @nodoc
class _$MisskeyChatMessageReactionCopyWithImpl<$Res>
    implements $MisskeyChatMessageReactionCopyWith<$Res> {
  _$MisskeyChatMessageReactionCopyWithImpl(this._self, this._then);

  final MisskeyChatMessageReaction _self;
  final $Res Function(MisskeyChatMessageReaction) _then;

/// Create a copy of MisskeyChatMessageReaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reaction = null,Object? user = freezed,}) {
  return _then(MisskeyChatMessageReaction(
reaction: null == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyChatMessageReaction].
extension MisskeyChatMessageReactionPatterns on MisskeyChatMessageReaction {
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
