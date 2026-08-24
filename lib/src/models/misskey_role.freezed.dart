// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyRole {

 String get id; DateTime get createdAt; DateTime get updatedAt; String get name; String get description; String? get color; String? get iconUrl; String get target; bool get isPublic; bool get isExplorable; bool get asBadge; bool get canEditMembersByModerator; int get displayOrder; int get usersCount; bool? get isAdministrator; bool? get isModerator; Map<String, dynamic>? get policies; Map<String, dynamic>? get condFormula; bool? get preserveAssignmentOnMoveAccount;
/// Create a copy of MisskeyRole
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyRoleCopyWith<MisskeyRole> get copyWith => _$MisskeyRoleCopyWithImpl<MisskeyRole>(this as MisskeyRole, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyRole&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.color, color) || other.color == color)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.target, target) || other.target == target)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isExplorable, isExplorable) || other.isExplorable == isExplorable)&&(identical(other.asBadge, asBadge) || other.asBadge == asBadge)&&(identical(other.canEditMembersByModerator, canEditMembersByModerator) || other.canEditMembersByModerator == canEditMembersByModerator)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.usersCount, usersCount) || other.usersCount == usersCount)&&(identical(other.isAdministrator, isAdministrator) || other.isAdministrator == isAdministrator)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator)&&const DeepCollectionEquality().equals(other.policies, policies)&&const DeepCollectionEquality().equals(other.condFormula, condFormula)&&(identical(other.preserveAssignmentOnMoveAccount, preserveAssignmentOnMoveAccount) || other.preserveAssignmentOnMoveAccount == preserveAssignmentOnMoveAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,createdAt,updatedAt,name,description,color,iconUrl,target,isPublic,isExplorable,asBadge,canEditMembersByModerator,displayOrder,usersCount,isAdministrator,isModerator,const DeepCollectionEquality().hash(policies),const DeepCollectionEquality().hash(condFormula),preserveAssignmentOnMoveAccount]);

@override
String toString() {
  return 'MisskeyRole(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, description: $description, color: $color, iconUrl: $iconUrl, target: $target, isPublic: $isPublic, isExplorable: $isExplorable, asBadge: $asBadge, canEditMembersByModerator: $canEditMembersByModerator, displayOrder: $displayOrder, usersCount: $usersCount, isAdministrator: $isAdministrator, isModerator: $isModerator, policies: $policies, condFormula: $condFormula, preserveAssignmentOnMoveAccount: $preserveAssignmentOnMoveAccount)';
}


}

/// @nodoc
abstract mixin class $MisskeyRoleCopyWith<$Res>  {
  factory $MisskeyRoleCopyWith(MisskeyRole value, $Res Function(MisskeyRole) _then) = _$MisskeyRoleCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String name, String description, String? color, String? iconUrl, String target, bool isPublic, bool isExplorable, bool asBadge, bool canEditMembersByModerator, int displayOrder, int usersCount, bool? isAdministrator, bool? isModerator, Map<String, dynamic>? policies, Map<String, dynamic>? condFormula, bool? preserveAssignmentOnMoveAccount
});




}
/// @nodoc
class _$MisskeyRoleCopyWithImpl<$Res>
    implements $MisskeyRoleCopyWith<$Res> {
  _$MisskeyRoleCopyWithImpl(this._self, this._then);

  final MisskeyRole _self;
  final $Res Function(MisskeyRole) _then;

/// Create a copy of MisskeyRole
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? name = null,Object? description = null,Object? color = freezed,Object? iconUrl = freezed,Object? target = null,Object? isPublic = null,Object? isExplorable = null,Object? asBadge = null,Object? canEditMembersByModerator = null,Object? displayOrder = null,Object? usersCount = null,Object? isAdministrator = freezed,Object? isModerator = freezed,Object? policies = freezed,Object? condFormula = freezed,Object? preserveAssignmentOnMoveAccount = freezed,}) {
  return _then(MisskeyRole(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isExplorable: null == isExplorable ? _self.isExplorable : isExplorable // ignore: cast_nullable_to_non_nullable
as bool,asBadge: null == asBadge ? _self.asBadge : asBadge // ignore: cast_nullable_to_non_nullable
as bool,canEditMembersByModerator: null == canEditMembersByModerator ? _self.canEditMembersByModerator : canEditMembersByModerator // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,usersCount: null == usersCount ? _self.usersCount : usersCount // ignore: cast_nullable_to_non_nullable
as int,isAdministrator: freezed == isAdministrator ? _self.isAdministrator : isAdministrator // ignore: cast_nullable_to_non_nullable
as bool?,isModerator: freezed == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool?,policies: freezed == policies ? _self.policies : policies // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,condFormula: freezed == condFormula ? _self.condFormula : condFormula // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,preserveAssignmentOnMoveAccount: freezed == preserveAssignmentOnMoveAccount ? _self.preserveAssignmentOnMoveAccount : preserveAssignmentOnMoveAccount // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyRole].
extension MisskeyRolePatterns on MisskeyRole {
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
