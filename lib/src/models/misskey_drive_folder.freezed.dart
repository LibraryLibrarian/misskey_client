// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_drive_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyDriveFolder {

 String get id; DateTime get createdAt; String get name; String? get parentId; MisskeyDriveFolder? get parent; int? get foldersCount; int? get filesCount;
/// Create a copy of MisskeyDriveFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyDriveFolderCopyWith<MisskeyDriveFolder> get copyWith => _$MisskeyDriveFolderCopyWithImpl<MisskeyDriveFolder>(this as MisskeyDriveFolder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyDriveFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.foldersCount, foldersCount) || other.foldersCount == foldersCount)&&(identical(other.filesCount, filesCount) || other.filesCount == filesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,name,parentId,parent,foldersCount,filesCount);

@override
String toString() {
  return 'MisskeyDriveFolder(id: $id, createdAt: $createdAt, name: $name, parentId: $parentId, parent: $parent, foldersCount: $foldersCount, filesCount: $filesCount)';
}


}

/// @nodoc
abstract mixin class $MisskeyDriveFolderCopyWith<$Res>  {
  factory $MisskeyDriveFolderCopyWith(MisskeyDriveFolder value, $Res Function(MisskeyDriveFolder) _then) = _$MisskeyDriveFolderCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String name, String? parentId, MisskeyDriveFolder? parent, int? foldersCount, int? filesCount
});




}
/// @nodoc
class _$MisskeyDriveFolderCopyWithImpl<$Res>
    implements $MisskeyDriveFolderCopyWith<$Res> {
  _$MisskeyDriveFolderCopyWithImpl(this._self, this._then);

  final MisskeyDriveFolder _self;
  final $Res Function(MisskeyDriveFolder) _then;

/// Create a copy of MisskeyDriveFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? name = null,Object? parentId = freezed,Object? parent = freezed,Object? foldersCount = freezed,Object? filesCount = freezed,}) {
  return _then(MisskeyDriveFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as MisskeyDriveFolder?,foldersCount: freezed == foldersCount ? _self.foldersCount : foldersCount // ignore: cast_nullable_to_non_nullable
as int?,filesCount: freezed == filesCount ? _self.filesCount : filesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyDriveFolder].
extension MisskeyDriveFolderPatterns on MisskeyDriveFolder {
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
