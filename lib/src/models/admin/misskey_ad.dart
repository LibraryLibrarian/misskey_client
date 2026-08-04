import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_ad.g.dart';

/// An advertisement (`/api/admin/ad/*` responses).
@JsonSerializable()
class MisskeyAd {
  const MisskeyAd({
    required this.id,
    this.expiresAt,
    this.startsAt,
    required this.place,
    required this.priority,
    required this.ratio,
    required this.url,
    required this.imageUrl,
    required this.memo,
    required this.dayOfWeek,
    this.isSensitive,
  });

  factory MisskeyAd.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAdFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAdToJson(this);

  /// The advertisement ID.
  final String id;

  /// The date and time when the advertisement expires.
  @SafeDateTimeConverter()
  final DateTime? expiresAt;

  /// The date and time when the advertisement starts being displayed.
  @SafeDateTimeConverter()
  final DateTime? startsAt;

  /// The display placement (`square`, `horizontal`, `horizontal-big`).
  final String place;

  /// The display priority (`high`, `middle`, `low`).
  final String priority;

  /// The display ratio used to weight this advertisement.
  final num ratio;

  /// The destination URL.
  final String url;

  /// The banner image URL.
  final String imageUrl;

  /// The memo visible only to moderators.
  final String memo;

  /// The days of the week to display on, as a bit flag (0 means every day).
  final int dayOfWeek;

  /// Whether the advertisement is marked as sensitive.
  final bool? isSensitive;
}
