// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_queue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyQueueCount {

 num? get waiting; num? get active; num? get completed; num? get failed; num? get delayed; num? get paused; num? get prioritized; num? get waitingChildren;
/// Create a copy of MisskeyQueueCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyQueueCountCopyWith<MisskeyQueueCount> get copyWith => _$MisskeyQueueCountCopyWithImpl<MisskeyQueueCount>(this as MisskeyQueueCount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyQueueCount&&(identical(other.waiting, waiting) || other.waiting == waiting)&&(identical(other.active, active) || other.active == active)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.delayed, delayed) || other.delayed == delayed)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.prioritized, prioritized) || other.prioritized == prioritized)&&(identical(other.waitingChildren, waitingChildren) || other.waitingChildren == waitingChildren));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,waiting,active,completed,failed,delayed,paused,prioritized,waitingChildren);

@override
String toString() {
  return 'MisskeyQueueCount(waiting: $waiting, active: $active, completed: $completed, failed: $failed, delayed: $delayed, paused: $paused, prioritized: $prioritized, waitingChildren: $waitingChildren)';
}


}

/// @nodoc
abstract mixin class $MisskeyQueueCountCopyWith<$Res>  {
  factory $MisskeyQueueCountCopyWith(MisskeyQueueCount value, $Res Function(MisskeyQueueCount) _then) = _$MisskeyQueueCountCopyWithImpl;
@useResult
$Res call({
 num? waiting, num? active, num? completed, num? failed, num? delayed, num? paused, num? prioritized, num? waitingChildren
});




}
/// @nodoc
class _$MisskeyQueueCountCopyWithImpl<$Res>
    implements $MisskeyQueueCountCopyWith<$Res> {
  _$MisskeyQueueCountCopyWithImpl(this._self, this._then);

  final MisskeyQueueCount _self;
  final $Res Function(MisskeyQueueCount) _then;

/// Create a copy of MisskeyQueueCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? waiting = freezed,Object? active = freezed,Object? completed = freezed,Object? failed = freezed,Object? delayed = freezed,Object? paused = freezed,Object? prioritized = freezed,Object? waitingChildren = freezed,}) {
  return _then(MisskeyQueueCount(
waiting: freezed == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as num?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as num?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as num?,failed: freezed == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as num?,delayed: freezed == delayed ? _self.delayed : delayed // ignore: cast_nullable_to_non_nullable
as num?,paused: freezed == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as num?,prioritized: freezed == prioritized ? _self.prioritized : prioritized // ignore: cast_nullable_to_non_nullable
as num?,waitingChildren: freezed == waitingChildren ? _self.waitingChildren : waitingChildren // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyQueueCount].
extension MisskeyQueueCountPatterns on MisskeyQueueCount {
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
mixin _$MisskeyQueueStats {

 MisskeyQueueCount? get deliver; MisskeyQueueCount? get inbox; MisskeyQueueCount? get db; MisskeyQueueCount? get objectStorage; MisskeyQueueCount? get userWebhookDeliver; MisskeyQueueCount? get systemWebhookDeliver;
/// Create a copy of MisskeyQueueStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyQueueStatsCopyWith<MisskeyQueueStats> get copyWith => _$MisskeyQueueStatsCopyWithImpl<MisskeyQueueStats>(this as MisskeyQueueStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyQueueStats&&(identical(other.deliver, deliver) || other.deliver == deliver)&&(identical(other.inbox, inbox) || other.inbox == inbox)&&(identical(other.db, db) || other.db == db)&&(identical(other.objectStorage, objectStorage) || other.objectStorage == objectStorage)&&(identical(other.userWebhookDeliver, userWebhookDeliver) || other.userWebhookDeliver == userWebhookDeliver)&&(identical(other.systemWebhookDeliver, systemWebhookDeliver) || other.systemWebhookDeliver == systemWebhookDeliver));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deliver,inbox,db,objectStorage,userWebhookDeliver,systemWebhookDeliver);

@override
String toString() {
  return 'MisskeyQueueStats(deliver: $deliver, inbox: $inbox, db: $db, objectStorage: $objectStorage, userWebhookDeliver: $userWebhookDeliver, systemWebhookDeliver: $systemWebhookDeliver)';
}


}

/// @nodoc
abstract mixin class $MisskeyQueueStatsCopyWith<$Res>  {
  factory $MisskeyQueueStatsCopyWith(MisskeyQueueStats value, $Res Function(MisskeyQueueStats) _then) = _$MisskeyQueueStatsCopyWithImpl;
@useResult
$Res call({
 MisskeyQueueCount? deliver, MisskeyQueueCount? inbox, MisskeyQueueCount? db, MisskeyQueueCount? objectStorage, MisskeyQueueCount? userWebhookDeliver, MisskeyQueueCount? systemWebhookDeliver
});




}
/// @nodoc
class _$MisskeyQueueStatsCopyWithImpl<$Res>
    implements $MisskeyQueueStatsCopyWith<$Res> {
  _$MisskeyQueueStatsCopyWithImpl(this._self, this._then);

  final MisskeyQueueStats _self;
  final $Res Function(MisskeyQueueStats) _then;

/// Create a copy of MisskeyQueueStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deliver = freezed,Object? inbox = freezed,Object? db = freezed,Object? objectStorage = freezed,Object? userWebhookDeliver = freezed,Object? systemWebhookDeliver = freezed,}) {
  return _then(MisskeyQueueStats(
deliver: freezed == deliver ? _self.deliver : deliver // ignore: cast_nullable_to_non_nullable
as MisskeyQueueCount?,inbox: freezed == inbox ? _self.inbox : inbox // ignore: cast_nullable_to_non_nullable
as MisskeyQueueCount?,db: freezed == db ? _self.db : db // ignore: cast_nullable_to_non_nullable
as MisskeyQueueCount?,objectStorage: freezed == objectStorage ? _self.objectStorage : objectStorage // ignore: cast_nullable_to_non_nullable
as MisskeyQueueCount?,userWebhookDeliver: freezed == userWebhookDeliver ? _self.userWebhookDeliver : userWebhookDeliver // ignore: cast_nullable_to_non_nullable
as MisskeyQueueCount?,systemWebhookDeliver: freezed == systemWebhookDeliver ? _self.systemWebhookDeliver : systemWebhookDeliver // ignore: cast_nullable_to_non_nullable
as MisskeyQueueCount?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyQueueStats].
extension MisskeyQueueStatsPatterns on MisskeyQueueStats {
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
mixin _$MisskeyQueueMetrics {

 Map<String, dynamic>? get meta; List<num>? get data; num? get count;
/// Create a copy of MisskeyQueueMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyQueueMetricsCopyWith<MisskeyQueueMetrics> get copyWith => _$MisskeyQueueMetricsCopyWithImpl<MisskeyQueueMetrics>(this as MisskeyQueueMetrics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyQueueMetrics&&const DeepCollectionEquality().equals(other.meta, meta)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(meta),const DeepCollectionEquality().hash(data),count);

@override
String toString() {
  return 'MisskeyQueueMetrics(meta: $meta, data: $data, count: $count)';
}


}

/// @nodoc
abstract mixin class $MisskeyQueueMetricsCopyWith<$Res>  {
  factory $MisskeyQueueMetricsCopyWith(MisskeyQueueMetrics value, $Res Function(MisskeyQueueMetrics) _then) = _$MisskeyQueueMetricsCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic>? meta, List<num>? data, num? count
});




}
/// @nodoc
class _$MisskeyQueueMetricsCopyWithImpl<$Res>
    implements $MisskeyQueueMetricsCopyWith<$Res> {
  _$MisskeyQueueMetricsCopyWithImpl(this._self, this._then);

  final MisskeyQueueMetrics _self;
  final $Res Function(MisskeyQueueMetrics) _then;

/// Create a copy of MisskeyQueueMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meta = freezed,Object? data = freezed,Object? count = freezed,}) {
  return _then(MisskeyQueueMetrics(
meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<num>?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyQueueMetrics].
extension MisskeyQueueMetricsPatterns on MisskeyQueueMetrics {
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
mixin _$MisskeyQueueInfo {

 String get name; String? get qualifiedName; MisskeyQueueCount? get counts; bool? get isPaused; MisskeyQueueMetrics? get completedMetrics; MisskeyQueueMetrics? get failedMetrics; Map<String, dynamic>? get db;
/// Create a copy of MisskeyQueueInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyQueueInfoCopyWith<MisskeyQueueInfo> get copyWith => _$MisskeyQueueInfoCopyWithImpl<MisskeyQueueInfo>(this as MisskeyQueueInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyQueueInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.qualifiedName, qualifiedName) || other.qualifiedName == qualifiedName)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.completedMetrics, completedMetrics) || other.completedMetrics == completedMetrics)&&(identical(other.failedMetrics, failedMetrics) || other.failedMetrics == failedMetrics)&&const DeepCollectionEquality().equals(other.db, db));
}


@override
int get hashCode => Object.hash(runtimeType,name,qualifiedName,counts,isPaused,completedMetrics,failedMetrics,const DeepCollectionEquality().hash(db));

@override
String toString() {
  return 'MisskeyQueueInfo(name: $name, qualifiedName: $qualifiedName, counts: $counts, isPaused: $isPaused, completedMetrics: $completedMetrics, failedMetrics: $failedMetrics, db: $db)';
}


}

/// @nodoc
abstract mixin class $MisskeyQueueInfoCopyWith<$Res>  {
  factory $MisskeyQueueInfoCopyWith(MisskeyQueueInfo value, $Res Function(MisskeyQueueInfo) _then) = _$MisskeyQueueInfoCopyWithImpl;
@useResult
$Res call({
 String name, String? qualifiedName, MisskeyQueueCount? counts, bool? isPaused, MisskeyQueueMetrics? completedMetrics, MisskeyQueueMetrics? failedMetrics, Map<String, dynamic>? db
});




}
/// @nodoc
class _$MisskeyQueueInfoCopyWithImpl<$Res>
    implements $MisskeyQueueInfoCopyWith<$Res> {
  _$MisskeyQueueInfoCopyWithImpl(this._self, this._then);

  final MisskeyQueueInfo _self;
  final $Res Function(MisskeyQueueInfo) _then;

/// Create a copy of MisskeyQueueInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? qualifiedName = freezed,Object? counts = freezed,Object? isPaused = freezed,Object? completedMetrics = freezed,Object? failedMetrics = freezed,Object? db = freezed,}) {
  return _then(MisskeyQueueInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,qualifiedName: freezed == qualifiedName ? _self.qualifiedName : qualifiedName // ignore: cast_nullable_to_non_nullable
as String?,counts: freezed == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as MisskeyQueueCount?,isPaused: freezed == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool?,completedMetrics: freezed == completedMetrics ? _self.completedMetrics : completedMetrics // ignore: cast_nullable_to_non_nullable
as MisskeyQueueMetrics?,failedMetrics: freezed == failedMetrics ? _self.failedMetrics : failedMetrics // ignore: cast_nullable_to_non_nullable
as MisskeyQueueMetrics?,db: freezed == db ? _self.db : db // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyQueueInfo].
extension MisskeyQueueInfoPatterns on MisskeyQueueInfo {
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
mixin _$MisskeyQueueJob {

 String get id; String get name; Map<String, dynamic>? get data; Map<String, dynamic>? get opts; num? get timestamp; num? get processedOn; String? get processedBy; num? get finishedOn; dynamic get progress; num? get attempts; num? get delay; String? get failedReason; List<String>? get stacktrace; dynamic get returnValue; bool? get isFailed;
/// Create a copy of MisskeyQueueJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyQueueJobCopyWith<MisskeyQueueJob> get copyWith => _$MisskeyQueueJobCopyWithImpl<MisskeyQueueJob>(this as MisskeyQueueJob, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyQueueJob&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.opts, opts)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.processedOn, processedOn) || other.processedOn == processedOn)&&(identical(other.processedBy, processedBy) || other.processedBy == processedBy)&&(identical(other.finishedOn, finishedOn) || other.finishedOn == finishedOn)&&const DeepCollectionEquality().equals(other.progress, progress)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.delay, delay) || other.delay == delay)&&(identical(other.failedReason, failedReason) || other.failedReason == failedReason)&&const DeepCollectionEquality().equals(other.stacktrace, stacktrace)&&const DeepCollectionEquality().equals(other.returnValue, returnValue)&&(identical(other.isFailed, isFailed) || other.isFailed == isFailed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(opts),timestamp,processedOn,processedBy,finishedOn,const DeepCollectionEquality().hash(progress),attempts,delay,failedReason,const DeepCollectionEquality().hash(stacktrace),const DeepCollectionEquality().hash(returnValue),isFailed);

@override
String toString() {
  return 'MisskeyQueueJob(id: $id, name: $name, data: $data, opts: $opts, timestamp: $timestamp, processedOn: $processedOn, processedBy: $processedBy, finishedOn: $finishedOn, progress: $progress, attempts: $attempts, delay: $delay, failedReason: $failedReason, stacktrace: $stacktrace, returnValue: $returnValue, isFailed: $isFailed)';
}


}

/// @nodoc
abstract mixin class $MisskeyQueueJobCopyWith<$Res>  {
  factory $MisskeyQueueJobCopyWith(MisskeyQueueJob value, $Res Function(MisskeyQueueJob) _then) = _$MisskeyQueueJobCopyWithImpl;
@useResult
$Res call({
 String id, String name, Map<String, dynamic>? data, Map<String, dynamic>? opts, num? timestamp, num? processedOn, String? processedBy, num? finishedOn, dynamic progress, num? attempts, num? delay, String? failedReason, List<String>? stacktrace, dynamic returnValue, bool? isFailed
});




}
/// @nodoc
class _$MisskeyQueueJobCopyWithImpl<$Res>
    implements $MisskeyQueueJobCopyWith<$Res> {
  _$MisskeyQueueJobCopyWithImpl(this._self, this._then);

  final MisskeyQueueJob _self;
  final $Res Function(MisskeyQueueJob) _then;

/// Create a copy of MisskeyQueueJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? data = freezed,Object? opts = freezed,Object? timestamp = freezed,Object? processedOn = freezed,Object? processedBy = freezed,Object? finishedOn = freezed,Object? progress = freezed,Object? attempts = freezed,Object? delay = freezed,Object? failedReason = freezed,Object? stacktrace = freezed,Object? returnValue = freezed,Object? isFailed = freezed,}) {
  return _then(MisskeyQueueJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,opts: freezed == opts ? _self.opts : opts // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as num?,processedOn: freezed == processedOn ? _self.processedOn : processedOn // ignore: cast_nullable_to_non_nullable
as num?,processedBy: freezed == processedBy ? _self.processedBy : processedBy // ignore: cast_nullable_to_non_nullable
as String?,finishedOn: freezed == finishedOn ? _self.finishedOn : finishedOn // ignore: cast_nullable_to_non_nullable
as num?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as dynamic,attempts: freezed == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as num?,delay: freezed == delay ? _self.delay : delay // ignore: cast_nullable_to_non_nullable
as num?,failedReason: freezed == failedReason ? _self.failedReason : failedReason // ignore: cast_nullable_to_non_nullable
as String?,stacktrace: freezed == stacktrace ? _self.stacktrace : stacktrace // ignore: cast_nullable_to_non_nullable
as List<String>?,returnValue: freezed == returnValue ? _self.returnValue : returnValue // ignore: cast_nullable_to_non_nullable
as dynamic,isFailed: freezed == isFailed ? _self.isFailed : isFailed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyQueueJob].
extension MisskeyQueueJobPatterns on MisskeyQueueJob {
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
