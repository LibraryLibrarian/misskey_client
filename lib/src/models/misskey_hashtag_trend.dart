import 'package:json_annotation/json_annotation.dart';

part 'misskey_hashtag_trend.g.dart';

/// A trending hashtag (element of the `/api/hashtags/trend` response).
@JsonSerializable()
class MisskeyHashtagTrend {
  const MisskeyHashtagTrend({
    required this.tag,
    required this.chart,
    required this.usersCount,
  });

  factory MisskeyHashtagTrend.fromJson(Map<String, dynamic> json) =>
      _$MisskeyHashtagTrendFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyHashtagTrendToJson(this);

  /// The hashtag string.
  final String tag;

  /// Recent activity chart (20 data points).
  final List<int> chart;

  /// The peak user count.
  final int usersCount;
}
