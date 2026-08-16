import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';
import '../misskey_role.dart';
import '../muted_word.dart';

part 'misskey_admin_user_detail.freezed.dart';
part 'misskey_admin_user_detail.g.dart';

/// Response model for the Misskey `/api/admin/show-user` endpoint.
///
/// Contains moderation-oriented information about a user, such as
/// suspension state, sign-in history, and role assignments.
@freezed
@JsonSerializable()
class MisskeyAdminUserDetail with _$MisskeyAdminUserDetail {
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
  @override
  final String? email;

  /// Whether the email address is verified.
  @override
  final bool? emailVerified;

  /// The message shown to new followers.
  @override
  final String? followedMessage;

  /// Whether follow requests from followed users are auto-accepted.
  @override
  final bool? autoAcceptFollowed;

  /// Whether crawler indexing is rejected.
  @override
  final bool? noCrawle;

  /// Whether AI learning prevention is requested.
  @override
  final bool? preventAiLearning;

  /// Whether all posted media are marked NSFW.
  @override
  final bool? alwaysMarkNsfw;

  /// Whether automatic sensitive-media detection is enabled.
  @override
  final bool? autoSensitive;

  /// Whether the "careful bot" setting is enabled.
  @override
  final bool? carefulBot;

  /// Whether featured note injection is enabled.
  @override
  final bool? injectFeaturedNote;

  /// Whether announcement emails are received.
  @override
  final bool? receiveAnnouncementEmail;

  /// The word-mute conditions, each represented by keywords or a regex.
  @MutedWordListConverter()
  @override
  final List<MutedWord>? mutedWords;

  /// Muted instance hosts.
  @override
  final List<String>? mutedInstances;

  /// Per-type notification receive configuration.
  @JsonKey(name: 'notificationRecieveConfig')
  @override
  final Map<String, dynamic>? notificationRecieveConfig;

  /// Whether the user is a moderator.
  @override
  final bool? isModerator;

  /// Whether the user is silenced.
  @override
  final bool? isSilenced;

  /// Whether the user is suspended.
  @override
  final bool? isSuspended;

  /// Whether the user is hibernated.
  @override
  final bool? isHibernated;

  /// The last active date.
  @SafeDateTimeConverter()
  @override
  final DateTime? lastActiveDate;

  /// The moderation note visible only to moderators.
  @override
  final String? moderationNote;

  /// The sign-in history.
  @override
  final List<MisskeySignin>? signins;

  /// The effective role policies for this user.
  @override
  final Map<String, dynamic>? policies;

  /// The roles assigned to this user.
  @override
  final List<MisskeyRole>? roles;

  /// The role assignment records.
  @override
  final List<MisskeyRoleAssign>? roleAssigns;
}

/// A sign-in history record in [MisskeyAdminUserDetail].
@freezed
@JsonSerializable()
class MisskeySignin with _$MisskeySignin {
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
  @override
  final String id;

  /// The user ID.
  @override
  final String? userId;

  /// The date and time of the sign-in attempt.
  @SafeDateTimeConverter()
  @override
  final DateTime? createdAt;

  /// The client IP address.
  @override
  final String? ip;

  /// The request headers of the sign-in attempt.
  @override
  final Map<String, dynamic>? headers;

  /// Whether the sign-in succeeded.
  @override
  final bool? success;
}

/// A role assignment record in [MisskeyAdminUserDetail].
@freezed
@JsonSerializable()
class MisskeyRoleAssign with _$MisskeyRoleAssign {
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
  @override
  final String id;

  /// The date and time when the role was assigned.
  @SafeDateTimeConverter()
  @override
  final DateTime? createdAt;

  /// The expiration date of the assignment (`null` for permanent).
  @SafeDateTimeConverter()
  @override
  final DateTime? expiresAt;

  /// The assigned role ID.
  @override
  final String? roleId;
}
