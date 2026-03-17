import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';

part 'misskey_announcement.g.dart';

/// サーバーのお知らせ（`/api/announcements` のレスポンス要素）
@JsonSerializable()
class MisskeyAnnouncement {
  const MisskeyAnnouncement({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.text,
    required this.icon,
    required this.display,
    this.updatedAt,
    this.imageUrl,
    this.needConfirmationToRead = false,
    this.silence = false,
    this.forYou = false,
    this.isRead,
  });

  factory MisskeyAnnouncement.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAnnouncementToJson(this);

  final String id;

  @SafeDateTimeConverter()
  final DateTime createdAt;

  @SafeDateTimeConverter()
  final DateTime? updatedAt;

  /// お知らせのタイトル
  final String title;

  /// お知らせの本文
  final String text;

  /// 画像URL
  final String? imageUrl;

  /// アイコン種別（`info` / `warning` / `error` / `success`）
  final String icon;

  /// 表示方法（`dialog` / `normal` / `banner`）
  final String display;

  /// 既読確認が必要か
  @JsonKey(defaultValue: false)
  final bool needConfirmationToRead;

  /// サイレント（通知なし）か
  @JsonKey(defaultValue: false)
  final bool silence;

  /// 自分宛てのお知らせか
  @JsonKey(defaultValue: false)
  final bool forYou;

  /// 既読かどうか（認証時のみ返却される）
  final bool? isRead;
}
