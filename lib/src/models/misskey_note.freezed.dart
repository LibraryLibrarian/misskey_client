// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyNote {

 String get id; DateTime get createdAt; String get userId; MisskeyUser get user; String? get text; String? get cw; MisskeyNoteVisibility? get visibility; bool? get localOnly; MisskeyReactionAcceptance? get reactionAcceptance; int? get renoteCount; int? get repliesCount; int? get reactionCount; Map<String, int>? get reactions; Map<String, String>? get emojis; List<String>? get fileIds; List<MisskeyDriveFile>? get files; String? get replyId; String? get renoteId; MisskeyNote? get reply; MisskeyNote? get renote; String? get uri; String? get url; String? get channelId; MisskeyNoteChannel? get channel; List<String>? get mentions; List<String>? get visibleUserIds; List<String>? get tags; MisskeyPoll? get poll; String? get myReaction; int? get clippedCount; DateTime? get deletedAt; bool? get isHidden; Map<String, String>? get reactionEmojis; List<String>? get reactionAndUserPairCache;
/// Create a copy of MisskeyNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyNoteCopyWith<MisskeyNote> get copyWith => _$MisskeyNoteCopyWithImpl<MisskeyNote>(this as MisskeyNote, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyNote&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.text, text) || other.text == text)&&(identical(other.cw, cw) || other.cw == cw)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.localOnly, localOnly) || other.localOnly == localOnly)&&(identical(other.reactionAcceptance, reactionAcceptance) || other.reactionAcceptance == reactionAcceptance)&&(identical(other.renoteCount, renoteCount) || other.renoteCount == renoteCount)&&(identical(other.repliesCount, repliesCount) || other.repliesCount == repliesCount)&&(identical(other.reactionCount, reactionCount) || other.reactionCount == reactionCount)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&const DeepCollectionEquality().equals(other.emojis, emojis)&&const DeepCollectionEquality().equals(other.fileIds, fileIds)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.replyId, replyId) || other.replyId == replyId)&&(identical(other.renoteId, renoteId) || other.renoteId == renoteId)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.renote, renote) || other.renote == renote)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.url, url) || other.url == url)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.channel, channel) || other.channel == channel)&&const DeepCollectionEquality().equals(other.mentions, mentions)&&const DeepCollectionEquality().equals(other.visibleUserIds, visibleUserIds)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.poll, poll) || other.poll == poll)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.clippedCount, clippedCount) || other.clippedCount == clippedCount)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&const DeepCollectionEquality().equals(other.reactionEmojis, reactionEmojis)&&const DeepCollectionEquality().equals(other.reactionAndUserPairCache, reactionAndUserPairCache));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,createdAt,userId,user,text,cw,visibility,localOnly,reactionAcceptance,renoteCount,repliesCount,reactionCount,const DeepCollectionEquality().hash(reactions),const DeepCollectionEquality().hash(emojis),const DeepCollectionEquality().hash(fileIds),const DeepCollectionEquality().hash(files),replyId,renoteId,reply,renote,uri,url,channelId,channel,const DeepCollectionEquality().hash(mentions),const DeepCollectionEquality().hash(visibleUserIds),const DeepCollectionEquality().hash(tags),poll,myReaction,clippedCount,deletedAt,isHidden,const DeepCollectionEquality().hash(reactionEmojis),const DeepCollectionEquality().hash(reactionAndUserPairCache)]);

@override
String toString() {
  return 'MisskeyNote(id: $id, createdAt: $createdAt, userId: $userId, user: $user, text: $text, cw: $cw, visibility: $visibility, localOnly: $localOnly, reactionAcceptance: $reactionAcceptance, renoteCount: $renoteCount, repliesCount: $repliesCount, reactionCount: $reactionCount, reactions: $reactions, emojis: $emojis, fileIds: $fileIds, files: $files, replyId: $replyId, renoteId: $renoteId, reply: $reply, renote: $renote, uri: $uri, url: $url, channelId: $channelId, channel: $channel, mentions: $mentions, visibleUserIds: $visibleUserIds, tags: $tags, poll: $poll, myReaction: $myReaction, clippedCount: $clippedCount, deletedAt: $deletedAt, isHidden: $isHidden, reactionEmojis: $reactionEmojis, reactionAndUserPairCache: $reactionAndUserPairCache)';
}


}

/// @nodoc
abstract mixin class $MisskeyNoteCopyWith<$Res>  {
  factory $MisskeyNoteCopyWith(MisskeyNote value, $Res Function(MisskeyNote) _then) = _$MisskeyNoteCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String userId, MisskeyUser user, String? text, String? cw, MisskeyNoteVisibility? visibility, bool? localOnly, MisskeyReactionAcceptance? reactionAcceptance, int? renoteCount, int? repliesCount, int? reactionCount, Map<String, int>? reactions, Map<String, String>? emojis, List<String>? fileIds, List<MisskeyDriveFile>? files, String? replyId, String? renoteId, MisskeyNote? reply, MisskeyNote? renote, String? uri, String? url, String? channelId, MisskeyNoteChannel? channel, List<String>? mentions, List<String>? visibleUserIds, List<String>? tags, MisskeyPoll? poll, String? myReaction, int? clippedCount, DateTime? deletedAt, bool? isHidden, Map<String, String>? reactionEmojis, List<String>? reactionAndUserPairCache
});




}
/// @nodoc
class _$MisskeyNoteCopyWithImpl<$Res>
    implements $MisskeyNoteCopyWith<$Res> {
  _$MisskeyNoteCopyWithImpl(this._self, this._then);

  final MisskeyNote _self;
  final $Res Function(MisskeyNote) _then;

/// Create a copy of MisskeyNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? userId = null,Object? user = null,Object? text = freezed,Object? cw = freezed,Object? visibility = freezed,Object? localOnly = freezed,Object? reactionAcceptance = freezed,Object? renoteCount = freezed,Object? repliesCount = freezed,Object? reactionCount = freezed,Object? reactions = freezed,Object? emojis = freezed,Object? fileIds = freezed,Object? files = freezed,Object? replyId = freezed,Object? renoteId = freezed,Object? reply = freezed,Object? renote = freezed,Object? uri = freezed,Object? url = freezed,Object? channelId = freezed,Object? channel = freezed,Object? mentions = freezed,Object? visibleUserIds = freezed,Object? tags = freezed,Object? poll = freezed,Object? myReaction = freezed,Object? clippedCount = freezed,Object? deletedAt = freezed,Object? isHidden = freezed,Object? reactionEmojis = freezed,Object? reactionAndUserPairCache = freezed,}) {
  return _then(MisskeyNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MisskeyUser,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,cw: freezed == cw ? _self.cw : cw // ignore: cast_nullable_to_non_nullable
as String?,visibility: freezed == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as MisskeyNoteVisibility?,localOnly: freezed == localOnly ? _self.localOnly : localOnly // ignore: cast_nullable_to_non_nullable
as bool?,reactionAcceptance: freezed == reactionAcceptance ? _self.reactionAcceptance : reactionAcceptance // ignore: cast_nullable_to_non_nullable
as MisskeyReactionAcceptance?,renoteCount: freezed == renoteCount ? _self.renoteCount : renoteCount // ignore: cast_nullable_to_non_nullable
as int?,repliesCount: freezed == repliesCount ? _self.repliesCount : repliesCount // ignore: cast_nullable_to_non_nullable
as int?,reactionCount: freezed == reactionCount ? _self.reactionCount : reactionCount // ignore: cast_nullable_to_non_nullable
as int?,reactions: freezed == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,emojis: freezed == emojis ? _self.emojis : emojis // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,fileIds: freezed == fileIds ? _self.fileIds : fileIds // ignore: cast_nullable_to_non_nullable
as List<String>?,files: freezed == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<MisskeyDriveFile>?,replyId: freezed == replyId ? _self.replyId : replyId // ignore: cast_nullable_to_non_nullable
as String?,renoteId: freezed == renoteId ? _self.renoteId : renoteId // ignore: cast_nullable_to_non_nullable
as String?,reply: freezed == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as MisskeyNote?,renote: freezed == renote ? _self.renote : renote // ignore: cast_nullable_to_non_nullable
as MisskeyNote?,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,channelId: freezed == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as MisskeyNoteChannel?,mentions: freezed == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<String>?,visibleUserIds: freezed == visibleUserIds ? _self.visibleUserIds : visibleUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as MisskeyPoll?,myReaction: freezed == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as String?,clippedCount: freezed == clippedCount ? _self.clippedCount : clippedCount // ignore: cast_nullable_to_non_nullable
as int?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isHidden: freezed == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool?,reactionEmojis: freezed == reactionEmojis ? _self.reactionEmojis : reactionEmojis // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,reactionAndUserPairCache: freezed == reactionAndUserPairCache ? _self.reactionAndUserPairCache : reactionAndUserPairCache // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyNote].
extension MisskeyNotePatterns on MisskeyNote {
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
mixin _$MisskeyNoteChannel {

 String get id; String? get name; String? get color; bool? get isSensitive; bool? get allowRenoteToExternal; String? get userId;
/// Create a copy of MisskeyNoteChannel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyNoteChannelCopyWith<MisskeyNoteChannel> get copyWith => _$MisskeyNoteChannelCopyWithImpl<MisskeyNoteChannel>(this as MisskeyNoteChannel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyNoteChannel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&(identical(other.allowRenoteToExternal, allowRenoteToExternal) || other.allowRenoteToExternal == allowRenoteToExternal)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,isSensitive,allowRenoteToExternal,userId);

@override
String toString() {
  return 'MisskeyNoteChannel(id: $id, name: $name, color: $color, isSensitive: $isSensitive, allowRenoteToExternal: $allowRenoteToExternal, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $MisskeyNoteChannelCopyWith<$Res>  {
  factory $MisskeyNoteChannelCopyWith(MisskeyNoteChannel value, $Res Function(MisskeyNoteChannel) _then) = _$MisskeyNoteChannelCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String? color, bool? isSensitive, bool? allowRenoteToExternal, String? userId
});




}
/// @nodoc
class _$MisskeyNoteChannelCopyWithImpl<$Res>
    implements $MisskeyNoteChannelCopyWith<$Res> {
  _$MisskeyNoteChannelCopyWithImpl(this._self, this._then);

  final MisskeyNoteChannel _self;
  final $Res Function(MisskeyNoteChannel) _then;

/// Create a copy of MisskeyNoteChannel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? color = freezed,Object? isSensitive = freezed,Object? allowRenoteToExternal = freezed,Object? userId = freezed,}) {
  return _then(MisskeyNoteChannel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isSensitive: freezed == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool?,allowRenoteToExternal: freezed == allowRenoteToExternal ? _self.allowRenoteToExternal : allowRenoteToExternal // ignore: cast_nullable_to_non_nullable
as bool?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyNoteChannel].
extension MisskeyNoteChannelPatterns on MisskeyNoteChannel {
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
