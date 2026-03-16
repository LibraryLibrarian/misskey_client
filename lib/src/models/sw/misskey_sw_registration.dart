import 'package:json_annotation/json_annotation.dart';

part 'misskey_sw_registration.g.dart';

/// プッシュ通知の登録結果
@JsonSerializable(createToJson: false)
class MisskeySwRegistration {
  const MisskeySwRegistration({
    required this.state,
    required this.key,
    required this.userId,
    required this.endpoint,
    required this.sendReadMessage,
  });

  factory MisskeySwRegistration.fromJson(Map<String, dynamic> json) =>
      _$MisskeySwRegistrationFromJson(json);

  /// 登録状態（`'subscribed'` または `'already-subscribed'`）
  final String state;

  /// サーバーのVAPID公開鍵
  final String? key;

  /// サブスクリプションに紐づくユーザーID
  final String userId;

  /// プッシュ通知の送信先エンドポイントURL
  final String endpoint;

  /// 既読メッセージの通知を送信するか
  final bool sendReadMessage;

  /// 新規登録されたかどうか
  bool get isNewSubscription => state == 'subscribed';

  /// 既に登録済みだったかどうか
  bool get isAlreadySubscribed => state == 'already-subscribed';
}
