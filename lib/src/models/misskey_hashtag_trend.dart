import 'package:json_annotation/json_annotation.dart';

part 'misskey_hashtag_trend.g.dart';

/// トレンドハッシュタグ（`/api/hashtags/trend` のレスポンス要素）
@JsonSerializable(createToJson: false)
class MisskeyHashtagTrend {
  const MisskeyHashtagTrend({
    required this.tag,
    required this.chart,
    required this.usersCount,
  });

  factory MisskeyHashtagTrend.fromJson(Map<String, dynamic> json) =>
      _$MisskeyHashtagTrendFromJson(json);

  /// ハッシュタグ文字列
  final String tag;

  /// 直近のアクティビティ推移（データポイント数20）
  final List<int> chart;

  /// ピーク時のユーザー数
  final int usersCount;
}
