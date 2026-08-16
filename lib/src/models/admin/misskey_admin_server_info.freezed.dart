// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_admin_server_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyAdminServerInfo {

 String get machine; String get os; String get node; String get psql; String get redis; ServerCpuInfo get cpu; ServerMemInfo get mem; ServerFsInfo get fs; AdminServerNetInfo? get net;
/// Create a copy of MisskeyAdminServerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAdminServerInfoCopyWith<MisskeyAdminServerInfo> get copyWith => _$MisskeyAdminServerInfoCopyWithImpl<MisskeyAdminServerInfo>(this as MisskeyAdminServerInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAdminServerInfo&&(identical(other.machine, machine) || other.machine == machine)&&(identical(other.os, os) || other.os == os)&&(identical(other.node, node) || other.node == node)&&(identical(other.psql, psql) || other.psql == psql)&&(identical(other.redis, redis) || other.redis == redis)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.fs, fs) || other.fs == fs)&&(identical(other.net, net) || other.net == net));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,machine,os,node,psql,redis,cpu,mem,fs,net);

@override
String toString() {
  return 'MisskeyAdminServerInfo(machine: $machine, os: $os, node: $node, psql: $psql, redis: $redis, cpu: $cpu, mem: $mem, fs: $fs, net: $net)';
}


}

/// @nodoc
abstract mixin class $MisskeyAdminServerInfoCopyWith<$Res>  {
  factory $MisskeyAdminServerInfoCopyWith(MisskeyAdminServerInfo value, $Res Function(MisskeyAdminServerInfo) _then) = _$MisskeyAdminServerInfoCopyWithImpl;
@useResult
$Res call({
 String machine, String os, String node, String psql, String redis, ServerCpuInfo cpu, ServerMemInfo mem, ServerFsInfo fs, AdminServerNetInfo? net
});




}
/// @nodoc
class _$MisskeyAdminServerInfoCopyWithImpl<$Res>
    implements $MisskeyAdminServerInfoCopyWith<$Res> {
  _$MisskeyAdminServerInfoCopyWithImpl(this._self, this._then);

  final MisskeyAdminServerInfo _self;
  final $Res Function(MisskeyAdminServerInfo) _then;

/// Create a copy of MisskeyAdminServerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? machine = null,Object? os = null,Object? node = null,Object? psql = null,Object? redis = null,Object? cpu = null,Object? mem = null,Object? fs = null,Object? net = freezed,}) {
  return _then(MisskeyAdminServerInfo(
machine: null == machine ? _self.machine : machine // ignore: cast_nullable_to_non_nullable
as String,os: null == os ? _self.os : os // ignore: cast_nullable_to_non_nullable
as String,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,psql: null == psql ? _self.psql : psql // ignore: cast_nullable_to_non_nullable
as String,redis: null == redis ? _self.redis : redis // ignore: cast_nullable_to_non_nullable
as String,cpu: null == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as ServerCpuInfo,mem: null == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as ServerMemInfo,fs: null == fs ? _self.fs : fs // ignore: cast_nullable_to_non_nullable
as ServerFsInfo,net: freezed == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as AdminServerNetInfo?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAdminServerInfo].
extension MisskeyAdminServerInfoPatterns on MisskeyAdminServerInfo {
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
mixin _$AdminServerNetInfo {

 String? get interface;
/// Create a copy of AdminServerNetInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminServerNetInfoCopyWith<AdminServerNetInfo> get copyWith => _$AdminServerNetInfoCopyWithImpl<AdminServerNetInfo>(this as AdminServerNetInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminServerNetInfo&&(identical(other.interface, interface) || other.interface == interface));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,interface);

@override
String toString() {
  return 'AdminServerNetInfo(interface: $interface)';
}


}

/// @nodoc
abstract mixin class $AdminServerNetInfoCopyWith<$Res>  {
  factory $AdminServerNetInfoCopyWith(AdminServerNetInfo value, $Res Function(AdminServerNetInfo) _then) = _$AdminServerNetInfoCopyWithImpl;
@useResult
$Res call({
 String? interface
});




}
/// @nodoc
class _$AdminServerNetInfoCopyWithImpl<$Res>
    implements $AdminServerNetInfoCopyWith<$Res> {
  _$AdminServerNetInfoCopyWithImpl(this._self, this._then);

  final AdminServerNetInfo _self;
  final $Res Function(AdminServerNetInfo) _then;

/// Create a copy of AdminServerNetInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? interface = freezed,}) {
  return _then(AdminServerNetInfo(
interface: freezed == interface ? _self.interface : interface // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminServerNetInfo].
extension AdminServerNetInfoPatterns on AdminServerNetInfo {
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
