// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_admin_user_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyAdminUserDetail {

 String? get email; bool? get emailVerified; String? get followedMessage; bool? get autoAcceptFollowed; bool? get noCrawle; bool? get preventAiLearning; bool? get alwaysMarkNsfw; bool? get autoSensitive; bool? get carefulBot; bool? get injectFeaturedNote; bool? get receiveAnnouncementEmail; List<MutedWord>? get mutedWords; List<String>? get mutedInstances; Map<String, dynamic>? get notificationRecieveConfig; bool? get isModerator; bool? get isSilenced; bool? get isSuspended; bool? get isHibernated; DateTime? get lastActiveDate; String? get moderationNote; List<MisskeySignin>? get signins; Map<String, dynamic>? get policies; List<MisskeyRole>? get roles; List<MisskeyRoleAssign>? get roleAssigns;
/// Create a copy of MisskeyAdminUserDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAdminUserDetailCopyWith<MisskeyAdminUserDetail> get copyWith => _$MisskeyAdminUserDetailCopyWithImpl<MisskeyAdminUserDetail>(this as MisskeyAdminUserDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAdminUserDetail&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.followedMessage, followedMessage) || other.followedMessage == followedMessage)&&(identical(other.autoAcceptFollowed, autoAcceptFollowed) || other.autoAcceptFollowed == autoAcceptFollowed)&&(identical(other.noCrawle, noCrawle) || other.noCrawle == noCrawle)&&(identical(other.preventAiLearning, preventAiLearning) || other.preventAiLearning == preventAiLearning)&&(identical(other.alwaysMarkNsfw, alwaysMarkNsfw) || other.alwaysMarkNsfw == alwaysMarkNsfw)&&(identical(other.autoSensitive, autoSensitive) || other.autoSensitive == autoSensitive)&&(identical(other.carefulBot, carefulBot) || other.carefulBot == carefulBot)&&(identical(other.injectFeaturedNote, injectFeaturedNote) || other.injectFeaturedNote == injectFeaturedNote)&&(identical(other.receiveAnnouncementEmail, receiveAnnouncementEmail) || other.receiveAnnouncementEmail == receiveAnnouncementEmail)&&const DeepCollectionEquality().equals(other.mutedWords, mutedWords)&&const DeepCollectionEquality().equals(other.mutedInstances, mutedInstances)&&const DeepCollectionEquality().equals(other.notificationRecieveConfig, notificationRecieveConfig)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator)&&(identical(other.isSilenced, isSilenced) || other.isSilenced == isSilenced)&&(identical(other.isSuspended, isSuspended) || other.isSuspended == isSuspended)&&(identical(other.isHibernated, isHibernated) || other.isHibernated == isHibernated)&&(identical(other.lastActiveDate, lastActiveDate) || other.lastActiveDate == lastActiveDate)&&(identical(other.moderationNote, moderationNote) || other.moderationNote == moderationNote)&&const DeepCollectionEquality().equals(other.signins, signins)&&const DeepCollectionEquality().equals(other.policies, policies)&&const DeepCollectionEquality().equals(other.roles, roles)&&const DeepCollectionEquality().equals(other.roleAssigns, roleAssigns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,email,emailVerified,followedMessage,autoAcceptFollowed,noCrawle,preventAiLearning,alwaysMarkNsfw,autoSensitive,carefulBot,injectFeaturedNote,receiveAnnouncementEmail,const DeepCollectionEquality().hash(mutedWords),const DeepCollectionEquality().hash(mutedInstances),const DeepCollectionEquality().hash(notificationRecieveConfig),isModerator,isSilenced,isSuspended,isHibernated,lastActiveDate,moderationNote,const DeepCollectionEquality().hash(signins),const DeepCollectionEquality().hash(policies),const DeepCollectionEquality().hash(roles),const DeepCollectionEquality().hash(roleAssigns)]);

@override
String toString() {
  return 'MisskeyAdminUserDetail(email: $email, emailVerified: $emailVerified, followedMessage: $followedMessage, autoAcceptFollowed: $autoAcceptFollowed, noCrawle: $noCrawle, preventAiLearning: $preventAiLearning, alwaysMarkNsfw: $alwaysMarkNsfw, autoSensitive: $autoSensitive, carefulBot: $carefulBot, injectFeaturedNote: $injectFeaturedNote, receiveAnnouncementEmail: $receiveAnnouncementEmail, mutedWords: $mutedWords, mutedInstances: $mutedInstances, notificationRecieveConfig: $notificationRecieveConfig, isModerator: $isModerator, isSilenced: $isSilenced, isSuspended: $isSuspended, isHibernated: $isHibernated, lastActiveDate: $lastActiveDate, moderationNote: $moderationNote, signins: $signins, policies: $policies, roles: $roles, roleAssigns: $roleAssigns)';
}


}

/// @nodoc
abstract mixin class $MisskeyAdminUserDetailCopyWith<$Res>  {
  factory $MisskeyAdminUserDetailCopyWith(MisskeyAdminUserDetail value, $Res Function(MisskeyAdminUserDetail) _then) = _$MisskeyAdminUserDetailCopyWithImpl;
@useResult
$Res call({
 String? email, bool? emailVerified, String? followedMessage, bool? autoAcceptFollowed, bool? noCrawle, bool? preventAiLearning, bool? alwaysMarkNsfw, bool? autoSensitive, bool? carefulBot, bool? injectFeaturedNote, bool? receiveAnnouncementEmail, List<MutedWord>? mutedWords, List<String>? mutedInstances, Map<String, dynamic>? notificationRecieveConfig, bool? isModerator, bool? isSilenced, bool? isSuspended, bool? isHibernated, DateTime? lastActiveDate, String? moderationNote, List<MisskeySignin>? signins, Map<String, dynamic>? policies, List<MisskeyRole>? roles, List<MisskeyRoleAssign>? roleAssigns
});




}
/// @nodoc
class _$MisskeyAdminUserDetailCopyWithImpl<$Res>
    implements $MisskeyAdminUserDetailCopyWith<$Res> {
  _$MisskeyAdminUserDetailCopyWithImpl(this._self, this._then);

  final MisskeyAdminUserDetail _self;
  final $Res Function(MisskeyAdminUserDetail) _then;

/// Create a copy of MisskeyAdminUserDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? emailVerified = freezed,Object? followedMessage = freezed,Object? autoAcceptFollowed = freezed,Object? noCrawle = freezed,Object? preventAiLearning = freezed,Object? alwaysMarkNsfw = freezed,Object? autoSensitive = freezed,Object? carefulBot = freezed,Object? injectFeaturedNote = freezed,Object? receiveAnnouncementEmail = freezed,Object? mutedWords = freezed,Object? mutedInstances = freezed,Object? notificationRecieveConfig = freezed,Object? isModerator = freezed,Object? isSilenced = freezed,Object? isSuspended = freezed,Object? isHibernated = freezed,Object? lastActiveDate = freezed,Object? moderationNote = freezed,Object? signins = freezed,Object? policies = freezed,Object? roles = freezed,Object? roleAssigns = freezed,}) {
  return _then(MisskeyAdminUserDetail(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: freezed == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool?,followedMessage: freezed == followedMessage ? _self.followedMessage : followedMessage // ignore: cast_nullable_to_non_nullable
as String?,autoAcceptFollowed: freezed == autoAcceptFollowed ? _self.autoAcceptFollowed : autoAcceptFollowed // ignore: cast_nullable_to_non_nullable
as bool?,noCrawle: freezed == noCrawle ? _self.noCrawle : noCrawle // ignore: cast_nullable_to_non_nullable
as bool?,preventAiLearning: freezed == preventAiLearning ? _self.preventAiLearning : preventAiLearning // ignore: cast_nullable_to_non_nullable
as bool?,alwaysMarkNsfw: freezed == alwaysMarkNsfw ? _self.alwaysMarkNsfw : alwaysMarkNsfw // ignore: cast_nullable_to_non_nullable
as bool?,autoSensitive: freezed == autoSensitive ? _self.autoSensitive : autoSensitive // ignore: cast_nullable_to_non_nullable
as bool?,carefulBot: freezed == carefulBot ? _self.carefulBot : carefulBot // ignore: cast_nullable_to_non_nullable
as bool?,injectFeaturedNote: freezed == injectFeaturedNote ? _self.injectFeaturedNote : injectFeaturedNote // ignore: cast_nullable_to_non_nullable
as bool?,receiveAnnouncementEmail: freezed == receiveAnnouncementEmail ? _self.receiveAnnouncementEmail : receiveAnnouncementEmail // ignore: cast_nullable_to_non_nullable
as bool?,mutedWords: freezed == mutedWords ? _self.mutedWords : mutedWords // ignore: cast_nullable_to_non_nullable
as List<MutedWord>?,mutedInstances: freezed == mutedInstances ? _self.mutedInstances : mutedInstances // ignore: cast_nullable_to_non_nullable
as List<String>?,notificationRecieveConfig: freezed == notificationRecieveConfig ? _self.notificationRecieveConfig : notificationRecieveConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isModerator: freezed == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool?,isSilenced: freezed == isSilenced ? _self.isSilenced : isSilenced // ignore: cast_nullable_to_non_nullable
as bool?,isSuspended: freezed == isSuspended ? _self.isSuspended : isSuspended // ignore: cast_nullable_to_non_nullable
as bool?,isHibernated: freezed == isHibernated ? _self.isHibernated : isHibernated // ignore: cast_nullable_to_non_nullable
as bool?,lastActiveDate: freezed == lastActiveDate ? _self.lastActiveDate : lastActiveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,moderationNote: freezed == moderationNote ? _self.moderationNote : moderationNote // ignore: cast_nullable_to_non_nullable
as String?,signins: freezed == signins ? _self.signins : signins // ignore: cast_nullable_to_non_nullable
as List<MisskeySignin>?,policies: freezed == policies ? _self.policies : policies // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,roles: freezed == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<MisskeyRole>?,roleAssigns: freezed == roleAssigns ? _self.roleAssigns : roleAssigns // ignore: cast_nullable_to_non_nullable
as List<MisskeyRoleAssign>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAdminUserDetail].
extension MisskeyAdminUserDetailPatterns on MisskeyAdminUserDetail {
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
mixin _$MisskeySignin {

 String get id; String? get userId; DateTime? get createdAt; String? get ip; Map<String, dynamic>? get headers; bool? get success;
/// Create a copy of MisskeySignin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeySigninCopyWith<MisskeySignin> get copyWith => _$MisskeySigninCopyWithImpl<MisskeySignin>(this as MisskeySignin, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeySignin&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ip, ip) || other.ip == ip)&&const DeepCollectionEquality().equals(other.headers, headers)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,ip,const DeepCollectionEquality().hash(headers),success);

@override
String toString() {
  return 'MisskeySignin(id: $id, userId: $userId, createdAt: $createdAt, ip: $ip, headers: $headers, success: $success)';
}


}

/// @nodoc
abstract mixin class $MisskeySigninCopyWith<$Res>  {
  factory $MisskeySigninCopyWith(MisskeySignin value, $Res Function(MisskeySignin) _then) = _$MisskeySigninCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, DateTime? createdAt, String? ip, Map<String, dynamic>? headers, bool? success
});




}
/// @nodoc
class _$MisskeySigninCopyWithImpl<$Res>
    implements $MisskeySigninCopyWith<$Res> {
  _$MisskeySigninCopyWithImpl(this._self, this._then);

  final MisskeySignin _self;
  final $Res Function(MisskeySignin) _then;

/// Create a copy of MisskeySignin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? createdAt = freezed,Object? ip = freezed,Object? headers = freezed,Object? success = freezed,}) {
  return _then(MisskeySignin(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ip: freezed == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeySignin].
extension MisskeySigninPatterns on MisskeySignin {
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
mixin _$MisskeyRoleAssign {

 String get id; DateTime? get createdAt; DateTime? get expiresAt; String? get roleId;
/// Create a copy of MisskeyRoleAssign
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyRoleAssignCopyWith<MisskeyRoleAssign> get copyWith => _$MisskeyRoleAssignCopyWithImpl<MisskeyRoleAssign>(this as MisskeyRoleAssign, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyRoleAssign&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.roleId, roleId) || other.roleId == roleId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,expiresAt,roleId);

@override
String toString() {
  return 'MisskeyRoleAssign(id: $id, createdAt: $createdAt, expiresAt: $expiresAt, roleId: $roleId)';
}


}

/// @nodoc
abstract mixin class $MisskeyRoleAssignCopyWith<$Res>  {
  factory $MisskeyRoleAssignCopyWith(MisskeyRoleAssign value, $Res Function(MisskeyRoleAssign) _then) = _$MisskeyRoleAssignCopyWithImpl;
@useResult
$Res call({
 String id, DateTime? createdAt, DateTime? expiresAt, String? roleId
});




}
/// @nodoc
class _$MisskeyRoleAssignCopyWithImpl<$Res>
    implements $MisskeyRoleAssignCopyWith<$Res> {
  _$MisskeyRoleAssignCopyWithImpl(this._self, this._then);

  final MisskeyRoleAssign _self;
  final $Res Function(MisskeyRoleAssign) _then;

/// Create a copy of MisskeyRoleAssign
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = freezed,Object? expiresAt = freezed,Object? roleId = freezed,}) {
  return _then(MisskeyRoleAssign(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyRoleAssign].
extension MisskeyRoleAssignPatterns on MisskeyRoleAssign {
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
