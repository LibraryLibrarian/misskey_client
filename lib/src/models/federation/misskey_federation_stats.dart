import 'package:json_annotation/json_annotation.dart';

import 'misskey_federation_instance.dart';

part 'misskey_federation_stats.g.dart';

/// 連合統計情報（`/api/federation/stats` のレスポンス）
@JsonSerializable(createToJson: false)
class MisskeyFederationStats {
  const MisskeyFederationStats({
    required this.topSubInstances,
    required this.otherFollowersCount,
    required this.topPubInstances,
    required this.otherFollowingCount,
  });

  factory MisskeyFederationStats.fromJson(Map<String, dynamic> json) =>
      _$MisskeyFederationStatsFromJson(json);

  /// フォロワー数上位のインスタンス一覧
  final List<MisskeyFederationInstance> topSubInstances;

  /// 上位以外のフォロワー数合計
  final int otherFollowersCount;

  /// フォロー数上位のインスタンス一覧
  final List<MisskeyFederationInstance> topPubInstances;

  /// 上位以外のフォロー数合計
  final int otherFollowingCount;
}
