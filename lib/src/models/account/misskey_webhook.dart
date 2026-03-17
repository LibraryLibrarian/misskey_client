import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_webhook.g.dart';

/// ユーザーWebhook
@JsonSerializable()
class MisskeyWebhook {
  const MisskeyWebhook({
    required this.id,
    required this.userId,
    required this.name,
    required this.on,
    required this.url,
    required this.secret,
    required this.active,
    this.latestSentAt,
    this.latestStatus,
  });

  factory MisskeyWebhook.fromJson(Map<String, dynamic> json) =>
      _$MisskeyWebhookFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyWebhookToJson(this);

  /// Webhook ID
  final String id;

  /// 所有者のユーザーID
  final String userId;

  /// Webhook名
  final String name;

  /// 購読するイベントタイプ
  ///
  /// 有効な値: `mention`, `unfollow`, `follow`, `followed`,
  /// `note`, `reply`, `renote`, `reaction`
  final List<String> on;

  /// 送信先URL
  final String url;

  /// シークレット
  final String secret;

  /// 有効/無効
  final bool active;

  /// 最終送信日時
  @SafeDateTimeConverter()
  final DateTime? latestSentAt;

  /// 最終送信時のHTTPステータスコード
  final int? latestStatus;
}
