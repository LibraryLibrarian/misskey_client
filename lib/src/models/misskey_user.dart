import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';
import 'misskey_note.dart';

part 'misskey_user.g.dart';

/// ユーザーのオンライン状態
@JsonEnum()
enum MisskeyOnlineStatus {
  unknown,
  online,
  active,
  offline,
}

/// Misskey ユーザー（UserLite + UserDetailed の統合モデル）
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

  final String id;
  final String username;

  @JsonKey(defaultValue: '')
  final String? name;

  /// リモートユーザーの場合のホスト名。ローカルユーザーは null
  final String? host;

  final String? avatarUrl;
  final String? avatarBlurhash;

  @JsonKey(defaultValue: false)
  final bool? isBot;

  @JsonKey(defaultValue: false)
  final bool? isCat;

  @JsonKey(defaultValue: <String, String>{})
  final Map<String, String>? emojis;

  @JsonKey(unknownEnumValue: MisskeyOnlineStatus.unknown)
  final MisskeyOnlineStatus? onlineStatus;

  // UserDetailed fields (nullable: may not be present in UserLite)

  @SafeDateTimeConverter()
  final DateTime? createdAt;

  final String? description;

  @JsonKey(defaultValue: 0)
  final int? followersCount;

  @JsonKey(defaultValue: 0)
  final int? followingCount;

  @JsonKey(defaultValue: 0)
  final int? notesCount;

  @JsonKey(defaultValue: false)
  final bool? isLocked;

  @JsonKey(defaultValue: false)
  final bool? isSuspended;

  @JsonKey(defaultValue: false)
  final bool? isSilenced;

  final List<String>? pinnedNoteIds;
  final List<MisskeyNote>? pinnedNotes;

  final String? bannerUrl;
  final String? bannerBlurhash;

  @JsonKey(defaultValue: <MisskeyUserField>[])
  final List<MisskeyUserField>? fields;

  // --- Relation fields (present only with authenticated request) ---
  final bool? isFollowing;
  final bool? isFollowed;
  final bool? hasPendingFollowRequestFromYou;
  final bool? hasPendingFollowRequestToYou;
  final bool? isBlocking;
  final bool? isBlocked;
  final bool? isMuted;
  final bool? isRenoteMuted;

  final List<MisskeyAvatarDecoration>? avatarDecorations;

  // --- UserLite additional fields ---

  @JsonKey(defaultValue: false)
  final bool? requireSigninToViewContents;

  final int? makeNotesFollowersOnlyBefore;
  final int? makeNotesHiddenBefore;

  /// リモートユーザーのインスタンス情報
  final MisskeyUserInstance? instance;

  final List<MisskeyBadgeRole>? badgeRoles;

  // --- UserDetailedNotMeOnly fields ---

  final String? url;
  final String? uri;
  final String? movedTo;
  final List<String>? alsoKnownAs;

  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  @SafeDateTimeConverter()
  final DateTime? lastFetchedAt;

  final String? location;

  /// 誕生日 (YYYY-MM-DD 形式)
  final String? birthday;

  final String? lang;
  final List<String>? verifiedLinks;

  @JsonKey(defaultValue: false)
  final bool? publicReactions;

  /// public, followers, private
  final String? followingVisibility;

  /// public, followers, private
  final String? followersVisibility;

  final List<MisskeyRoleLite>? roles;

  final String? memo;

  /// normal or none
  final String? notify;

  @JsonKey(defaultValue: false)
  final bool? withReplies;

  @JsonKey(defaultValue: false)
  final bool? twoFactorEnabled;

  @JsonKey(defaultValue: false)
  final bool? usePasswordLessLogin;

  @JsonKey(defaultValue: false)
  final bool? securityKeys;
}

/// プロフィールフィールド
@JsonSerializable()
class MisskeyUserField {
  const MisskeyUserField({required this.name, required this.value});

  factory MisskeyUserField.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserFieldFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserFieldToJson(this);

  final String name;
  final String value;
}

/// アバターデコレーション
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

  final String id;
  final double? angle;
  final bool? flipH;
  final String url;
  final double? offsetX;
  final double? offsetY;
}

/// リモートユーザーのインスタンス情報
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

  final String? name;
  final String? softwareName;
  final String? softwareVersion;
  final String? iconUrl;
  final String? faviconUrl;
  final String? themeColor;
}

/// バッジロール
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

  final String name;
  final String? iconUrl;

  @JsonKey(defaultValue: 0)
  final int? displayOrder;
}

/// ロール（簡易版）
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

  final String id;
  final String name;
  final String? color;
  final String? iconUrl;
  final String? description;

  @JsonKey(defaultValue: false)
  final bool? isModerator;

  @JsonKey(defaultValue: false)
  final bool? isAdministrator;

  @JsonKey(defaultValue: 0)
  final int? displayOrder;
}
