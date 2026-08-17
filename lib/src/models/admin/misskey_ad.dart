import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_ad.freezed.dart';
part 'misskey_ad.g.dart';

/// An advertisement (`/api/admin/ad/*` responses).
@freezed
@JsonSerializable()
class MisskeyAd with _$MisskeyAd {
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
  @override
  final String id;

  /// The date and time when the advertisement expires.
  @SafeDateTimeConverter()
  @override
  final DateTime? expiresAt;

  /// The date and time when the advertisement starts being displayed.
  @SafeDateTimeConverter()
  @override
  final DateTime? startsAt;

  /// The display placement (`square`, `horizontal`, `horizontal-big`).
  @override
  final String place;

  /// The display priority (`high`, `middle`, `low`).
  @override
  final String priority;

  /// The display ratio used to weight this advertisement.
  @override
  final num ratio;

  /// The destination URL.
  @override
  final String url;

  /// The banner image URL.
  @override
  final String imageUrl;

  /// The memo visible only to moderators.
  @override
  final String memo;

  /// The days of the week to display on, as a bit flag (0 means every day).
  @override
  final int dayOfWeek;

  /// Whether the advertisement is marked as sensitive.
  @override
  final bool? isSensitive;
}
