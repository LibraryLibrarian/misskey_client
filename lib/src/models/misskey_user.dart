import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_note.dart';

part 'misskey_user.g.dart';

/// The online status of a user.
@JsonEnum()
enum MisskeyOnlineStatus {
  unknown,
  online,
  active,
  offline,
}

/// A Misskey user (unified model of UserLite and UserDetailed).
@JsonSerializable()
class MisskeyUser {
  const MisskeyUser({
    required this.id,
    required this.username,
    this.name,
    this.host,
    this.avatarUrl,
    this.avatarBlurhash,
    this.isBot,
    this.isCat,
    this.emojis,
    this.onlineStatus,
    this.createdAt,
    this.description,
    this.followersCount,
    this.followingCount,
    this.notesCount,
    this.isLocked,
    this.isSuspended,
    this.isSilenced,
    this.pinnedNoteIds,
    this.pinnedNotes,
    this.bannerUrl,
    this.bannerBlurhash,
    this.fields,
    this.isFollowing,
    this.isFollowed,
    this.hasPendingFollowRequestFromYou,
    this.hasPendingFollowRequestToYou,
    this.isBlocking,
    this.isBlocked,
    this.isMuted,
    this.isRenoteMuted,
    this.avatarDecorations,
    this.requireSigninToViewContents,
    this.makeNotesFollowersOnlyBefore,
    this.makeNotesHiddenBefore,
    this.instance,
    this.badgeRoles,
    this.url,
    this.uri,
    this.movedTo,
    this.alsoKnownAs,
    this.updatedAt,
    this.lastFetchedAt,
    this.location,
    this.birthday,
    this.lang,
    this.verifiedLinks,
    this.publicReactions,
    this.followingVisibility,
    this.followersVisibility,
    this.roles,
    this.memo,
    this.notify,
    this.withReplies,
    this.twoFactorEnabled,
    this.usePasswordLessLogin,
    this.securityKeys,
  });

  factory MisskeyUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserToJson(this);

  /// The unique identifier of this user.
  final String id;

  /// The username (handle without host).
  final String username;

  /// The display name.
  @JsonKey(defaultValue: '')
  final String? name;

  /// The hostname for remote users. Null for local users.
  final String? host;

  /// The avatar image URL.
  final String? avatarUrl;

  /// The blurhash string for the avatar image.
  final String? avatarBlurhash;

  /// Whether this user is a bot.
  @JsonKey(defaultValue: false)
  final bool? isBot;

  /// Whether this user has cat ears enabled.
  @JsonKey(defaultValue: false)
  final bool? isCat;

  /// Custom emoji map where keys are shortcodes and values are URLs.
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String>? emojis;

  /// The current online status.
  @JsonKey(unknownEnumValue: MisskeyOnlineStatus.unknown)
  final MisskeyOnlineStatus? onlineStatus;

  // UserDetailed fields (nullable: may not be present in UserLite)

  /// The date and time when this account was created.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The profile description (bio).
  final String? description;

  /// The number of followers.
  @JsonKey(defaultValue: 0)
  final int? followersCount;

  /// The number of users being followed.
  @JsonKey(defaultValue: 0)
  final int? followingCount;

  /// The number of notes posted.
  @JsonKey(defaultValue: 0)
  final int? notesCount;

  /// Whether this account requires follow approval.
  @JsonKey(defaultValue: false)
  final bool? isLocked;

  /// Whether this account is suspended.
  @JsonKey(defaultValue: false)
  final bool? isSuspended;

  /// Whether this account is silenced.
  @JsonKey(defaultValue: false)
  final bool? isSilenced;

  /// The IDs of pinned notes.
  final List<String>? pinnedNoteIds;

  /// The pinned notes.
  final List<MisskeyNote>? pinnedNotes;

  /// The banner image URL.
  final String? bannerUrl;

  /// The blurhash string for the banner image.
  final String? bannerBlurhash;

  /// The custom profile fields.
  @JsonKey(defaultValue: <MisskeyUserField>[])
  final List<MisskeyUserField>? fields;

  // --- Relation fields (present only with authenticated request) ---

  /// Whether the authenticated user is following this user.
  final bool? isFollowing;

  /// Whether this user is following the authenticated user.
  final bool? isFollowed;

  /// Whether the authenticated user has a pending follow request to this user.
  final bool? hasPendingFollowRequestFromYou;

  /// Whether this user has a pending follow request to the authenticated user.
  final bool? hasPendingFollowRequestToYou;

  /// Whether the authenticated user is blocking this user.
  final bool? isBlocking;

  /// Whether this user is blocking the authenticated user.
  final bool? isBlocked;

  /// Whether the authenticated user is muting this user.
  final bool? isMuted;

  /// Whether the authenticated user is muting renotes from this user.
  final bool? isRenoteMuted;

  /// The avatar decorations applied to this user.
  final List<MisskeyAvatarDecoration>? avatarDecorations;

  // --- UserLite additional fields ---

  /// Whether sign-in is required to view this user's content.
  @JsonKey(defaultValue: false)
  final bool? requireSigninToViewContents;

  /// The timestamp before which notes are followers-only.
  final int? makeNotesFollowersOnlyBefore;

  /// The timestamp before which notes are hidden.
  final int? makeNotesHiddenBefore;

  /// The instance information for remote users.
  final MisskeyUserInstance? instance;

  /// The badge roles assigned to this user.
  final List<MisskeyBadgeRole>? badgeRoles;

  // --- UserDetailedNotMeOnly fields ---

  /// The URL of this user's profile page.
  final String? url;

  /// The ActivityPub URI.
  final String? uri;

  /// The ID of the user this account has moved to.
  final String? movedTo;

  /// The list of accounts known to be aliases of this user.
  final List<String>? alsoKnownAs;

  /// The date and time when this user was last updated.
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The date and time when this user was last fetched from the remote.
  @SafeDateTimeConverter()
  final DateTime? lastFetchedAt;

  /// The location set in the profile.
  final String? location;

  /// The birthday in `YYYY-MM-DD` format.
  final String? birthday;

  /// The language set by the user.
  final String? lang;

  /// The list of verified links.
  final List<String>? verifiedLinks;

  /// Whether this user's reactions are public.
  @JsonKey(defaultValue: false)
  final bool? publicReactions;

  /// The visibility of the following list (`public`, `followers`, `private`).
  final String? followingVisibility;

  /// The visibility of the followers list (`public`, `followers`, `private`).
  final String? followersVisibility;

  /// The roles assigned to this user.
  final List<MisskeyRoleLite>? roles;

  /// The memo (personal note) set by the authenticated user for this user.
  final String? memo;

  /// The notification setting (`normal` or `none`).
  final String? notify;

  /// Whether to include replies in the timeline.
  @JsonKey(defaultValue: false)
  final bool? withReplies;

  /// Whether two-factor authentication is enabled.
  @JsonKey(defaultValue: false)
  final bool? twoFactorEnabled;

  /// Whether passwordless login is enabled.
  @JsonKey(defaultValue: false)
  final bool? usePasswordLessLogin;

  /// Whether security keys are registered.
  @JsonKey(defaultValue: false)
  final bool? securityKeys;
}

/// A custom profile field.
@JsonSerializable()
class MisskeyUserField {
  const MisskeyUserField({required this.name, required this.value});

  factory MisskeyUserField.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserFieldFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserFieldToJson(this);

  /// The field label.
  final String name;

  /// The field value.
  final String value;
}

/// An avatar decoration.
@JsonSerializable()
class MisskeyAvatarDecoration {
  const MisskeyAvatarDecoration({
    required this.id,
    this.angle,
    this.flipH,
    required this.url,
    this.offsetX,
    this.offsetY,
  });

  factory MisskeyAvatarDecoration.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAvatarDecorationFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAvatarDecorationToJson(this);

  /// The unique identifier of this decoration.
  final String id;

  /// The rotation angle in radians.
  final double? angle;

  /// Whether the decoration is horizontally flipped.
  final bool? flipH;

  /// The image URL of this decoration.
  final String url;

  /// The horizontal offset.
  final double? offsetX;

  /// The vertical offset.
  final double? offsetY;
}

/// Instance information for a remote user.
@JsonSerializable()
class MisskeyUserInstance {
  const MisskeyUserInstance({
    this.name,
    this.softwareName,
    this.softwareVersion,
    this.iconUrl,
    this.faviconUrl,
    this.themeColor,
  });

  factory MisskeyUserInstance.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserInstanceToJson(this);

  /// The display name of the instance.
  final String? name;

  /// The software name (e.g. `misskey`, `mastodon`).
  final String? softwareName;

  /// The software version string.
  final String? softwareVersion;

  /// The instance icon URL.
  final String? iconUrl;

  /// The instance favicon URL.
  final String? faviconUrl;

  /// The theme color of the instance.
  final String? themeColor;
}

/// A badge role.
@JsonSerializable()
class MisskeyBadgeRole {
  const MisskeyBadgeRole({
    required this.name,
    this.iconUrl,
    this.displayOrder,
  });

  factory MisskeyBadgeRole.fromJson(Map<String, dynamic> json) =>
      _$MisskeyBadgeRoleFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyBadgeRoleToJson(this);

  /// The name of this badge role.
  final String name;

  /// The icon URL.
  final String? iconUrl;

  /// The display order.
  @JsonKey(defaultValue: 0)
  final int? displayOrder;
}

/// A lightweight role representation.
@JsonSerializable()
class MisskeyRoleLite {
  const MisskeyRoleLite({
    required this.id,
    required this.name,
    this.color,
    this.iconUrl,
    this.description,
    this.isModerator,
    this.isAdministrator,
    this.displayOrder,
  });

  factory MisskeyRoleLite.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRoleLiteFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRoleLiteToJson(this);

  /// The unique identifier of this role.
  final String id;

  /// The name of this role.
  final String name;

  /// The theme color.
  final String? color;

  /// The icon URL.
  final String? iconUrl;

  /// The description of this role.
  final String? description;

  /// Whether this role has moderator privileges.
  @JsonKey(defaultValue: false)
  final bool? isModerator;

  /// Whether this role has administrator privileges.
  @JsonKey(defaultValue: false)
  final bool? isAdministrator;

  /// The display order.
  @JsonKey(defaultValue: 0)
  final int? displayOrder;
}
