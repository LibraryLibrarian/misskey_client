// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_admin_announcement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyAdminAnnouncement {

 String get id; DateTime? get createdAt; DateTime? get updatedAt; String get title; String get text; String? get imageUrl; String? get icon; String? get display; bool? get isActive; bool? get forExistingUsers; bool? get silence; bool? get needConfirmationToRead; String? get userId; int? get reads;
/// Create a copy of MisskeyAdminAnnouncement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyAdminAnnouncementCopyWith<MisskeyAdminAnnouncement> get copyWith => _$MisskeyAdminAnnouncementCopyWithImpl<MisskeyAdminAnnouncement>(this as MisskeyAdminAnnouncement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyAdminAnnouncement&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.display, display) || other.display == display)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.forExistingUsers, forExistingUsers) || other.forExistingUsers == forExistingUsers)&&(identical(other.silence, silence) || other.silence == silence)&&(identical(other.needConfirmationToRead, needConfirmationToRead) || other.needConfirmationToRead == needConfirmationToRead)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.reads, reads) || other.reads == reads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,updatedAt,title,text,imageUrl,icon,display,isActive,forExistingUsers,silence,needConfirmationToRead,userId,reads);

@override
String toString() {
  return 'MisskeyAdminAnnouncement(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, text: $text, imageUrl: $imageUrl, icon: $icon, display: $display, isActive: $isActive, forExistingUsers: $forExistingUsers, silence: $silence, needConfirmationToRead: $needConfirmationToRead, userId: $userId, reads: $reads)';
}


}

/// @nodoc
abstract mixin class $MisskeyAdminAnnouncementCopyWith<$Res>  {
  factory $MisskeyAdminAnnouncementCopyWith(MisskeyAdminAnnouncement value, $Res Function(MisskeyAdminAnnouncement) _then) = _$MisskeyAdminAnnouncementCopyWithImpl;
@useResult
$Res call({
 String id, DateTime? createdAt, DateTime? updatedAt, String title, String text, String? imageUrl, String? icon, String? display, bool? isActive, bool? forExistingUsers, bool? silence, bool? needConfirmationToRead, String? userId, int? reads
});




}
/// @nodoc
class _$MisskeyAdminAnnouncementCopyWithImpl<$Res>
    implements $MisskeyAdminAnnouncementCopyWith<$Res> {
  _$MisskeyAdminAnnouncementCopyWithImpl(this._self, this._then);

  final MisskeyAdminAnnouncement _self;
  final $Res Function(MisskeyAdminAnnouncement) _then;

/// Create a copy of MisskeyAdminAnnouncement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? title = null,Object? text = null,Object? imageUrl = freezed,Object? icon = freezed,Object? display = freezed,Object? isActive = freezed,Object? forExistingUsers = freezed,Object? silence = freezed,Object? needConfirmationToRead = freezed,Object? userId = freezed,Object? reads = freezed,}) {
  return _then(MisskeyAdminAnnouncement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,display: freezed == display ? _self.display : display // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,forExistingUsers: freezed == forExistingUsers ? _self.forExistingUsers : forExistingUsers // ignore: cast_nullable_to_non_nullable
as bool?,silence: freezed == silence ? _self.silence : silence // ignore: cast_nullable_to_non_nullable
as bool?,needConfirmationToRead: freezed == needConfirmationToRead ? _self.needConfirmationToRead : needConfirmationToRead // ignore: cast_nullable_to_non_nullable
as bool?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,reads: freezed == reads ? _self.reads : reads // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyAdminAnnouncement].
extension MisskeyAdminAnnouncementPatterns on MisskeyAdminAnnouncement {
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
