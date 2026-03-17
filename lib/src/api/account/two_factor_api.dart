import '../../client/misskey_http.dart';
import '../../models/account/misskey_totp_registration.dart';

/// 二要素認証（2FA）関連API（`/api/i/2fa/*`）
///
/// TOTP登録・解除やセキュリティキーの管理、
/// パスワードレスログインの切り替えを提供する。
/// 全エンドポイントで認証必須かつセキュア通信が求められる。
class TwoFactorApi {
  const TwoFactorApi({required this.http});

  final MisskeyHttp http;

  /// TOTP二要素認証の登録を開始する（`/api/i/2fa/register`）
  ///
  /// パスワード検証後、TOTPシークレットを生成して
  /// QRコード等の登録情報を返す。
  /// 既に2FAが有効な場合は [token] が必要。
  ///
  /// - [password]: 現在のパスワード（必須）
  /// - [token]: 既存のTOTPトークン（2FA有効時に必要）
  Future<MisskeyTotpRegistration> register({
    required String password,
    String? token,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/2fa/register',
      body: <String, dynamic>{
        'password': password,
        if (token != null) 'token': token,
      },
    );
    return MisskeyTotpRegistration.fromJson(res);
  }

  /// TOTP二要素認証の設定を完了する（`/api/i/2fa/done`）
  ///
  /// [register] で取得したシークレットを基に生成したTOTPトークンで
  /// 検証を行い、2FAを有効化する。
  /// 成功するとバックアップコードの一覧を返す。
  ///
  /// - [token]: TOTPトークン（必須）
  Future<List<String>> done({required String token}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/2fa/done',
      body: <String, dynamic>{'token': token},
    );
    final codes = res['backupCodes'];
    if (codes is List) {
      return codes.cast<String>();
    }
    return <String>[];
  }

  /// TOTP二要素認証を解除する（`/api/i/2fa/unregister`）
  ///
  /// - [password]: 現在のパスワード（必須）
  /// - [token]: TOTPトークン（2FA有効時に必要）
  Future<void> unregister({
    required String password,
    String? token,
  }) =>
      http.send<Object?>(
        '/i/2fa/unregister',
        body: <String, dynamic>{
          'password': password,
          if (token != null) 'token': token,
        },
      );

  /// セキュリティキーの登録を開始する（`/api/i/2fa/register-key`）
  ///
  /// WebAuthn登録チャレンジ（`PublicKeyCredentialCreationOptions`相当）
  /// を生成して返す。2FAが有効であることが前提。
  ///
  /// - [password]: 現在のパスワード（必須）
  /// - [token]: TOTPトークン（2FA有効時に必要）
  ///
  /// 返り値はWebAuthnの`PublicKeyCredentialCreationOptions`相当のMapで、
  /// `rp`, `user`, `challenge`, `pubKeyCredParams` 等を含む。
  Future<Map<String, dynamic>> registerKey({
    required String password,
    String? token,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/2fa/register-key',
      body: <String, dynamic>{
        'password': password,
        if (token != null) 'token': token,
      },
    );
    return res;
  }

  /// セキュリティキーの登録を完了する（`/api/i/2fa/key-done`）
  ///
  /// [registerKey] で得たチャレンジに対するクライアント応答を検証し、
  /// セキュリティキーを登録する。
  ///
  /// - [password]: 現在のパスワード（必須）
  /// - [name]: キーの名前（必須、1〜30文字）
  /// - [credential]: WebAuthn応答オブジェクト（必須）
  /// - [token]: TOTPトークン（2FA有効時に必要）
  ///
  /// 返り値は登録されたキーの `id` と `name` を含むMap。
  Future<Map<String, dynamic>> keyDone({
    required String password,
    required String name,
    required Map<String, dynamic> credential,
    String? token,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/2fa/key-done',
      body: <String, dynamic>{
        'password': password,
        'name': name,
        'credential': credential,
        if (token != null) 'token': token,
      },
    );
    return res;
  }

  /// セキュリティキーを削除する（`/api/i/2fa/remove-key`）
  ///
  /// - [password]: 現在のパスワード（必須）
  /// - [credentialId]: 削除対象キーのID（必須）
  /// - [token]: TOTPトークン（2FA有効時に必要）
  Future<void> removeKey({
    required String password,
    required String credentialId,
    String? token,
  }) =>
      http.send<Object?>(
        '/i/2fa/remove-key',
        body: <String, dynamic>{
          'password': password,
          'credentialId': credentialId,
          if (token != null) 'token': token,
        },
      );

  /// セキュリティキーの名前を更新する（`/api/i/2fa/update-key`）
  ///
  /// - [credentialId]: 対象キーのID（必須）
  /// - [name]: 新しいキー名（1〜30文字）
  Future<void> updateKey({
    required String credentialId,
    String? name,
  }) =>
      http.send<Object?>(
        '/i/2fa/update-key',
        body: <String, dynamic>{
          'credentialId': credentialId,
          if (name != null) 'name': name,
        },
      );

  /// パスワードレスログインの有効/無効を切り替える（`/api/i/2fa/password-less`）
  ///
  /// セキュリティキーが登録済みであることが前提。
  ///
  /// - [value]: `true`で有効化、`false`で無効化
  Future<void> passwordLess({required bool value}) => http.send<Object?>(
        '/i/2fa/password-less',
        body: <String, dynamic>{'value': value},
      );
}
