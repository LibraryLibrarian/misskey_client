// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_abuse_user_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyAbuseUserReport {

 String get id; DateTime? get createdAt; String get comment; bool get resolved; String? get reporterId; String? get targetUserId; String? get assigneeId; MisskeyUser? get reporter; MisskeyUser? get targetUser; MisskeyUser? get assignee; bool? get forwarded; String? get resolvedAs; String? get moderationNote;
/// Create a copy of MisskeyAbuseUserReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAbuseUserReportCopyWith<MisskeyAbuseUserReport> get copyWith => _$MisskeyAbuseUserReportCopyWithImpl<MisskeyAbuseUserReport>(this as MisskeyAbuseUserReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAbuseUserReport&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.resolved, resolved) || other.resolved == resolved)&&(identical(other.reporterId, reporterId) || other.reporterId == reporterId)&&(identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.reporter, reporter) || other.reporter == reporter)&&(identical(other.targetUser, targetUser) || other.targetUser == targetUser)&&(identical(other.assignee, assignee) || other.assignee == assignee)&&(identical(other.forwarded, forwarded) || other.forwarded == forwarded)&&(identical(other.resolvedAs, resolvedAs) || other.resolvedAs == resolvedAs)&&(identical(other.moderationNote, moderationNote) || other.moderationNote == moderationNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,comment,resolved,reporterId,targetUserId,assigneeId,reporter,targetUser,assignee,forwarded,resolvedAs,moderationNote);

@override
String toString() {
  return 'MisskeyAbuseUserReport(id: $id, createdAt: $createdAt, comment: $comment, resolved: $resolved, reporterId: $reporterId, targetUserId: $targetUserId, assigneeId: $assigneeId, reporter: $reporter, targetUser: $targetUser, assignee: $assignee, forwarded: $forwarded, resolvedAs: $resolvedAs, moderationNote: $moderationNote)';
}


}

/// @nodoc
abstract mixin class $MisskeyAbuseUserReportCopyWith<$Res>  {
  factory $MisskeyAbuseUserReportCopyWith(MisskeyAbuseUserReport value, $Res Function(MisskeyAbuseUserReport) _then) = _$MisskeyAbuseUserReportCopyWithImpl;
@useResult
$Res call({
 String id, DateTime? createdAt, String comment, bool resolved, String? reporterId, String? targetUserId, String? assigneeId, MisskeyUser? reporter, MisskeyUser? targetUser, MisskeyUser? assignee, bool? forwarded, String? resolvedAs, String? moderationNote
});




}
/// @nodoc
class _$MisskeyAbuseUserReportCopyWithImpl<$Res>
    implements $MisskeyAbuseUserReportCopyWith<$Res> {
  _$MisskeyAbuseUserReportCopyWithImpl(this._self, this._then);

  final MisskeyAbuseUserReport _self;
  final $Res Function(MisskeyAbuseUserReport) _then;

/// Create a copy of MisskeyAbuseUserReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = freezed,Object? comment = null,Object? resolved = null,Object? reporterId = freezed,Object? targetUserId = freezed,Object? assigneeId = freezed,Object? reporter = freezed,Object? targetUser = freezed,Object? assignee = freezed,Object? forwarded = freezed,Object? resolvedAs = freezed,Object? moderationNote = freezed,}) {
  return _then(MisskeyAbuseUserReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as bool,reporterId: freezed == reporterId ? _self.reporterId : reporterId // ignore: cast_nullable_to_non_nullable
as String?,targetUserId: freezed == targetUserId ? _self.targetUserId : targetUserId // ignore: cast_nullable_to_non_nullable
as String?,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,reporter: freezed == reporter ? _self.reporter : reporter // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,targetUser: freezed == targetUser ? _self.targetUser : targetUser // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,assignee: freezed == assignee ? _self.assignee : assignee // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,forwarded: freezed == forwarded ? _self.forwarded : forwarded // ignore: cast_nullable_to_non_nullable
as bool?,resolvedAs: freezed == resolvedAs ? _self.resolvedAs : resolvedAs // ignore: cast_nullable_to_non_nullable
as String?,moderationNote: freezed == moderationNote ? _self.moderationNote : moderationNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAbuseUserReport].
extension MisskeyAbuseUserReportPatterns on MisskeyAbuseUserReport {
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
