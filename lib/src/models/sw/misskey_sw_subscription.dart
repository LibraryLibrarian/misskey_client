import 'package:json_annotation/json_annotation.dart';

part 'misskey_sw_subscription.g.dart';

/// プッシュ通知のサブスクリプション情報
@JsonSerializable()
class MisskeySwSubscription {
  const MisskeySwSubscription({
    required this.userId,
    required this.endpoint,
    required this.sendReadMessage,
  });

  factory MisskeySwSubscription.fromJson(Map<String, dynamic> json) =>
      _$MisskeySwSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeySwSubscriptionToJson(this);

  /// サブスクリプションに紐づくユーザーID
  final String userId;

  /// プッシュ通知の送信先エンドポイントURL
  final String endpoint;

  /// 既読メッセージの通知を送信するか
  final bool sendReadMessage;
}
