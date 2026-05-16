import 'package:json_annotation/json_annotation.dart';

part 'misskey_federation_instance.g.dart';

/// A federated instance (response from `/api/federation/instances`, etc.).
@JsonSerializable()
class MisskeyFederationInstance {
  const MisskeyFederationInstance({
    required this.id,
    required this.firstRetrievedAt,
    required this.host,
    this.usersCount,
    this.notesCount,
    this.followingCount,
    this.followersCount,
    this.isNotResponding,
    this.isSuspended,
    this.suspensionState,
    this.isBlocked,
    this.isSilenced,
    this.isSensitiveMedia,
    this.isMediaSilenced,
    this.softwareName,
    this.softwareVersion,
    this.openRegistrations,
    this.name,
    this.description,
    this.maintainerName,
    this.maintainerEmail,
    this.iconUrl,
    this.faviconUrl,
    this.themeColor,
    this.infoUpdatedAt,
    this.latestRequestReceivedAt,
    this.moderationNote,
  });

  factory MisskeyFederationInstance.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFederationInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFederationInstanceToJson(this);

  /// The instance ID.
  final String id;

  /// The date and time when this instance was first retrieved.
  final DateTime firstRetrievedAt;

  /// The hostname of the instance.
  final String host;

  /// The number of users on the instance.
  final int? usersCount;

  /// The number of notes on the instance.
  final int? notesCount;

  /// The number of users being followed from this instance.
  final int? followingCount;

  /// The number of followers from this instance.
  final int? followersCount;

  /// Whether the instance is not responding.
  final bool? isNotResponding;

  /// Whether the instance is suspended.
  final bool? isSuspended;

  /// The granular suspension state (e.g. `none`, `manuallySuspended`).
  final String? suspensionState;

  /// Whether the instance is blocked.
  final bool? isBlocked;

  /// Whether the instance is silenced.
  final bool? isSilenced;

  /// Whether the instance is marked as serving sensitive media
  /// (older API versions).
  @JsonKey(defaultValue: false)
  final bool? isSensitiveMedia;

  /// Whether the instance's media is silenced (newer API versions,
  /// replaces [isSensitiveMedia]).
  @JsonKey(defaultValue: false)
  final bool? isMediaSilenced;

  /// The software name (e.g., `misskey`, `mastodon`).
  final String? softwareName;

  /// The software version.
  final String? softwareVersion;

  /// Whether user registration is open.
  final bool? openRegistrations;

  /// The instance name.
  final String? name;

  /// The instance description.
  final String? description;

  /// The maintainer name.
  final String? maintainerName;

  /// The maintainer email address.
  final String? maintainerEmail;

  /// The icon URL.
  final String? iconUrl;

  /// The favicon URL.
  final String? faviconUrl;

  /// The theme color.
  final String? themeColor;

  /// The date and time when instance information was last updated.
  final DateTime? infoUpdatedAt;

  /// The date and time of the last received request.
  final DateTime? latestRequestReceivedAt;

  /// The moderation note attached to this instance
  /// (visible to moderators only).
  final String? moderationNote;
}
