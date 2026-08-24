import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_federation_instance.dart';

part 'misskey_federation_stats.freezed.dart';
part 'misskey_federation_stats.g.dart';

/// Federation statistics (response from `/api/federation/stats`).
@freezed
@JsonSerializable()
class MisskeyFederationStats with _$MisskeyFederationStats {
  const MisskeyFederationStats({
    required this.topSubInstances,
    required this.otherFollowersCount,
    required this.topPubInstances,
    required this.otherFollowingCount,
  });

  factory MisskeyFederationStats.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFederationStatsFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyFederationStatsToJson(this);

  /// The instances with the most followers.
  @override
  final List<MisskeyFederationInstance> topSubInstances;

  /// The total follower count from instances outside the top list.
  @override
  final int otherFollowersCount;

  /// The instances with the most following.
  @override
  final List<MisskeyFederationInstance> topPubInstances;

  /// The total following count from instances outside the top list.
  @override
  final int otherFollowingCount;
}
