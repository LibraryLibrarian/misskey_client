import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/sw/misskey_sw_registration.dart';
import '../models/sw/misskey_sw_subscription.dart';

/// Service Worker プッシュ通知関連API
///
/// `/api/sw/*` エンドポイントを [MisskeyHttp] に委譲して呼び出す
class SwApi {
  /// コンストラクタ
  const SwApi({required this.http});

  /// HTTPクライアント
  final MisskeyHttp http;

  /// プッシュ通知を受信するための登録を行う（`/api/sw/register`）
  ///
  /// 既に同じ情報で登録済みの場合は `already-subscribed` 状態を返す。
  ///
  /// - [endpoint]: プッシュサービスのエンドポイントURL
  /// - [auth]: Web Push認証シークレット
  /// - [publickey]: クライアント側のVAPID公開鍵
  /// - [sendReadMessage]: 既読メッセージの通知も受信するか（デフォルト: false）
  Future<MisskeySwRegistration> register({
    required String endpoint,
    required String auth,
    required String publickey,
    bool? sendReadMessage,
  }) async {
    final body = <String, dynamic>{
      'endpoint': endpoint,
      'auth': auth,
      'publickey': publickey,
      if (sendReadMessage != null) 'sendReadMessage': sendReadMessage,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/sw/register',
      body: body,
    );
    return MisskeySwRegistration.fromJson(res);
  }

  /// プッシュ通知の登録を解除する（`/api/sw/unregister`）
  ///
  /// - [endpoint]: 登録解除するエンドポイントURL
  Future<void> unregister({required String endpoint}) async {
    await http.send<void>(
      '/sw/unregister',
      body: <String, dynamic>{
        'endpoint': endpoint,
      },
      options: const RequestOptions(idempotent: true),
    );
  }

  /// プッシュ通知の登録情報を確認する（`/api/sw/show-registration`）
  ///
  /// 登録が存在しない場合は `null` を返す。
  ///
  /// - [endpoint]: 確認するエンドポイントURL
  Future<MisskeySwSubscription?> showRegistration({
    required String endpoint,
  }) async {
    final res = await http.send<Map<String, dynamic>?>(
      '/sw/show-registration',
      body: <String, dynamic>{
        'endpoint': endpoint,
      },
      options: const RequestOptions(idempotent: true),
    );
    if (res == null) return null;
    return MisskeySwSubscription.fromJson(res);
  }

  /// プッシュ通知の登録情報を更新する（`/api/sw/update-registration`）
  ///
  /// 該当する登録が存在しない場合はエラーとなる。
  ///
  /// - [endpoint]: 更新対象のエンドポイントURL
  /// - [sendReadMessage]: 既読メッセージの通知を送信するか
  Future<MisskeySwSubscription> updateRegistration({
    required String endpoint,
    bool? sendReadMessage,
  }) async {
    final body = <String, dynamic>{
      'endpoint': endpoint,
      if (sendReadMessage != null) 'sendReadMessage': sendReadMessage,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/sw/update-registration',
      body: body,
    );
    return MisskeySwSubscription.fromJson(res);
  }
}
