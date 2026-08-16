import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_converters.dart';
import 'misskey_note.dart';
import 'muted_word.dart';

part 'misskey_user.freezed.dart';
part 'misskey_user.g.dart';

/// The online status of a user.
@JsonEnum()
enum MisskeyOnlineStatus { unknown, online, active, offline }

/// A Misskey user (unified model of UserLite and UserDetailed).
@freezed
@JsonSerializable()
class MisskeyUser with _$MisskeyUser {
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
    this.isAdmin,
    this.isModerator,
    this.pinnedPageId,
    this.avatarId,
    this.bannerId,
    this.followedMessage,
    this.noCrawle,
    this.preventAiLearning,
    this.hideOnlineStatus,
    this.isExplorable,
    this.isDeleted,
    this.injectFeaturedNote,
    this.receiveAnnouncementEmail,
    this.alwaysMarkNsfw,
    this.autoSensitive,
    this.carefulBot,
    this.autoAcceptFollowed,
    this.chatScope,
    this.canChat,
    this.hasUnreadSpecifiedNotes,
    this.hasUnreadMentions,
    this.hasUnreadChatMessages,
    this.hasUnreadAnnouncement,
    this.hasUnreadAntenna,
    this.hasUnreadChannel,
    this.hasUnreadNotification,
    this.hasPendingReceivedFollowRequest,
    this.unreadNotificationsCount,
    this.mutedWords,
    this.hardMutedWords,
    this.mutedInstances,
    this.mutingNotificationTypes,
    this.notificationRecieveConfig,
    this.emailNotificationTypes,
    this.achievements,
    this.loggedInDays,
    this.policies,
    this.twoFactorBackupCodesStock,
    this.email,
    this.emailVerified,
    this.moderationNote,
    this.isLimited,
    this.mutualLinkSections,
    this.pinnedPage,
  });

  factory MisskeyUser.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserToJson(this);

  /// The unique identifier of this user.
  @override
  final String id;

  /// The username (handle without host).
  @override
  final String username;

  /// The display name.
  @override
  @JsonKey(defaultValue: '')
  final String? name;

  /// The hostname for remote users. Null for local users.
  @override
  final String? host;

  /// The avatar image URL.
  @override
  final String? avatarUrl;

  /// The blurhash string for the avatar image.
  @override
  final String? avatarBlurhash;

  /// Whether this user is a bot.
  @override
  @JsonKey(defaultValue: false)
  final bool? isBot;

  /// Whether this user has cat ears enabled.
  @override
  @JsonKey(defaultValue: false)
  final bool? isCat;

  /// Custom emoji map where keys are shortcodes and values are URLs.
  @override
  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String>? emojis;

  /// The current online status.
  @override
  @JsonKey(unknownEnumValue: MisskeyOnlineStatus.unknown)
  final MisskeyOnlineStatus? onlineStatus;

  // UserDetailed fields (nullable: may not be present in UserLite)

  /// The date and time when this account was created.
  @override
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The profile description (bio).
  @override
  final String? description;

  /// The number of followers.
  @override
  @JsonKey(defaultValue: 0)
  final int? followersCount;

  /// The number of users being followed.
  @override
  @JsonKey(defaultValue: 0)
  final int? followingCount;

  /// The number of notes posted.
  @override
  @JsonKey(defaultValue: 0)
  final int? notesCount;

  /// Whether this account requires follow approval.
  @override
  @JsonKey(defaultValue: false)
  final bool? isLocked;

  /// Whether this account is suspended.
  @override
  @JsonKey(defaultValue: false)
  final bool? isSuspended;

  /// Whether this account is silenced.
  @override
  @JsonKey(defaultValue: false)
  final bool? isSilenced;

  /// The IDs of pinned notes.
  @override
  final List<String>? pinnedNoteIds;

  /// The pinned notes.
  @override
  final List<MisskeyNote>? pinnedNotes;

  /// The banner image URL.
  @override
  final String? bannerUrl;

  /// The blurhash string for the banner image.
  @override
  final String? bannerBlurhash;

  /// The custom profile fields.
  @override
  @JsonKey(defaultValue: <MisskeyUserField>[])
  final List<MisskeyUserField>? fields;

  // --- Relation fields (present only with authenticated request) ---

  /// Whether the authenticated user is following this user.
  @override
  final bool? isFollowing;

  /// Whether this user is following the authenticated user.
  @override
  final bool? isFollowed;

  /// Whether the authenticated user has a pending follow request to this user.
  @override
  final bool? hasPendingFollowRequestFromYou;

  /// Whether this user has a pending follow request to the authenticated user.
  @override
  final bool? hasPendingFollowRequestToYou;

  /// Whether the authenticated user is blocking this user.
  @override
  final bool? isBlocking;

  /// Whether this user is blocking the authenticated user.
  @override
  final bool? isBlocked;

  /// Whether the authenticated user is muting this user.
  @override
  final bool? isMuted;

  /// Whether the authenticated user is muting renotes from this user.
  @override
  final bool? isRenoteMuted;

  /// The avatar decorations applied to this user.
  @override
  final List<MisskeyAvatarDecoration>? avatarDecorations;

  // --- UserLite additional fields ---

  /// Whether sign-in is required to view this user's content.
  @override
  @JsonKey(defaultValue: false)
  final bool? requireSigninToViewContents;

  /// The timestamp before which notes are followers-only.
  @override
  final int? makeNotesFollowersOnlyBefore;

  /// The timestamp before which notes are hidden.
  @override
  final int? makeNotesHiddenBefore;

  /// The instance information for remote users.
  @override
  final MisskeyUserInstance? instance;

  /// The badge roles assigned to this user.
  @override
  final List<MisskeyBadgeRole>? badgeRoles;

  // --- UserDetailedNotMeOnly fields ---

  /// The URL of this user's profile page.
  @override
  final String? url;

  /// The ActivityPub URI.
  @override
  final String? uri;

  /// The ID of the user this account has moved to.
  @override
  final String? movedTo;

  /// The list of accounts known to be aliases of this user.
  @override
  final List<String>? alsoKnownAs;

  /// The date and time when this user was last updated.
  @override
  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// The date and time when this user was last fetched from the remote.
  @override
  @SafeDateTimeConverter()
  final DateTime? lastFetchedAt;

  /// The location set in the profile.
  @override
  final String? location;

  /// The birthday in `YYYY-MM-DD` format.
  @override
  final String? birthday;

  /// The language set by the user.
  @override
  final String? lang;

  /// The list of verified links.
  @override
  final List<String>? verifiedLinks;

  /// Whether this user's reactions are public.
  @override
  @JsonKey(defaultValue: false)
  final bool? publicReactions;

  /// The visibility of the following list (`public`, `followers`, `private`).
  @override
  final String? followingVisibility;

  /// The visibility of the followers list (`public`, `followers`, `private`).
  @override
  final String? followersVisibility;

  /// The roles assigned to this user.
  @override
  final List<MisskeyRoleLite>? roles;

  /// The memo (personal note) set by the authenticated user for this user.
  @override
  final String? memo;

  /// The notification setting (`normal` or `none`).
  @override
  final String? notify;

  /// Whether to include replies in the timeline.
  @override
  @JsonKey(defaultValue: false)
  final bool? withReplies;

  /// Whether two-factor authentication is enabled.
  @override
  @JsonKey(defaultValue: false)
  final bool? twoFactorEnabled;

  /// Whether passwordless login is enabled.
  @override
  @JsonKey(defaultValue: false)
  final bool? usePasswordLessLogin;

  /// Whether security keys are registered.
  @override
  @JsonKey(defaultValue: false)
  final bool? securityKeys;

  /// Whether this user has admin privileges.
  @override
  @JsonKey(defaultValue: false)
  final bool? isAdmin;

  /// Whether this user has moderator privileges.
  @override
  @JsonKey(defaultValue: false)
  final bool? isModerator;

  /// The ID of the pinned page.
  @override
  final String? pinnedPageId;

  /// The ID of the avatar drive file.
  @override
  final String? avatarId;

  /// The ID of the banner drive file.
  @override
  final String? bannerId;

  /// The message shown to users who follow this account.
  @override
  final String? followedMessage;

  /// Whether this user has opted out of web crawling.
  @override
  @JsonKey(defaultValue: false)
  final bool? noCrawle;

  /// Whether this user has opted out of AI training data collection.
  @override
  @JsonKey(defaultValue: false)
  final bool? preventAiLearning;

  /// Whether this user's online status is hidden.
  @override
  @JsonKey(defaultValue: false)
  final bool? hideOnlineStatus;

  /// Whether this user is discoverable in explore pages.
  @override
  @JsonKey(defaultValue: false)
  final bool? isExplorable;

  /// Whether this account is deleted.
  @override
  @JsonKey(defaultValue: false)
  final bool? isDeleted;

  /// Whether featured notes are injected into this user's timeline.
  @override
  @JsonKey(defaultValue: false)
  final bool? injectFeaturedNote;

  /// Whether announcement emails are sent to this user.
  @override
  @JsonKey(defaultValue: false)
  final bool? receiveAnnouncementEmail;

  /// Whether all posts from this user are always marked as NSFW.
  @override
  @JsonKey(defaultValue: false)
  final bool? alwaysMarkNsfw;

  /// Whether sensitive media detection is applied automatically.
  @override
  @JsonKey(defaultValue: false)
  final bool? autoSensitive;

  /// Whether this user is cautious of bots following them.
  @override
  @JsonKey(defaultValue: false)
  final bool? carefulBot;

  /// Whether this user automatically accepts follows back from followed users.
  @override
  @JsonKey(defaultValue: false)
  final bool? autoAcceptFollowed;

  /// The scope of who can initiate a chat with this user.
  @override
  final String? chatScope;

  /// Whether this user can use the chat feature.
  @override
  @JsonKey(defaultValue: false)
  final bool? canChat;

  /// Whether there are unread specified notes for the authenticated user.
  @override
  @JsonKey(defaultValue: false)
  final bool? hasUnreadSpecifiedNotes;

  /// Whether there are unread mentions for the authenticated user.
  @override
  @JsonKey(defaultValue: false)
  final bool? hasUnreadMentions;

  /// Whether there are unread chat messages for the authenticated user.
  @override
  @JsonKey(defaultValue: false)
  final bool? hasUnreadChatMessages;

  /// Whether there are unread announcements for the authenticated user.
  @override
  @JsonKey(defaultValue: false)
  final bool? hasUnreadAnnouncement;

  /// Whether there are unread antenna notes for the authenticated user.
  @override
  @JsonKey(defaultValue: false)
  final bool? hasUnreadAntenna;

  /// Whether there are unread channel notes for the authenticated user.
  @override
  @JsonKey(defaultValue: false)
  final bool? hasUnreadChannel;

  /// Whether there are unread notifications for the authenticated user.
  @override
  @JsonKey(defaultValue: false)
  final bool? hasUnreadNotification;

  /// Whether there is a pending received follow request for the authenticated
  /// user.
  @override
  @JsonKey(defaultValue: false)
  final bool? hasPendingReceivedFollowRequest;

  /// The count of unread notifications.
  @override
  @JsonKey(defaultValue: 0)
  final int? unreadNotificationsCount;

  /// The word-mute conditions, each represented by keywords or a regex.
  @override
  @MutedWordListConverter()
  final List<MutedWord>? mutedWords;

  /// The hard word-mute conditions, each represented by keywords or a regex.
  @override
  @MutedWordListConverter()
  final List<MutedWord>? hardMutedWords;

  /// The list of muted instance hostnames.
  @override
  final List<String>? mutedInstances;

  /// The list of notification types that are muted.
  @override
  final List<String>? mutingNotificationTypes;

  /// The per-type notification receive configuration.
  // Note: フィールド名の typo "Recieve" は Misskey API に合わせている
  @override
  final Map<String, dynamic>? notificationRecieveConfig;

  /// The list of notification types delivered via email.
  @override
  final List<String>? emailNotificationTypes;

  /// The list of achievements unlocked by this user.
  @override
  final List<Map<String, dynamic>>? achievements;

  /// The number of days this user has logged in.
  @override
  @JsonKey(defaultValue: 0)
  final int? loggedInDays;

  /// The policy map applied to this user.
  @override
  final Map<String, dynamic>? policies;

  /// The stock status of two-factor backup codes.
  @override
  final String? twoFactorBackupCodesStock;

  /// The email address of the authenticated user.
  @override
  final String? email;

  /// Whether the email address has been verified.
  @override
  @JsonKey(defaultValue: false)
  final bool? emailVerified;

  /// The moderation note attached to this user (visible to moderators only).
  @override
  final String? moderationNote;

  /// Whether this remote user is rate-limited.
  @override
  @JsonKey(defaultValue: false)
  final bool? isLimited;

  /// The mutual link sections defined on this user's profile.
  @override
  final List<Map<String, dynamic>>? mutualLinkSections;

  /// The pinned page object embedded in the user profile.
  @override
  final Map<String, dynamic>? pinnedPage;
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
  const MisskeyBadgeRole({required this.name, this.iconUrl, this.displayOrder});

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
