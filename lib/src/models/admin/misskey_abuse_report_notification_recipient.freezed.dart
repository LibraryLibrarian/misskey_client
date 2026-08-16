// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_abuse_report_notification_recipient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyAbuseReportNotificationRecipient {

 String get id; bool get isActive; DateTime? get updatedAt; String get name; String get method; String? get userId; MisskeyUser? get user; String? get systemWebhookId; Map<String, dynamic>? get systemWebhook;
/// Create a copy of MisskeyAbuseReportNotificationRecipient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAbuseReportNotificationRecipientCopyWith<MisskeyAbuseReportNotificationRecipient> get copyWith => _$MisskeyAbuseReportNotificationRecipientCopyWithImpl<MisskeyAbuseReportNotificationRecipient>(this as MisskeyAbuseReportNotificationRecipient, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAbuseReportNotificationRecipient&&(identical(other.id, id) || other.id == id)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.method, method) || other.method == method)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.systemWebhookId, systemWebhookId) || other.systemWebhookId == systemWebhookId)&&const DeepCollectionEquality().equals(other.systemWebhook, systemWebhook));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isActive,updatedAt,name,method,userId,user,systemWebhookId,const DeepCollectionEquality().hash(systemWebhook));

@override
String toString() {
  return 'MisskeyAbuseReportNotificationRecipient(id: $id, isActive: $isActive, updatedAt: $updatedAt, name: $name, method: $method, userId: $userId, user: $user, systemWebhookId: $systemWebhookId, systemWebhook: $systemWebhook)';
}


}

/// @nodoc
abstract mixin class $MisskeyAbuseReportNotificationRecipientCopyWith<$Res>  {
  factory $MisskeyAbuseReportNotificationRecipientCopyWith(MisskeyAbuseReportNotificationRecipient value, $Res Function(MisskeyAbuseReportNotificationRecipient) _then) = _$MisskeyAbuseReportNotificationRecipientCopyWithImpl;
@useResult
$Res call({
 String id, bool isActive, DateTime? updatedAt, String name, String method, String? userId, MisskeyUser? user, String? systemWebhookId, Map<String, dynamic>? systemWebhook
});




}
/// @nodoc
class _$MisskeyAbuseReportNotificationRecipientCopyWithImpl<$Res>
    implements $MisskeyAbuseReportNotificationRecipientCopyWith<$Res> {
  _$MisskeyAbuseReportNotificationRecipientCopyWithImpl(this._self, this._then);

  final MisskeyAbuseReportNotificationRecipient _self;
  final $Res Function(MisskeyAbuseReportNotificationRecipient) _then;

/// Create a copy of MisskeyAbuseReportNotificationRecipient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isActive = null,Object? updatedAt = freezed,Object? name = null,Object? method = null,Object? userId = freezed,Object? user = freezed,Object? systemWebhookId = freezed,Object? systemWebhook = freezed,}) {
  return _then(MisskeyAbuseReportNotificationRecipient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,systemWebhookId: freezed == systemWebhookId ? _self.systemWebhookId : systemWebhookId // ignore: cast_nullable_to_non_nullable
as String?,systemWebhook: freezed == systemWebhook ? _self.systemWebhook : systemWebhook // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAbuseReportNotificationRecipient].
extension MisskeyAbuseReportNotificationRecipientPatterns on MisskeyAbuseReportNotificationRecipient {
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
