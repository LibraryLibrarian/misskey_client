import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_federation_instance.freezed.dart';
part 'misskey_federation_instance.g.dart';

/// A federated instance (response from `/api/federation/instances`, etc.).
@freezed
@JsonSerializable()
class MisskeyFederationInstance with _$MisskeyFederationInstance {
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
  @override
  final String id;

  /// The date and time when this instance was first retrieved.
  @override
  final DateTime firstRetrievedAt;

  /// The hostname of the instance.
  @override
  final String host;

  /// The number of users on the instance.
  @override
  final int? usersCount;

  /// The number of notes on the instance.
  @override
  final int? notesCount;

  /// The number of users being followed from this instance.
  @override
  final int? followingCount;

  /// The number of followers from this instance.
  @override
  final int? followersCount;

  /// Whether the instance is not responding.
  @override
  final bool? isNotResponding;

  /// Whether the instance is suspended.
  @override
  final bool? isSuspended;

  /// The granular suspension state (e.g. `none`, `manuallySuspended`).
  @override
  final String? suspensionState;

  /// Whether the instance is blocked.
  @override
  final bool? isBlocked;

  /// Whether the instance is silenced.
  @override
  final bool? isSilenced;

  /// Whether the instance is marked as serving sensitive media
  /// (older API versions).
  @JsonKey(defaultValue: false)
  @override
  final bool? isSensitiveMedia;

  /// Whether the instance's media is silenced (newer API versions,
  /// replaces [isSensitiveMedia]).
  @JsonKey(defaultValue: false)
  @override
  final bool? isMediaSilenced;

  /// The software name (e.g., `misskey`, `mastodon`).
  @override
  final String? softwareName;

  /// The software version.
  @override
  final String? softwareVersion;

  /// Whether user registration is open.
  @override
  final bool? openRegistrations;

  /// The instance name.
  @override
  final String? name;

  /// The instance description.
  @override
  final String? description;

  /// The maintainer name.
  @override
  final String? maintainerName;

  /// The maintainer email address.
  @override
  final String? maintainerEmail;

  /// The icon URL.
  @override
  final String? iconUrl;

  /// The favicon URL.
  @override
  final String? faviconUrl;

  /// The theme color.
  @override
  final String? themeColor;

  /// The date and time when instance information was last updated.
  @override
  final DateTime? infoUpdatedAt;

  /// The date and time of the last received request.
  @override
  final DateTime? latestRequestReceivedAt;

  /// The moderation note attached to this instance
  /// (visible to moderators only).
  @override
  final String? moderationNote;
}
