// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyNotification {

 String get id; DateTime get createdAt; MisskeyNotificationType get type; String? get userId; MisskeyUser? get user; MisskeyNote? get note; String? get reaction; String? get achievement; String? get body; String? get header; String? get icon; dynamic get role; String? get message; List<dynamic>? get reactions; List<MisskeyUser>? get users;
/// Create a copy of MisskeyNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyNotificationCopyWith<MisskeyNotification> get copyWith => _$MisskeyNotificationCopyWithImpl<MisskeyNotification>(this as MisskeyNotification, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.type, type) || other.type == type)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.note, note) || other.note == note)&&(identical(other.reaction, reaction) || other.reaction == reaction)&&(identical(other.achievement, achievement) || other.achievement == achievement)&&(identical(other.body, body) || other.body == body)&&(identical(other.header, header) || other.header == header)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.role, role)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&const DeepCollectionEquality().equals(other.users, users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,type,userId,user,note,reaction,achievement,body,header,icon,const DeepCollectionEquality().hash(role),message,const DeepCollectionEquality().hash(reactions),const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'MisskeyNotification(id: $id, createdAt: $createdAt, type: $type, userId: $userId, user: $user, note: $note, reaction: $reaction, achievement: $achievement, body: $body, header: $header, icon: $icon, role: $role, message: $message, reactions: $reactions, users: $users)';
}


}

/// @nodoc
abstract mixin class $MisskeyNotificationCopyWith<$Res>  {
  factory $MisskeyNotificationCopyWith(MisskeyNotification value, $Res Function(MisskeyNotification) _then) = _$MisskeyNotificationCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, MisskeyNotificationType type, String? userId, MisskeyUser? user, MisskeyNote? note, String? reaction, String? achievement, String? body, String? header, String? icon, dynamic role, String? message, List<dynamic>? reactions, List<MisskeyUser>? users
});




}
/// @nodoc
class _$MisskeyNotificationCopyWithImpl<$Res>
    implements $MisskeyNotificationCopyWith<$Res> {
  _$MisskeyNotificationCopyWithImpl(this._self, this._then);

  final MisskeyNotification _self;
  final $Res Function(MisskeyNotification) _then;

/// Create a copy of MisskeyNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? type = null,Object? userId = freezed,Object? user = freezed,Object? note = freezed,Object? reaction = freezed,Object? achievement = freezed,Object? body = freezed,Object? header = freezed,Object? icon = freezed,Object? role = freezed,Object? message = freezed,Object? reactions = freezed,Object? users = freezed,}) {
  return _then(MisskeyNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MisskeyNotificationType,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as MisskeyNote?,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String?,achievement: freezed == achievement ? _self.achievement : achievement // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,header: freezed == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as dynamic,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,reactions: freezed == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,users: freezed == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<MisskeyUser>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyNotification].
extension MisskeyNotificationPatterns on MisskeyNotification {
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
