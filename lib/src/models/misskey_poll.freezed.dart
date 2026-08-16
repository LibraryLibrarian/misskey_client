// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_poll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyPollChoice {

 String get text; int get votes; bool get isVoted;
/// Create a copy of MisskeyPollChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyPollChoiceCopyWith<MisskeyPollChoice> get copyWith => _$MisskeyPollChoiceCopyWithImpl<MisskeyPollChoice>(this as MisskeyPollChoice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyPollChoice&&(identical(other.text, text) || other.text == text)&&(identical(other.votes, votes) || other.votes == votes)&&(identical(other.isVoted, isVoted) || other.isVoted == isVoted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,votes,isVoted);

@override
String toString() {
  return 'MisskeyPollChoice(text: $text, votes: $votes, isVoted: $isVoted)';
}


}

/// @nodoc
abstract mixin class $MisskeyPollChoiceCopyWith<$Res>  {
  factory $MisskeyPollChoiceCopyWith(MisskeyPollChoice value, $Res Function(MisskeyPollChoice) _then) = _$MisskeyPollChoiceCopyWithImpl;
@useResult
$Res call({
 String text, int votes, bool isVoted
});




}
/// @nodoc
class _$MisskeyPollChoiceCopyWithImpl<$Res>
    implements $MisskeyPollChoiceCopyWith<$Res> {
  _$MisskeyPollChoiceCopyWithImpl(this._self, this._then);

  final MisskeyPollChoice _self;
  final $Res Function(MisskeyPollChoice) _then;

/// Create a copy of MisskeyPollChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? votes = null,Object? isVoted = null,}) {
  return _then(MisskeyPollChoice(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,isVoted: null == isVoted ? _self.isVoted : isVoted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyPollChoice].
extension MisskeyPollChoicePatterns on MisskeyPollChoice {
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
mixin _$MisskeyPoll {

 List<MisskeyPollChoice> get choices; bool? get multiple; DateTime? get expiresAt;
/// Create a copy of MisskeyPoll
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyPollCopyWith<MisskeyPoll> get copyWith => _$MisskeyPollCopyWithImpl<MisskeyPoll>(this as MisskeyPoll, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyPoll&&const DeepCollectionEquality().equals(other.choices, choices)&&(identical(other.multiple, multiple) || other.multiple == multiple)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(choices),multiple,expiresAt);

@override
String toString() {
  return 'MisskeyPoll(choices: $choices, multiple: $multiple, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $MisskeyPollCopyWith<$Res>  {
  factory $MisskeyPollCopyWith(MisskeyPoll value, $Res Function(MisskeyPoll) _then) = _$MisskeyPollCopyWithImpl;
@useResult
$Res call({
 List<MisskeyPollChoice> choices, bool? multiple, DateTime? expiresAt
});




}
/// @nodoc
class _$MisskeyPollCopyWithImpl<$Res>
    implements $MisskeyPollCopyWith<$Res> {
  _$MisskeyPollCopyWithImpl(this._self, this._then);

  final MisskeyPoll _self;
  final $Res Function(MisskeyPoll) _then;

/// Create a copy of MisskeyPoll
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? choices = null,Object? multiple = freezed,Object? expiresAt = freezed,}) {
  return _then(MisskeyPoll(
choices: null == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as List<MisskeyPollChoice>,multiple: freezed == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyPoll].
extension MisskeyPollPatterns on MisskeyPoll {
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
