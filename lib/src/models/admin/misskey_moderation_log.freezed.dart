// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_moderation_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyModerationLog {

 String get id; DateTime? get createdAt; String get type; Map<String, dynamic>? get info; String? get userId; MisskeyUser? get user;
/// Create a copy of MisskeyModerationLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyModerationLogCopyWith<MisskeyModerationLog> get copyWith => _$MisskeyModerationLogCopyWithImpl<MisskeyModerationLog>(this as MisskeyModerationLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyModerationLog&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.info, info)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,type,const DeepCollectionEquality().hash(info),userId,user);

@override
String toString() {
  return 'MisskeyModerationLog(id: $id, createdAt: $createdAt, type: $type, info: $info, userId: $userId, user: $user)';
}


}

/// @nodoc
abstract mixin class $MisskeyModerationLogCopyWith<$Res>  {
  factory $MisskeyModerationLogCopyWith(MisskeyModerationLog value, $Res Function(MisskeyModerationLog) _then) = _$MisskeyModerationLogCopyWithImpl;
@useResult
$Res call({
 String id, DateTime? createdAt, String type, Map<String, dynamic>? info, String? userId, MisskeyUser? user
});




}
/// @nodoc
class _$MisskeyModerationLogCopyWithImpl<$Res>
    implements $MisskeyModerationLogCopyWith<$Res> {
  _$MisskeyModerationLogCopyWithImpl(this._self, this._then);

  final MisskeyModerationLog _self;
  final $Res Function(MisskeyModerationLog) _then;

/// Create a copy of MisskeyModerationLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = freezed,Object? type = null,Object? info = freezed,Object? userId = freezed,Object? user = freezed,}) {
  return _then(MisskeyModerationLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyModerationLog].
extension MisskeyModerationLogPatterns on MisskeyModerationLog {
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
mixin _$MisskeyUserIp {

 String get ip; DateTime? get createdAt;
/// Create a copy of MisskeyUserIp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyUserIpCopyWith<MisskeyUserIp> get copyWith => _$MisskeyUserIpCopyWithImpl<MisskeyUserIp>(this as MisskeyUserIp, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyUserIp&&(identical(other.ip, ip) || other.ip == ip)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ip,createdAt);

@override
String toString() {
  return 'MisskeyUserIp(ip: $ip, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MisskeyUserIpCopyWith<$Res>  {
  factory $MisskeyUserIpCopyWith(MisskeyUserIp value, $Res Function(MisskeyUserIp) _then) = _$MisskeyUserIpCopyWithImpl;
@useResult
$Res call({
 String ip, DateTime? createdAt
});




}
/// @nodoc
class _$MisskeyUserIpCopyWithImpl<$Res>
    implements $MisskeyUserIpCopyWith<$Res> {
  _$MisskeyUserIpCopyWithImpl(this._self, this._then);

  final MisskeyUserIp _self;
  final $Res Function(MisskeyUserIp) _then;

/// Create a copy of MisskeyUserIp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ip = null,Object? createdAt = freezed,}) {
  return _then(MisskeyUserIp(
ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyUserIp].
extension MisskeyUserIpPatterns on MisskeyUserIp {
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
mixin _$MisskeyIndexStat {

 String get tablename; String get indexname; String? get schemaname; String? get tablespace; String? get indexdef;
/// Create a copy of MisskeyIndexStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyIndexStatCopyWith<MisskeyIndexStat> get copyWith => _$MisskeyIndexStatCopyWithImpl<MisskeyIndexStat>(this as MisskeyIndexStat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyIndexStat&&(identical(other.tablename, tablename) || other.tablename == tablename)&&(identical(other.indexname, indexname) || other.indexname == indexname)&&(identical(other.schemaname, schemaname) || other.schemaname == schemaname)&&(identical(other.tablespace, tablespace) || other.tablespace == tablespace)&&(identical(other.indexdef, indexdef) || other.indexdef == indexdef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tablename,indexname,schemaname,tablespace,indexdef);

@override
String toString() {
  return 'MisskeyIndexStat(tablename: $tablename, indexname: $indexname, schemaname: $schemaname, tablespace: $tablespace, indexdef: $indexdef)';
}


}

/// @nodoc
abstract mixin class $MisskeyIndexStatCopyWith<$Res>  {
  factory $MisskeyIndexStatCopyWith(MisskeyIndexStat value, $Res Function(MisskeyIndexStat) _then) = _$MisskeyIndexStatCopyWithImpl;
@useResult
$Res call({
 String tablename, String indexname, String? schemaname, String? tablespace, String? indexdef
});




}
/// @nodoc
class _$MisskeyIndexStatCopyWithImpl<$Res>
    implements $MisskeyIndexStatCopyWith<$Res> {
  _$MisskeyIndexStatCopyWithImpl(this._self, this._then);

  final MisskeyIndexStat _self;
  final $Res Function(MisskeyIndexStat) _then;

/// Create a copy of MisskeyIndexStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tablename = null,Object? indexname = null,Object? schemaname = freezed,Object? tablespace = freezed,Object? indexdef = freezed,}) {
  return _then(MisskeyIndexStat(
tablename: null == tablename ? _self.tablename : tablename // ignore: cast_nullable_to_non_nullable
as String,indexname: null == indexname ? _self.indexname : indexname // ignore: cast_nullable_to_non_nullable
as String,schemaname: freezed == schemaname ? _self.schemaname : schemaname // ignore: cast_nullable_to_non_nullable
as String?,tablespace: freezed == tablespace ? _self.tablespace : tablespace // ignore: cast_nullable_to_non_nullable
as String?,indexdef: freezed == indexdef ? _self.indexdef : indexdef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyIndexStat].
extension MisskeyIndexStatPatterns on MisskeyIndexStat {
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
mixin _$MisskeyTableStat {

 num get count; num get size;
/// Create a copy of MisskeyTableStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyTableStatCopyWith<MisskeyTableStat> get copyWith => _$MisskeyTableStatCopyWithImpl<MisskeyTableStat>(this as MisskeyTableStat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyTableStat&&(identical(other.count, count) || other.count == count)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,size);

@override
String toString() {
  return 'MisskeyTableStat(count: $count, size: $size)';
}


}

/// @nodoc
abstract mixin class $MisskeyTableStatCopyWith<$Res>  {
  factory $MisskeyTableStatCopyWith(MisskeyTableStat value, $Res Function(MisskeyTableStat) _then) = _$MisskeyTableStatCopyWithImpl;
@useResult
$Res call({
 num count, num size
});




}
/// @nodoc
class _$MisskeyTableStatCopyWithImpl<$Res>
    implements $MisskeyTableStatCopyWith<$Res> {
  _$MisskeyTableStatCopyWithImpl(this._self, this._then);

  final MisskeyTableStat _self;
  final $Res Function(MisskeyTableStat) _then;

/// Create a copy of MisskeyTableStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? size = null,}) {
  return _then(MisskeyTableStat(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as num,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyTableStat].
extension MisskeyTableStatPatterns on MisskeyTableStat {
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
