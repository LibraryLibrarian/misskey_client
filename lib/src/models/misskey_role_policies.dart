import 'package:freezed_annotation/freezed_annotation.dart';

import 'raw_meta_payload.dart';

part 'misskey_role_policies.freezed.dart';
part 'misskey_role_policies.g.dart';

/// Availability of the chat feature under the effective role policies.
@JsonEnum()
enum MisskeyChatAvailability { available, readonly, unavailable, unknown }

/// Effective role policies applied to an instance visitor or a user.
///
/// Misskey can add fork-specific or newer policy keys. All original keys are
/// retained in [raw], while known keys are exposed as typed properties.
@freezed
@JsonSerializable()
class MisskeyRolePolicies with _$MisskeyRolePolicies {
  const MisskeyRolePolicies({
    this.gtlAvailable,
    this.ltlAvailable,
    this.canPublicNote,
    this.mentionLimit,
    this.canInvite,
    this.inviteLimit,
    this.inviteLimitCycle,
    this.inviteExpirationTime,
    this.canManageCustomEmojis,
    this.canManageAvatarDecorations,
    this.canSearchNotes,
    this.canSearchUsers,
    this.canUseTranslator,
    this.canHideAds,
    this.canCreateChannel,
    this.driveCapacityMb,
    this.maxFileSizeMb,
    this.alwaysMarkNsfw,
    this.canUpdateBioMedia,
    this.pinLimit,
    this.antennaLimit,
    this.wordMuteLimit,
    this.webhookLimit,
    this.clipLimit,
    this.noteEachClipsLimit,
    this.userListLimit,
    this.userEachUserListsLimit,
    this.rateLimitFactor,
    this.avatarDecorationLimit,
    this.canImportAntennas,
    this.canImportBlocking,
    this.canImportFollowing,
    this.canImportMuting,
    this.canImportUserLists,
    this.chatAvailability,
    this.uploadableFileTypes,
    this.noteDraftLimit,
    this.scheduledNoteLimit,
    this.watermarkAvailable,
    this.raw = const RawMetaPayload.empty(),
  });

  factory MisskeyRolePolicies.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRolePoliciesFromJson(json);

  /// Whether the global timeline is available.
  @override
  final bool? gtlAvailable;

  /// Whether the local timeline is available.
  @override
  final bool? ltlAvailable;

  /// Whether public notes can be created.
  @override
  final bool? canPublicNote;

  /// The maximum number of mentions in a note.
  @override
  final int? mentionLimit;

  /// Whether users can create invitation codes.
  @override
  final bool? canInvite;

  /// The maximum number of invitation codes that can be created per cycle.
  @override
  final int? inviteLimit;

  /// The invitation limit cycle in minutes.
  @override
  final int? inviteLimitCycle;

  /// The invitation expiration time in minutes.
  @override
  final int? inviteExpirationTime;

  /// Whether custom emojis can be managed.
  @override
  final bool? canManageCustomEmojis;

  /// Whether avatar decorations can be managed.
  @override
  final bool? canManageAvatarDecorations;

  /// Whether notes can be searched.
  @override
  final bool? canSearchNotes;

  /// Whether users can be searched.
  @override
  final bool? canSearchUsers;

  /// Whether the translator can be used.
  @override
  final bool? canUseTranslator;

  /// Whether advertisements can be hidden.
  @override
  final bool? canHideAds;

  /// Whether channels can be created.
  @override
  final bool? canCreateChannel;

  /// The drive capacity in megabytes.
  @override
  final int? driveCapacityMb;

  /// The maximum upload size in megabytes.
  @override
  final int? maxFileSizeMb;

  /// Whether uploaded files are always marked as sensitive.
  @override
  final bool? alwaysMarkNsfw;

  /// Whether profile media can be updated.
  @override
  final bool? canUpdateBioMedia;

  /// The maximum number of pinned notes.
  @override
  final int? pinLimit;

  /// The maximum number of antennas.
  @override
  final int? antennaLimit;

  /// The maximum number of word-mute entries.
  @override
  final int? wordMuteLimit;

  /// The maximum number of webhooks.
  @override
  final int? webhookLimit;

  /// The maximum number of clips.
  @override
  final int? clipLimit;

  /// The maximum number of clips that can contain one note.
  @override
  final int? noteEachClipsLimit;

  /// The maximum number of user lists.
  @override
  final int? userListLimit;

  /// The maximum number of users in each user list.
  @override
  final int? userEachUserListsLimit;

  /// The rate limit multiplier.
  @override
  final num? rateLimitFactor;

  /// The maximum number of avatar decorations.
  @override
  final int? avatarDecorationLimit;

  /// Whether antennas can be imported.
  @override
  final bool? canImportAntennas;

  /// Whether blocking data can be imported.
  @override
  final bool? canImportBlocking;

  /// Whether following data can be imported.
  @override
  final bool? canImportFollowing;

  /// Whether muting data can be imported.
  @override
  final bool? canImportMuting;

  /// Whether user lists can be imported.
  @override
  final bool? canImportUserLists;

  /// The chat feature availability.
  @override
  @JsonKey(unknownEnumValue: MisskeyChatAvailability.unknown)
  final MisskeyChatAvailability? chatAvailability;

  /// MIME type patterns accepted for uploads.
  @override
  final List<String>? uploadableFileTypes;

  /// The maximum number of note drafts.
  @override
  final int? noteDraftLimit;

  /// The maximum number of scheduled notes.
  @override
  final int? scheduledNoteLimit;

  /// Whether the watermark feature is available.
  @override
  final bool? watermarkAvailable;

  /// The immutable original policy object, including unknown policy keys.
  @override
  @JsonKey(
    includeToJson: false,
    readValue: _readWholeObject,
    fromJson: _rawFromJson,
  )
  final RawMetaPayload raw;

  /// Converts this model to JSON while preserving unknown policy keys.
  Map<String, dynamic> toJson() {
    final typed = _$MisskeyRolePoliciesToJson(this)
      ..removeWhere((_, value) => value == null);
    if (chatAvailability == MisskeyChatAvailability.unknown &&
        raw.json.containsKey('chatAvailability')) {
      typed.remove('chatAvailability');
    }
    return <String, dynamic>{...raw.json, ...typed};
  }

  static Object? _readWholeObject(Map<dynamic, dynamic> json, String _) => json;

  static RawMetaPayload _rawFromJson(Object? json) =>
      RawMetaPayload(Map<String, dynamic>.from(json! as Map));
}

/// A single policy override stored on a role.
///
/// Role definitions use an override envelope and are not wire-compatible with
/// the effective values in [MisskeyRolePolicies].
@freezed
@JsonSerializable()
class MisskeyRolePolicyOverride with _$MisskeyRolePolicyOverride {
  const MisskeyRolePolicyOverride({this.value, this.priority, this.useDefault});

  factory MisskeyRolePolicyOverride.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRolePolicyOverrideFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRolePolicyOverrideToJson(this);

  /// The override value, whose type depends on the policy name.
  @override
  final Object? value;

  /// The priority used while aggregating policies from multiple roles.
  @override
  final int? priority;

  /// Whether the instance default is used instead of [value].
  @override
  final bool? useDefault;
}
