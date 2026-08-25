// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_role_policies.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyRolePolicies {

 bool? get gtlAvailable; bool? get ltlAvailable; bool? get canPublicNote; int? get mentionLimit; bool? get canInvite; int? get inviteLimit; int? get inviteLimitCycle; int? get inviteExpirationTime; bool? get canManageCustomEmojis; bool? get canManageAvatarDecorations; bool? get canSearchNotes; bool? get canSearchUsers; bool? get canUseTranslator; bool? get canHideAds; bool? get canCreateChannel; int? get driveCapacityMb; int? get maxFileSizeMb; bool? get alwaysMarkNsfw; bool? get canUpdateBioMedia; int? get pinLimit; int? get antennaLimit; int? get wordMuteLimit; int? get webhookLimit; int? get clipLimit; int? get noteEachClipsLimit; int? get userListLimit; int? get userEachUserListsLimit; num? get rateLimitFactor; int? get avatarDecorationLimit; bool? get canImportAntennas; bool? get canImportBlocking; bool? get canImportFollowing; bool? get canImportMuting; bool? get canImportUserLists; MisskeyChatAvailability? get chatAvailability; List<String>? get uploadableFileTypes; int? get noteDraftLimit; int? get scheduledNoteLimit; bool? get watermarkAvailable; RawMetaPayload get raw;
/// Create a copy of MisskeyRolePolicies
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyRolePoliciesCopyWith<MisskeyRolePolicies> get copyWith => _$MisskeyRolePoliciesCopyWithImpl<MisskeyRolePolicies>(this as MisskeyRolePolicies, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyRolePolicies&&(identical(other.gtlAvailable, gtlAvailable) || other.gtlAvailable == gtlAvailable)&&(identical(other.ltlAvailable, ltlAvailable) || other.ltlAvailable == ltlAvailable)&&(identical(other.canPublicNote, canPublicNote) || other.canPublicNote == canPublicNote)&&(identical(other.mentionLimit, mentionLimit) || other.mentionLimit == mentionLimit)&&(identical(other.canInvite, canInvite) || other.canInvite == canInvite)&&(identical(other.inviteLimit, inviteLimit) || other.inviteLimit == inviteLimit)&&(identical(other.inviteLimitCycle, inviteLimitCycle) || other.inviteLimitCycle == inviteLimitCycle)&&(identical(other.inviteExpirationTime, inviteExpirationTime) || other.inviteExpirationTime == inviteExpirationTime)&&(identical(other.canManageCustomEmojis, canManageCustomEmojis) || other.canManageCustomEmojis == canManageCustomEmojis)&&(identical(other.canManageAvatarDecorations, canManageAvatarDecorations) || other.canManageAvatarDecorations == canManageAvatarDecorations)&&(identical(other.canSearchNotes, canSearchNotes) || other.canSearchNotes == canSearchNotes)&&(identical(other.canSearchUsers, canSearchUsers) || other.canSearchUsers == canSearchUsers)&&(identical(other.canUseTranslator, canUseTranslator) || other.canUseTranslator == canUseTranslator)&&(identical(other.canHideAds, canHideAds) || other.canHideAds == canHideAds)&&(identical(other.canCreateChannel, canCreateChannel) || other.canCreateChannel == canCreateChannel)&&(identical(other.driveCapacityMb, driveCapacityMb) || other.driveCapacityMb == driveCapacityMb)&&(identical(other.maxFileSizeMb, maxFileSizeMb) || other.maxFileSizeMb == maxFileSizeMb)&&(identical(other.alwaysMarkNsfw, alwaysMarkNsfw) || other.alwaysMarkNsfw == alwaysMarkNsfw)&&(identical(other.canUpdateBioMedia, canUpdateBioMedia) || other.canUpdateBioMedia == canUpdateBioMedia)&&(identical(other.pinLimit, pinLimit) || other.pinLimit == pinLimit)&&(identical(other.antennaLimit, antennaLimit) || other.antennaLimit == antennaLimit)&&(identical(other.wordMuteLimit, wordMuteLimit) || other.wordMuteLimit == wordMuteLimit)&&(identical(other.webhookLimit, webhookLimit) || other.webhookLimit == webhookLimit)&&(identical(other.clipLimit, clipLimit) || other.clipLimit == clipLimit)&&(identical(other.noteEachClipsLimit, noteEachClipsLimit) || other.noteEachClipsLimit == noteEachClipsLimit)&&(identical(other.userListLimit, userListLimit) || other.userListLimit == userListLimit)&&(identical(other.userEachUserListsLimit, userEachUserListsLimit) || other.userEachUserListsLimit == userEachUserListsLimit)&&(identical(other.rateLimitFactor, rateLimitFactor) || other.rateLimitFactor == rateLimitFactor)&&(identical(other.avatarDecorationLimit, avatarDecorationLimit) || other.avatarDecorationLimit == avatarDecorationLimit)&&(identical(other.canImportAntennas, canImportAntennas) || other.canImportAntennas == canImportAntennas)&&(identical(other.canImportBlocking, canImportBlocking) || other.canImportBlocking == canImportBlocking)&&(identical(other.canImportFollowing, canImportFollowing) || other.canImportFollowing == canImportFollowing)&&(identical(other.canImportMuting, canImportMuting) || other.canImportMuting == canImportMuting)&&(identical(other.canImportUserLists, canImportUserLists) || other.canImportUserLists == canImportUserLists)&&(identical(other.chatAvailability, chatAvailability) || other.chatAvailability == chatAvailability)&&const DeepCollectionEquality().equals(other.uploadableFileTypes, uploadableFileTypes)&&(identical(other.noteDraftLimit, noteDraftLimit) || other.noteDraftLimit == noteDraftLimit)&&(identical(other.scheduledNoteLimit, scheduledNoteLimit) || other.scheduledNoteLimit == scheduledNoteLimit)&&(identical(other.watermarkAvailable, watermarkAvailable) || other.watermarkAvailable == watermarkAvailable)&&(identical(other.raw, raw) || other.raw == raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gtlAvailable,ltlAvailable,canPublicNote,mentionLimit,canInvite,inviteLimit,inviteLimitCycle,inviteExpirationTime,canManageCustomEmojis,canManageAvatarDecorations,canSearchNotes,canSearchUsers,canUseTranslator,canHideAds,canCreateChannel,driveCapacityMb,maxFileSizeMb,alwaysMarkNsfw,canUpdateBioMedia,pinLimit,antennaLimit,wordMuteLimit,webhookLimit,clipLimit,noteEachClipsLimit,userListLimit,userEachUserListsLimit,rateLimitFactor,avatarDecorationLimit,canImportAntennas,canImportBlocking,canImportFollowing,canImportMuting,canImportUserLists,chatAvailability,const DeepCollectionEquality().hash(uploadableFileTypes),noteDraftLimit,scheduledNoteLimit,watermarkAvailable,raw]);

@override
String toString() {
  return 'MisskeyRolePolicies(gtlAvailable: $gtlAvailable, ltlAvailable: $ltlAvailable, canPublicNote: $canPublicNote, mentionLimit: $mentionLimit, canInvite: $canInvite, inviteLimit: $inviteLimit, inviteLimitCycle: $inviteLimitCycle, inviteExpirationTime: $inviteExpirationTime, canManageCustomEmojis: $canManageCustomEmojis, canManageAvatarDecorations: $canManageAvatarDecorations, canSearchNotes: $canSearchNotes, canSearchUsers: $canSearchUsers, canUseTranslator: $canUseTranslator, canHideAds: $canHideAds, canCreateChannel: $canCreateChannel, driveCapacityMb: $driveCapacityMb, maxFileSizeMb: $maxFileSizeMb, alwaysMarkNsfw: $alwaysMarkNsfw, canUpdateBioMedia: $canUpdateBioMedia, pinLimit: $pinLimit, antennaLimit: $antennaLimit, wordMuteLimit: $wordMuteLimit, webhookLimit: $webhookLimit, clipLimit: $clipLimit, noteEachClipsLimit: $noteEachClipsLimit, userListLimit: $userListLimit, userEachUserListsLimit: $userEachUserListsLimit, rateLimitFactor: $rateLimitFactor, avatarDecorationLimit: $avatarDecorationLimit, canImportAntennas: $canImportAntennas, canImportBlocking: $canImportBlocking, canImportFollowing: $canImportFollowing, canImportMuting: $canImportMuting, canImportUserLists: $canImportUserLists, chatAvailability: $chatAvailability, uploadableFileTypes: $uploadableFileTypes, noteDraftLimit: $noteDraftLimit, scheduledNoteLimit: $scheduledNoteLimit, watermarkAvailable: $watermarkAvailable, raw: $raw)';
}


}

/// @nodoc
abstract mixin class $MisskeyRolePoliciesCopyWith<$Res>  {
  factory $MisskeyRolePoliciesCopyWith(MisskeyRolePolicies value, $Res Function(MisskeyRolePolicies) _then) = _$MisskeyRolePoliciesCopyWithImpl;
@useResult
$Res call({
 bool? gtlAvailable, bool? ltlAvailable, bool? canPublicNote, int? mentionLimit, bool? canInvite, int? inviteLimit, int? inviteLimitCycle, int? inviteExpirationTime, bool? canManageCustomEmojis, bool? canManageAvatarDecorations, bool? canSearchNotes, bool? canSearchUsers, bool? canUseTranslator, bool? canHideAds, bool? canCreateChannel, int? driveCapacityMb, int? maxFileSizeMb, bool? alwaysMarkNsfw, bool? canUpdateBioMedia, int? pinLimit, int? antennaLimit, int? wordMuteLimit, int? webhookLimit, int? clipLimit, int? noteEachClipsLimit, int? userListLimit, int? userEachUserListsLimit, num? rateLimitFactor, int? avatarDecorationLimit, bool? canImportAntennas, bool? canImportBlocking, bool? canImportFollowing, bool? canImportMuting, bool? canImportUserLists, MisskeyChatAvailability? chatAvailability, List<String>? uploadableFileTypes, int? noteDraftLimit, int? scheduledNoteLimit, bool? watermarkAvailable, RawMetaPayload raw
});




}
/// @nodoc
class _$MisskeyRolePoliciesCopyWithImpl<$Res>
    implements $MisskeyRolePoliciesCopyWith<$Res> {
  _$MisskeyRolePoliciesCopyWithImpl(this._self, this._then);

  final MisskeyRolePolicies _self;
  final $Res Function(MisskeyRolePolicies) _then;

/// Create a copy of MisskeyRolePolicies
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gtlAvailable = freezed,Object? ltlAvailable = freezed,Object? canPublicNote = freezed,Object? mentionLimit = freezed,Object? canInvite = freezed,Object? inviteLimit = freezed,Object? inviteLimitCycle = freezed,Object? inviteExpirationTime = freezed,Object? canManageCustomEmojis = freezed,Object? canManageAvatarDecorations = freezed,Object? canSearchNotes = freezed,Object? canSearchUsers = freezed,Object? canUseTranslator = freezed,Object? canHideAds = freezed,Object? canCreateChannel = freezed,Object? driveCapacityMb = freezed,Object? maxFileSizeMb = freezed,Object? alwaysMarkNsfw = freezed,Object? canUpdateBioMedia = freezed,Object? pinLimit = freezed,Object? antennaLimit = freezed,Object? wordMuteLimit = freezed,Object? webhookLimit = freezed,Object? clipLimit = freezed,Object? noteEachClipsLimit = freezed,Object? userListLimit = freezed,Object? userEachUserListsLimit = freezed,Object? rateLimitFactor = freezed,Object? avatarDecorationLimit = freezed,Object? canImportAntennas = freezed,Object? canImportBlocking = freezed,Object? canImportFollowing = freezed,Object? canImportMuting = freezed,Object? canImportUserLists = freezed,Object? chatAvailability = freezed,Object? uploadableFileTypes = freezed,Object? noteDraftLimit = freezed,Object? scheduledNoteLimit = freezed,Object? watermarkAvailable = freezed,Object? raw = null,}) {
  return _then(MisskeyRolePolicies(
gtlAvailable: freezed == gtlAvailable ? _self.gtlAvailable : gtlAvailable // ignore: cast_nullable_to_non_nullable
as bool?,ltlAvailable: freezed == ltlAvailable ? _self.ltlAvailable : ltlAvailable // ignore: cast_nullable_to_non_nullable
as bool?,canPublicNote: freezed == canPublicNote ? _self.canPublicNote : canPublicNote // ignore: cast_nullable_to_non_nullable
as bool?,mentionLimit: freezed == mentionLimit ? _self.mentionLimit : mentionLimit // ignore: cast_nullable_to_non_nullable
as int?,canInvite: freezed == canInvite ? _self.canInvite : canInvite // ignore: cast_nullable_to_non_nullable
as bool?,inviteLimit: freezed == inviteLimit ? _self.inviteLimit : inviteLimit // ignore: cast_nullable_to_non_nullable
as int?,inviteLimitCycle: freezed == inviteLimitCycle ? _self.inviteLimitCycle : inviteLimitCycle // ignore: cast_nullable_to_non_nullable
as int?,inviteExpirationTime: freezed == inviteExpirationTime ? _self.inviteExpirationTime : inviteExpirationTime // ignore: cast_nullable_to_non_nullable
as int?,canManageCustomEmojis: freezed == canManageCustomEmojis ? _self.canManageCustomEmojis : canManageCustomEmojis // ignore: cast_nullable_to_non_nullable
as bool?,canManageAvatarDecorations: freezed == canManageAvatarDecorations ? _self.canManageAvatarDecorations : canManageAvatarDecorations // ignore: cast_nullable_to_non_nullable
as bool?,canSearchNotes: freezed == canSearchNotes ? _self.canSearchNotes : canSearchNotes // ignore: cast_nullable_to_non_nullable
as bool?,canSearchUsers: freezed == canSearchUsers ? _self.canSearchUsers : canSearchUsers // ignore: cast_nullable_to_non_nullable
as bool?,canUseTranslator: freezed == canUseTranslator ? _self.canUseTranslator : canUseTranslator // ignore: cast_nullable_to_non_nullable
as bool?,canHideAds: freezed == canHideAds ? _self.canHideAds : canHideAds // ignore: cast_nullable_to_non_nullable
as bool?,canCreateChannel: freezed == canCreateChannel ? _self.canCreateChannel : canCreateChannel // ignore: cast_nullable_to_non_nullable
as bool?,driveCapacityMb: freezed == driveCapacityMb ? _self.driveCapacityMb : driveCapacityMb // ignore: cast_nullable_to_non_nullable
as int?,maxFileSizeMb: freezed == maxFileSizeMb ? _self.maxFileSizeMb : maxFileSizeMb // ignore: cast_nullable_to_non_nullable
as int?,alwaysMarkNsfw: freezed == alwaysMarkNsfw ? _self.alwaysMarkNsfw : alwaysMarkNsfw // ignore: cast_nullable_to_non_nullable
as bool?,canUpdateBioMedia: freezed == canUpdateBioMedia ? _self.canUpdateBioMedia : canUpdateBioMedia // ignore: cast_nullable_to_non_nullable
as bool?,pinLimit: freezed == pinLimit ? _self.pinLimit : pinLimit // ignore: cast_nullable_to_non_nullable
as int?,antennaLimit: freezed == antennaLimit ? _self.antennaLimit : antennaLimit // ignore: cast_nullable_to_non_nullable
as int?,wordMuteLimit: freezed == wordMuteLimit ? _self.wordMuteLimit : wordMuteLimit // ignore: cast_nullable_to_non_nullable
as int?,webhookLimit: freezed == webhookLimit ? _self.webhookLimit : webhookLimit // ignore: cast_nullable_to_non_nullable
as int?,clipLimit: freezed == clipLimit ? _self.clipLimit : clipLimit // ignore: cast_nullable_to_non_nullable
as int?,noteEachClipsLimit: freezed == noteEachClipsLimit ? _self.noteEachClipsLimit : noteEachClipsLimit // ignore: cast_nullable_to_non_nullable
as int?,userListLimit: freezed == userListLimit ? _self.userListLimit : userListLimit // ignore: cast_nullable_to_non_nullable
as int?,userEachUserListsLimit: freezed == userEachUserListsLimit ? _self.userEachUserListsLimit : userEachUserListsLimit // ignore: cast_nullable_to_non_nullable
as int?,rateLimitFactor: freezed == rateLimitFactor ? _self.rateLimitFactor : rateLimitFactor // ignore: cast_nullable_to_non_nullable
as num?,avatarDecorationLimit: freezed == avatarDecorationLimit ? _self.avatarDecorationLimit : avatarDecorationLimit // ignore: cast_nullable_to_non_nullable
as int?,canImportAntennas: freezed == canImportAntennas ? _self.canImportAntennas : canImportAntennas // ignore: cast_nullable_to_non_nullable
as bool?,canImportBlocking: freezed == canImportBlocking ? _self.canImportBlocking : canImportBlocking // ignore: cast_nullable_to_non_nullable
as bool?,canImportFollowing: freezed == canImportFollowing ? _self.canImportFollowing : canImportFollowing // ignore: cast_nullable_to_non_nullable
as bool?,canImportMuting: freezed == canImportMuting ? _self.canImportMuting : canImportMuting // ignore: cast_nullable_to_non_nullable
as bool?,canImportUserLists: freezed == canImportUserLists ? _self.canImportUserLists : canImportUserLists // ignore: cast_nullable_to_non_nullable
as bool?,chatAvailability: freezed == chatAvailability ? _self.chatAvailability : chatAvailability // ignore: cast_nullable_to_non_nullable
as MisskeyChatAvailability?,uploadableFileTypes: freezed == uploadableFileTypes ? _self.uploadableFileTypes : uploadableFileTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,noteDraftLimit: freezed == noteDraftLimit ? _self.noteDraftLimit : noteDraftLimit // ignore: cast_nullable_to_non_nullable
as int?,scheduledNoteLimit: freezed == scheduledNoteLimit ? _self.scheduledNoteLimit : scheduledNoteLimit // ignore: cast_nullable_to_non_nullable
as int?,watermarkAvailable: freezed == watermarkAvailable ? _self.watermarkAvailable : watermarkAvailable // ignore: cast_nullable_to_non_nullable
as bool?,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as RawMetaPayload,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyRolePolicies].
extension MisskeyRolePoliciesPatterns on MisskeyRolePolicies {
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
mixin _$MisskeyRolePolicyOverride {

 Object? get value; int? get priority; bool? get useDefault;
/// Create a copy of MisskeyRolePolicyOverride
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyRolePolicyOverrideCopyWith<MisskeyRolePolicyOverride> get copyWith => _$MisskeyRolePolicyOverrideCopyWithImpl<MisskeyRolePolicyOverride>(this as MisskeyRolePolicyOverride, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyRolePolicyOverride&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.useDefault, useDefault) || other.useDefault == useDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value),priority,useDefault);

@override
String toString() {
  return 'MisskeyRolePolicyOverride(value: $value, priority: $priority, useDefault: $useDefault)';
}


}

/// @nodoc
abstract mixin class $MisskeyRolePolicyOverrideCopyWith<$Res>  {
  factory $MisskeyRolePolicyOverrideCopyWith(MisskeyRolePolicyOverride value, $Res Function(MisskeyRolePolicyOverride) _then) = _$MisskeyRolePolicyOverrideCopyWithImpl;
@useResult
$Res call({
 Object? value, int? priority, bool? useDefault
});




}
/// @nodoc
class _$MisskeyRolePolicyOverrideCopyWithImpl<$Res>
    implements $MisskeyRolePolicyOverrideCopyWith<$Res> {
  _$MisskeyRolePolicyOverrideCopyWithImpl(this._self, this._then);

  final MisskeyRolePolicyOverride _self;
  final $Res Function(MisskeyRolePolicyOverride) _then;

/// Create a copy of MisskeyRolePolicyOverride
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = freezed,Object? priority = freezed,Object? useDefault = freezed,}) {
  return _then(MisskeyRolePolicyOverride(
value: freezed == value ? _self.value : value ,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int?,useDefault: freezed == useDefault ? _self.useDefault : useDefault // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyRolePolicyOverride].
extension MisskeyRolePolicyOverridePatterns on MisskeyRolePolicyOverride {
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
