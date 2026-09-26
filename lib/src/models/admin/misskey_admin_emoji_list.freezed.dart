// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_admin_emoji_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyAdminEmojiListQuery {

 String? get updatedAtFrom; String? get updatedAtTo; String? get name; String? get host; String? get uri; String? get publicUrl; String? get originalUrl; String? get type; String? get aliases; String? get category; String? get license; bool? get isSensitive; bool? get localOnly; String? get hostType; List<String>? get roleIds;
/// Create a copy of MisskeyAdminEmojiListQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAdminEmojiListQueryCopyWith<MisskeyAdminEmojiListQuery> get copyWith => _$MisskeyAdminEmojiListQueryCopyWithImpl<MisskeyAdminEmojiListQuery>(this as MisskeyAdminEmojiListQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAdminEmojiListQuery&&(identical(other.updatedAtFrom, updatedAtFrom) || other.updatedAtFrom == updatedAtFrom)&&(identical(other.updatedAtTo, updatedAtTo) || other.updatedAtTo == updatedAtTo)&&(identical(other.name, name) || other.name == name)&&(identical(other.host, host) || other.host == host)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.publicUrl, publicUrl) || other.publicUrl == publicUrl)&&(identical(other.originalUrl, originalUrl) || other.originalUrl == originalUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.aliases, aliases) || other.aliases == aliases)&&(identical(other.category, category) || other.category == category)&&(identical(other.license, license) || other.license == license)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&(identical(other.localOnly, localOnly) || other.localOnly == localOnly)&&(identical(other.hostType, hostType) || other.hostType == hostType)&&const DeepCollectionEquality().equals(other.roleIds, roleIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updatedAtFrom,updatedAtTo,name,host,uri,publicUrl,originalUrl,type,aliases,category,license,isSensitive,localOnly,hostType,const DeepCollectionEquality().hash(roleIds));

@override
String toString() {
  return 'MisskeyAdminEmojiListQuery(updatedAtFrom: $updatedAtFrom, updatedAtTo: $updatedAtTo, name: $name, host: $host, uri: $uri, publicUrl: $publicUrl, originalUrl: $originalUrl, type: $type, aliases: $aliases, category: $category, license: $license, isSensitive: $isSensitive, localOnly: $localOnly, hostType: $hostType, roleIds: $roleIds)';
}


}

/// @nodoc
abstract mixin class $MisskeyAdminEmojiListQueryCopyWith<$Res>  {
  factory $MisskeyAdminEmojiListQueryCopyWith(MisskeyAdminEmojiListQuery value, $Res Function(MisskeyAdminEmojiListQuery) _then) = _$MisskeyAdminEmojiListQueryCopyWithImpl;
@useResult
$Res call({
 String? updatedAtFrom, String? updatedAtTo, String? name, String? host, String? uri, String? publicUrl, String? originalUrl, String? type, String? aliases, String? category, String? license, bool? isSensitive, bool? localOnly, String? hostType, List<String>? roleIds
});




}
/// @nodoc
class _$MisskeyAdminEmojiListQueryCopyWithImpl<$Res>
    implements $MisskeyAdminEmojiListQueryCopyWith<$Res> {
  _$MisskeyAdminEmojiListQueryCopyWithImpl(this._self, this._then);

  final MisskeyAdminEmojiListQuery _self;
  final $Res Function(MisskeyAdminEmojiListQuery) _then;

/// Create a copy of MisskeyAdminEmojiListQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updatedAtFrom = freezed,Object? updatedAtTo = freezed,Object? name = freezed,Object? host = freezed,Object? uri = freezed,Object? publicUrl = freezed,Object? originalUrl = freezed,Object? type = freezed,Object? aliases = freezed,Object? category = freezed,Object? license = freezed,Object? isSensitive = freezed,Object? localOnly = freezed,Object? hostType = freezed,Object? roleIds = freezed,}) {
  return _then(MisskeyAdminEmojiListQuery(
updatedAtFrom: freezed == updatedAtFrom ? _self.updatedAtFrom : updatedAtFrom // ignore: cast_nullable_to_non_nullable
as String?,updatedAtTo: freezed == updatedAtTo ? _self.updatedAtTo : updatedAtTo // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String?,publicUrl: freezed == publicUrl ? _self.publicUrl : publicUrl // ignore: cast_nullable_to_non_nullable
as String?,originalUrl: freezed == originalUrl ? _self.originalUrl : originalUrl // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,license: freezed == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String?,isSensitive: freezed == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool?,localOnly: freezed == localOnly ? _self.localOnly : localOnly // ignore: cast_nullable_to_non_nullable
as bool?,hostType: freezed == hostType ? _self.hostType : hostType // ignore: cast_nullable_to_non_nullable
as String?,roleIds: freezed == roleIds ? _self.roleIds : roleIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAdminEmojiListQuery].
extension MisskeyAdminEmojiListQueryPatterns on MisskeyAdminEmojiListQuery {
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
mixin _$MisskeyAdminEmojiRole {

 String get id; String get name;
/// Create a copy of MisskeyAdminEmojiRole
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAdminEmojiRoleCopyWith<MisskeyAdminEmojiRole> get copyWith => _$MisskeyAdminEmojiRoleCopyWithImpl<MisskeyAdminEmojiRole>(this as MisskeyAdminEmojiRole, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAdminEmojiRole&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MisskeyAdminEmojiRole(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $MisskeyAdminEmojiRoleCopyWith<$Res>  {
  factory $MisskeyAdminEmojiRoleCopyWith(MisskeyAdminEmojiRole value, $Res Function(MisskeyAdminEmojiRole) _then) = _$MisskeyAdminEmojiRoleCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$MisskeyAdminEmojiRoleCopyWithImpl<$Res>
    implements $MisskeyAdminEmojiRoleCopyWith<$Res> {
  _$MisskeyAdminEmojiRoleCopyWithImpl(this._self, this._then);

  final MisskeyAdminEmojiRole _self;
  final $Res Function(MisskeyAdminEmojiRole) _then;

/// Create a copy of MisskeyAdminEmojiRole
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(MisskeyAdminEmojiRole(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAdminEmojiRole].
extension MisskeyAdminEmojiRolePatterns on MisskeyAdminEmojiRole {
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
mixin _$MisskeyAdminEmojiDetailed {

 String get id; DateTime? get updatedAt; String get name; String? get host; String get publicUrl; String get originalUrl; String? get uri; String? get type; List<String> get aliases; String? get category; String? get license; bool get localOnly; bool get isSensitive; List<MisskeyAdminEmojiRole> get roleIdsThatCanBeUsedThisEmojiAsReaction;
/// Create a copy of MisskeyAdminEmojiDetailed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAdminEmojiDetailedCopyWith<MisskeyAdminEmojiDetailed> get copyWith => _$MisskeyAdminEmojiDetailedCopyWithImpl<MisskeyAdminEmojiDetailed>(this as MisskeyAdminEmojiDetailed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAdminEmojiDetailed&&(identical(other.id, id) || other.id == id)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.host, host) || other.host == host)&&(identical(other.publicUrl, publicUrl) || other.publicUrl == publicUrl)&&(identical(other.originalUrl, originalUrl) || other.originalUrl == originalUrl)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.aliases, aliases)&&(identical(other.category, category) || other.category == category)&&(identical(other.license, license) || other.license == license)&&(identical(other.localOnly, localOnly) || other.localOnly == localOnly)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&const DeepCollectionEquality().equals(other.roleIdsThatCanBeUsedThisEmojiAsReaction, roleIdsThatCanBeUsedThisEmojiAsReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,updatedAt,name,host,publicUrl,originalUrl,uri,type,const DeepCollectionEquality().hash(aliases),category,license,localOnly,isSensitive,const DeepCollectionEquality().hash(roleIdsThatCanBeUsedThisEmojiAsReaction));

@override
String toString() {
  return 'MisskeyAdminEmojiDetailed(id: $id, updatedAt: $updatedAt, name: $name, host: $host, publicUrl: $publicUrl, originalUrl: $originalUrl, uri: $uri, type: $type, aliases: $aliases, category: $category, license: $license, localOnly: $localOnly, isSensitive: $isSensitive, roleIdsThatCanBeUsedThisEmojiAsReaction: $roleIdsThatCanBeUsedThisEmojiAsReaction)';
}


}

/// @nodoc
abstract mixin class $MisskeyAdminEmojiDetailedCopyWith<$Res>  {
  factory $MisskeyAdminEmojiDetailedCopyWith(MisskeyAdminEmojiDetailed value, $Res Function(MisskeyAdminEmojiDetailed) _then) = _$MisskeyAdminEmojiDetailedCopyWithImpl;
@useResult
$Res call({
 String id, DateTime? updatedAt, String name, String? host, String publicUrl, String originalUrl, String? uri, String? type, List<String> aliases, String? category, String? license, bool localOnly, bool isSensitive, List<MisskeyAdminEmojiRole> roleIdsThatCanBeUsedThisEmojiAsReaction
});




}
/// @nodoc
class _$MisskeyAdminEmojiDetailedCopyWithImpl<$Res>
    implements $MisskeyAdminEmojiDetailedCopyWith<$Res> {
  _$MisskeyAdminEmojiDetailedCopyWithImpl(this._self, this._then);

  final MisskeyAdminEmojiDetailed _self;
  final $Res Function(MisskeyAdminEmojiDetailed) _then;

/// Create a copy of MisskeyAdminEmojiDetailed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? updatedAt = freezed,Object? name = null,Object? host = freezed,Object? publicUrl = null,Object? originalUrl = null,Object? uri = freezed,Object? type = freezed,Object? aliases = null,Object? category = freezed,Object? license = freezed,Object? localOnly = null,Object? isSensitive = null,Object? roleIdsThatCanBeUsedThisEmojiAsReaction = null,}) {
  return _then(MisskeyAdminEmojiDetailed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,publicUrl: null == publicUrl ? _self.publicUrl : publicUrl // ignore: cast_nullable_to_non_nullable
as String,originalUrl: null == originalUrl ? _self.originalUrl : originalUrl // ignore: cast_nullable_to_non_nullable
as String,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,license: freezed == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String?,localOnly: null == localOnly ? _self.localOnly : localOnly // ignore: cast_nullable_to_non_nullable
as bool,isSensitive: null == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool,roleIdsThatCanBeUsedThisEmojiAsReaction: null == roleIdsThatCanBeUsedThisEmojiAsReaction ? _self.roleIdsThatCanBeUsedThisEmojiAsReaction : roleIdsThatCanBeUsedThisEmojiAsReaction // ignore: cast_nullable_to_non_nullable
as List<MisskeyAdminEmojiRole>,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAdminEmojiDetailed].
extension MisskeyAdminEmojiDetailedPatterns on MisskeyAdminEmojiDetailed {
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
mixin _$MisskeyAdminEmojiListResult {

 List<MisskeyAdminEmojiDetailed> get emojis; int get count; int get allCount; int get allPages;
/// Create a copy of MisskeyAdminEmojiListResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAdminEmojiListResultCopyWith<MisskeyAdminEmojiListResult> get copyWith => _$MisskeyAdminEmojiListResultCopyWithImpl<MisskeyAdminEmojiListResult>(this as MisskeyAdminEmojiListResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAdminEmojiListResult&&const DeepCollectionEquality().equals(other.emojis, emojis)&&(identical(other.count, count) || other.count == count)&&(identical(other.allCount, allCount) || other.allCount == allCount)&&(identical(other.allPages, allPages) || other.allPages == allPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(emojis),count,allCount,allPages);

@override
String toString() {
  return 'MisskeyAdminEmojiListResult(emojis: $emojis, count: $count, allCount: $allCount, allPages: $allPages)';
}


}

/// @nodoc
abstract mixin class $MisskeyAdminEmojiListResultCopyWith<$Res>  {
  factory $MisskeyAdminEmojiListResultCopyWith(MisskeyAdminEmojiListResult value, $Res Function(MisskeyAdminEmojiListResult) _then) = _$MisskeyAdminEmojiListResultCopyWithImpl;
@useResult
$Res call({
 List<MisskeyAdminEmojiDetailed> emojis, int count, int allCount, int allPages
});




}
/// @nodoc
class _$MisskeyAdminEmojiListResultCopyWithImpl<$Res>
    implements $MisskeyAdminEmojiListResultCopyWith<$Res> {
  _$MisskeyAdminEmojiListResultCopyWithImpl(this._self, this._then);

  final MisskeyAdminEmojiListResult _self;
  final $Res Function(MisskeyAdminEmojiListResult) _then;

/// Create a copy of MisskeyAdminEmojiListResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emojis = null,Object? count = null,Object? allCount = null,Object? allPages = null,}) {
  return _then(MisskeyAdminEmojiListResult(
emojis: null == emojis ? _self.emojis : emojis // ignore: cast_nullable_to_non_nullable
as List<MisskeyAdminEmojiDetailed>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,allCount: null == allCount ? _self.allCount : allCount // ignore: cast_nullable_to_non_nullable
as int,allPages: null == allPages ? _self.allPages : allPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAdminEmojiListResult].
extension MisskeyAdminEmojiListResultPatterns on MisskeyAdminEmojiListResult {
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
