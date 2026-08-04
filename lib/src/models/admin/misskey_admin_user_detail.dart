import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
import '../misskey_role.dart';

part 'misskey_admin_user_detail.g.dart';

/// Response model for the Misskey `/api/admin/show-user` endpoint.
///
/// Contains moderation-oriented information about a user, such as
/// suspension state, sign-in history, and role assignments.
@JsonSerializable()
class MisskeyAdminUserDetail {
  const MisskeyAdminUserDetail({
    this.email,
    this.emailVerified,
    this.followedMessage,
    this.autoAcceptFollowed,
    this.noCrawle,
    this.preventAiLearning,
    this.alwaysMarkNsfw,
    this.autoSensitive,
    this.carefulBot,
    this.injectFeaturedNote,
    this.receiveAnnouncementEmail,
    this.mutedWords,
    this.mutedInstances,
    this.notificationRecieveConfig,
    this.isModerator,
    this.isSilenced,
    this.isSuspended,
    this.isHibernated,
    this.lastActiveDate,
    this.moderationNote,
    this.signins,
    this.policies,
    this.roles,
    this.roleAssigns,
  });

  factory MisskeyAdminUserDetail.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdminUserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdminUserDetailToJson(this);

  /// The user's email address.
  final String? email;

  /// Whether the email address is verified.
  final bool? emailVerified;

  /// The message shown to new followers.
  final String? followedMessage;

  /// Whether follow requests from followed users are auto-accepted.
  final bool? autoAcceptFollowed;

  /// Whether crawler indexing is rejected.
  final bool? noCrawle;

  /// Whether AI learning prevention is requested.
  final bool? preventAiLearning;

  /// Whether all posted media are marked NSFW.
  final bool? alwaysMarkNsfw;

  /// Whether automatic sensitive-media detection is enabled.
  final bool? autoSensitive;

  /// Whether the "careful bot" setting is enabled.
  final bool? carefulBot;

  /// Whether featured note injection is enabled.
  final bool? injectFeaturedNote;

  /// Whether announcement emails are received.
  final bool? receiveAnnouncementEmail;

  /// Muted word patterns (each entry is a string or a list of strings).
  final List<dynamic>? mutedWords;

  /// Muted instance hosts.
  final List<String>? mutedInstances;

  /// Per-type notification receive configuration.
  @JsonKey(name: 'notificationRecieveConfig')
  final Map<String, dynamic>? notificationRecieveConfig;

  /// Whether the user is a moderator.
  final bool? isModerator;

  /// Whether the user is silenced.
  final bool? isSilenced;

  /// Whether the user is suspended.
  final bool? isSuspended;

  /// Whether the user is hibernated.
  final bool? isHibernated;

  /// The last active date.
  @SafeDateTimeConverter()
  final DateTime? lastActiveDate;

  /// The moderation note visible only to moderators.
  final String? moderationNote;

  /// The sign-in history.
  final List<MisskeySignin>? signins;

  /// The effective role policies for this user.
  final Map<String, dynamic>? policies;

  /// The roles assigned to this user.
  final List<MisskeyRole>? roles;

  /// The role assignment records.
  final List<MisskeyRoleAssign>? roleAssigns;
}

/// A sign-in history record in [MisskeyAdminUserDetail].
@JsonSerializable()
class MisskeySignin {
  const MisskeySignin({
    required this.id,
    this.userId,
    this.createdAt,
    this.ip,
    this.headers,
    this.success,
  });

  factory MisskeySignin.fromJson(Map<String, dynamic> json) =>
      _$MisskeySigninFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeySigninToJson(this);

  /// The sign-in record ID.
  final String id;

  /// The user ID.
  final String? userId;

  /// The date and time of the sign-in attempt.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The client IP address.
  final String? ip;

  /// The request headers of the sign-in attempt.
  final Map<String, dynamic>? headers;

  /// Whether the sign-in succeeded.
  final bool? success;
}

/// A role assignment record in [MisskeyAdminUserDetail].
@JsonSerializable()
class MisskeyRoleAssign {
  const MisskeyRoleAssign({
    required this.id,
    this.createdAt,
    this.expiresAt,
    this.roleId,
  });

  factory MisskeyRoleAssign.fromJson(Map<String, dynamic> json) =>
      _$MisskeyRoleAssignFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyRoleAssignToJson(this);

  /// The assignment record ID.
  final String id;

  /// The date and time when the role was assigned.
  @SafeDateTimeConverter()
  final DateTime? createdAt;

  /// The expiration date of the assignment (`null` for permanent).
  @SafeDateTimeConverter()
  final DateTime? expiresAt;

  /// The assigned role ID.
  final String? roleId;
}
