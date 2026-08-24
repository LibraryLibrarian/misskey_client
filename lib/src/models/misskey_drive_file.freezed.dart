// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_drive_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyDriveFile {

 String get id; DateTime get createdAt; String get name; String get type; int get size; String get md5; String get url; String? get thumbnailUrl; String? get comment; String? get folderId; MisskeyDriveFolder? get folder; String? get userId; MisskeyUser? get user; bool? get isSensitive; String? get blurhash; MisskeyDriveFileProperties? get properties; bool? get isAiGenerated;
/// Create a copy of MisskeyDriveFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyDriveFileCopyWith<MisskeyDriveFile> get copyWith => _$MisskeyDriveFileCopyWithImpl<MisskeyDriveFile>(this as MisskeyDriveFile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyDriveFile&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.size, size) || other.size == size)&&(identical(other.md5, md5) || other.md5 == md5)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.folder, folder) || other.folder == folder)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&(identical(other.blurhash, blurhash) || other.blurhash == blurhash)&&(identical(other.properties, properties) || other.properties == properties)&&(identical(other.isAiGenerated, isAiGenerated) || other.isAiGenerated == isAiGenerated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,name,type,size,md5,url,thumbnailUrl,comment,folderId,folder,userId,user,isSensitive,blurhash,properties,isAiGenerated);

@override
String toString() {
  return 'MisskeyDriveFile(id: $id, createdAt: $createdAt, name: $name, type: $type, size: $size, md5: $md5, url: $url, thumbnailUrl: $thumbnailUrl, comment: $comment, folderId: $folderId, folder: $folder, userId: $userId, user: $user, isSensitive: $isSensitive, blurhash: $blurhash, properties: $properties, isAiGenerated: $isAiGenerated)';
}


}

/// @nodoc
abstract mixin class $MisskeyDriveFileCopyWith<$Res>  {
  factory $MisskeyDriveFileCopyWith(MisskeyDriveFile value, $Res Function(MisskeyDriveFile) _then) = _$MisskeyDriveFileCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String name, String type, int size, String md5, String url, String? thumbnailUrl, String? comment, String? folderId, MisskeyDriveFolder? folder, String? userId, MisskeyUser? user, bool? isSensitive, String? blurhash, MisskeyDriveFileProperties? properties, bool? isAiGenerated
});




}
/// @nodoc
class _$MisskeyDriveFileCopyWithImpl<$Res>
    implements $MisskeyDriveFileCopyWith<$Res> {
  _$MisskeyDriveFileCopyWithImpl(this._self, this._then);

  final MisskeyDriveFile _self;
  final $Res Function(MisskeyDriveFile) _then;

/// Create a copy of MisskeyDriveFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? name = null,Object? type = null,Object? size = null,Object? md5 = null,Object? url = null,Object? thumbnailUrl = freezed,Object? comment = freezed,Object? folderId = freezed,Object? folder = freezed,Object? userId = freezed,Object? user = freezed,Object? isSensitive = freezed,Object? blurhash = freezed,Object? properties = freezed,Object? isAiGenerated = freezed,}) {
  return _then(MisskeyDriveFile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,md5: null == md5 ? _self.md5 : md5 // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,folder: freezed == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as MisskeyDriveFolder?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MisskeyUser?,isSensitive: freezed == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool?,blurhash: freezed == blurhash ? _self.blurhash : blurhash // ignore: cast_nullable_to_non_nullable
as String?,properties: freezed == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as MisskeyDriveFileProperties?,isAiGenerated: freezed == isAiGenerated ? _self.isAiGenerated : isAiGenerated // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyDriveFile].
extension MisskeyDriveFilePatterns on MisskeyDriveFile {
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
mixin _$MisskeyDriveFileProperties {

 int? get width; int? get height; int? get orientation; String? get avgColor;
/// Create a copy of MisskeyDriveFileProperties
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyDriveFilePropertiesCopyWith<MisskeyDriveFileProperties> get copyWith => _$MisskeyDriveFilePropertiesCopyWithImpl<MisskeyDriveFileProperties>(this as MisskeyDriveFileProperties, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyDriveFileProperties&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.avgColor, avgColor) || other.avgColor == avgColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,orientation,avgColor);

@override
String toString() {
  return 'MisskeyDriveFileProperties(width: $width, height: $height, orientation: $orientation, avgColor: $avgColor)';
}


}

/// @nodoc
abstract mixin class $MisskeyDriveFilePropertiesCopyWith<$Res>  {
  factory $MisskeyDriveFilePropertiesCopyWith(MisskeyDriveFileProperties value, $Res Function(MisskeyDriveFileProperties) _then) = _$MisskeyDriveFilePropertiesCopyWithImpl;
@useResult
$Res call({
 int? width, int? height, int? orientation, String? avgColor
});




}
/// @nodoc
class _$MisskeyDriveFilePropertiesCopyWithImpl<$Res>
    implements $MisskeyDriveFilePropertiesCopyWith<$Res> {
  _$MisskeyDriveFilePropertiesCopyWithImpl(this._self, this._then);

  final MisskeyDriveFileProperties _self;
  final $Res Function(MisskeyDriveFileProperties) _then;

/// Create a copy of MisskeyDriveFileProperties
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = freezed,Object? height = freezed,Object? orientation = freezed,Object? avgColor = freezed,}) {
  return _then(MisskeyDriveFileProperties(
width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,orientation: freezed == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as int?,avgColor: freezed == avgColor ? _self.avgColor : avgColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyDriveFileProperties].
extension MisskeyDriveFilePropertiesPatterns on MisskeyDriveFileProperties {
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
