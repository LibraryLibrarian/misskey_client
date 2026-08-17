// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyPage {

 String get id; DateTime? get createdAt; DateTime? get updatedAt; String get userId; MisskeyUser? get user; String get title; String get name; String? get summary; List<dynamic>? get content; List<dynamic>? get variables; bool get alignCenter; bool get hideTitleWhenPinned; String? get font; String? get script; String? get eyeCatchingImageId; MisskeyDriveFile? get eyeCatchingImage; List<MisskeyDriveFile> get attachedFiles; int get likedCount; bool? get isLiked;
/// Create a copy of MisskeyPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyPageCopyWith<MisskeyPage> get copyWith => _$MisskeyPageCopyWithImpl<MisskeyPage>(this as MisskeyPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyPage&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.title, title) || other.title == title)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.alignCenter, alignCenter) || other.alignCenter == alignCenter)&&(identical(other.hideTitleWhenPinned, hideTitleWhenPinned) || other.hideTitleWhenPinned == hideTitleWhenPinned)&&(identical(other.font, font) || other.font == font)&&(identical(other.script, script) || other.script == script)&&(identical(other.eyeCatchingImageId, eyeCatchingImageId) || other.eyeCatchingImageId == eyeCatchingImageId)&&(identical(other.eyeCatchingImage, eyeCatchingImage) || other.eyeCatchingImage == eyeCatchingImage)&&const DeepCollectionEquality().equals(other.attachedFiles, attachedFiles)&&(identical(other.likedCount, likedCount) || other.likedCount == likedCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,createdAt,updatedAt,userId,user,title,name,summary,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(variables),alignCenter,hideTitleWhenPinned,font,script,eyeCatchingImageId,eyeCatchingImage,const DeepCollectionEquality().hash(attachedFiles),likedCount,isLiked]);

@override
String toString() {
  return 'MisskeyPage(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, user: $user, title: $title, name: $name, summary: $summary, content: $content, variables: $variables, alignCenter: $alignCenter, hideTitleWhenPinned: $hideTitleWhenPinned, font: $font, script: $script, eyeCatchingImageId: $eyeCatchingImageId, eyeCatchingImage: $eyeCatchingImage, attachedFiles: $attachedFiles, likedCount: $likedCount, isLiked: $isLiked)';
}


}

/// @nodoc
abstract mixin class $MisskeyPageCopyWith<$Res>  {
  factory $MisskeyPageCopyWith(MisskeyPage value, $Res Function(MisskeyPage) _then) = _$MisskeyPageCopyWithImpl;
@useResult
$Res call({
 String id, DateTime? createdAt, DateTime? updatedAt, String userId, String title, String name, MisskeyUser? user, String? summary, List<dynamic>? content, List<dynamic>? variables, bool alignCenter, bool hideTitleWhenPinned, String? font, String? script, String? eyeCatchingImageId, MisskeyDriveFile? eyeCatchingImage, List<MisskeyDriveFile> attachedFiles, int likedCount, bool? isLiked
});




}
/// @nodoc
class _$MisskeyPageCopyWithImpl<$Res>
    implements $MisskeyPageCopyWith<$Res> {
  _$MisskeyPageCopyWithImpl(this._self, this._then);

  final MisskeyPage _self;
  final $Res Function(MisskeyPage) _then;

/// Create a copy of MisskeyPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? title = null,Object? name = null,Object? user = freezed,Object? summary = freezed,Object? content = freezed,Object? variables = freezed,Object? alignCenter = null,Object? hideTitleWhenPinned = null,Object? font = freezed,Object? script = freezed,Object? eyeCatchingImageId = freezed,Object? eyeCatchingImage = freezed,Object? attachedFiles = null,Object? likedCount = null,Object? isLiked = freezed,}) {
  return _then(MisskeyPage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,variables: freezed == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,alignCenter: null == alignCenter ? _self.alignCenter : alignCenter // ignore: cast_nullable_to_non_nullable
as bool,hideTitleWhenPinned: null == hideTitleWhenPinned ? _self.hideTitleWhenPinned : hideTitleWhenPinned // ignore: cast_nullable_to_non_nullable
as bool,font: freezed == font ? _self.font : font // ignore: cast_nullable_to_non_nullable
as String?,script: freezed == script ? _self.script : script // ignore: cast_nullable_to_non_nullable
as String?,eyeCatchingImageId: freezed == eyeCatchingImageId ? _self.eyeCatchingImageId : eyeCatchingImageId // ignore: cast_nullable_to_non_nullable
as String?,eyeCatchingImage: freezed == eyeCatchingImage ? _self.eyeCatchingImage : eyeCatchingImage // ignore: cast_nullable_to_non_nullable
as MisskeyDriveFile?,attachedFiles: null == attachedFiles ? _self.attachedFiles : attachedFiles // ignore: cast_nullable_to_non_nullable
as List<MisskeyDriveFile>,likedCount: null == likedCount ? _self.likedCount : likedCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: freezed == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyPage].
extension MisskeyPagePatterns on MisskeyPage {
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
