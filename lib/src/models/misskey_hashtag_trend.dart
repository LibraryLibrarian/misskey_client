import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_hashtag_trend.freezed.dart';
part 'misskey_hashtag_trend.g.dart';

/// A trending hashtag (element of the `/api/hashtags/trend` response).
@freezed
@JsonSerializable()
class MisskeyHashtagTrend with _$MisskeyHashtagTrend {
  const MisskeyHashtagTrend({
    required this.tag,
    required this.chart,
    required this.usersCount,
  });

  factory MisskeyHashtagTrend.fromJson(Map<String, dynamic> json) =>
      _$MisskeyHashtagTrendFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyHashtagTrendToJson(this);

  /// The hashtag string.
  @override
  final String tag;

  /// Recent activity chart (20 data points).
  @override
  final List<int> chart;

  /// The peak user count.
  @override
  final int usersCount;
}
