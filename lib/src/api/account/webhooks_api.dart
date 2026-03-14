import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../models/account/misskey_webhook.dart';

/// Webhook管理API（`/api/i/webhooks/*`）
///
/// ユーザーWebhookの作成・取得・更新・削除・テスト送信を提供する。
class WebhooksApi {
  const WebhooksApi({required this.http});

  final MisskeyHttp http;

  /// Webhookを新規作成する（`/api/i/webhooks/create`）
  ///
  /// - [name]: Webhook名（必須、1〜100文字）
  /// - [url]: 送信先URL（必須、1〜1024文字）
  /// - [secret]: シークレット（最大1024文字、デフォルト空文字）
  /// - [on]: 購読するイベントタイプ（必須）
  ///   有効な値: `mention`, `unfollow`, `follow`, `followed`,
  ///   `note`, `reply`, `renote`, `reaction`
  ///
  /// ロールポリシーで定められた上限を超えると `TOO_MANY_WEBHOOKS` エラーになる。
  Future<MisskeyWebhook> create({
    required String name,
    required String url,
    required List<String> on,
    String? secret,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'url': url,
      'on': on,
      if (secret != null) 'secret': secret,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/i/webhooks/create',
      body: body,
    );
    return MisskeyWebhook.fromJson(res);
  }

  /// Webhook一覧を取得する（`/api/i/webhooks/list`）
  ///
  /// 認証ユーザーが所有する全Webhookを返す。
  Future<List<MisskeyWebhook>> list() async {
    final res = await http.send<List<dynamic>>(
      '/i/webhooks/list',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyWebhook.fromJson)
        .toList();
  }

  /// Webhookの詳細を取得する（`/api/i/webhooks/show`）
  ///
  /// [webhookId] で対象のWebhookを指定する。
  /// 存在しないまたは自分のものでない場合は `NO_SUCH_WEBHOOK` エラーになる。
  Future<MisskeyWebhook> show({required String webhookId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/webhooks/show',
      body: <String, dynamic>{'webhookId': webhookId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyWebhook.fromJson(res);
  }

  /// Webhookを更新する（`/api/i/webhooks/update`）
  ///
  /// - [webhookId]: 更新対象のWebhook ID（必須）
  /// - [name]: Webhook名（1〜100文字）
  /// - [url]: 送信先URL（1〜1024文字）
  /// - [secret]: シークレット（最大1024文字、`Optional.null_()`でリセット）
  /// - [on]: 購読するイベントタイプ
  /// - [active]: 有効/無効の切り替え
  ///
  /// 存在しないまたは自分のものでない場合は `NO_SUCH_WEBHOOK` エラーになる。
  Future<void> update({
    required String webhookId,
    String? name,
    String? url,
    Optional<String>? secret,
    List<String>? on,
    bool? active,
  }) {
    final body = <String, dynamic>{
      'webhookId': webhookId,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (on != null) 'on': on,
      if (active != null) 'active': active,
    };
    if (secret case Some<String>(:final value)) {
      body['secret'] = value;
    }
    return http.send<Object?>(
      '/i/webhooks/update',
      body: body,
    );
  }

  /// Webhookを削除する（`/api/i/webhooks/delete`）
  ///
  /// [webhookId] で対象のWebhookを指定する。
  /// 存在しないまたは自分のものでない場合は `NO_SUCH_WEBHOOK` エラーになる。
  Future<void> delete({required String webhookId}) => http.send<Object?>(
        '/i/webhooks/delete',
        body: <String, dynamic>{'webhookId': webhookId},
      );

  /// Webhookのテスト送信を行う（`/api/i/webhooks/test`）
  ///
  /// 指定したWebhookに対してテストイベントを送信する。
  /// レートリミット: 15分間に60回まで。
  ///
  /// - [webhookId]: 対象のWebhook ID（必須）
  /// - [type]: テスト送信するイベントタイプ（必須）
  ///   有効な値: `mention`, `unfollow`, `follow`, `followed`,
  ///   `note`, `reply`, `renote`, `reaction`
  /// - [override]: テスト用の一時的な設定上書き
  ///   `url` と `secret` を一時的に変更してテストできる
  Future<void> test({
    required String webhookId,
    required String type,
    Map<String, String>? override,
  }) =>
      http.send<Object?>(
        '/i/webhooks/test',
        body: <String, dynamic>{
          'webhookId': webhookId,
          'type': type,
          if (override != null) 'override': override,
        },
      );
}
