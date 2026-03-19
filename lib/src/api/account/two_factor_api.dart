import '../../client/misskey_http.dart';
import '../../models/account/misskey_totp_registration.dart';

/// Provides two-factor authentication (2FA) APIs (`/api/i/2fa/*`).
///
/// Offers TOTP registration/removal, security key management, and
/// passwordless login toggle. All endpoints require authentication
/// and secure communication.
class TwoFactorApi {
  const TwoFactorApi({required this.http});

  final MisskeyHttp http;

  /// Initiates TOTP two-factor authentication registration
  /// (`/api/i/2fa/register`).
  ///
  /// Generates a TOTP secret after password verification and returns
  /// registration information including a QR code.
  /// Requires [token] if 2FA is already enabled.
  ///
  /// [password] is the current account password. [token] is an existing TOTP
  /// token and is required when 2FA is already enabled.
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

  /// Completes TOTP two-factor authentication setup (`/api/i/2fa/done`).
  ///
  /// Verifies the TOTP [token] generated from the secret obtained via
  /// [register] and enables 2FA. Returns a list of backup codes on success.
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

  /// Removes TOTP two-factor authentication (`/api/i/2fa/unregister`).
  ///
  /// [password] is the current account password. [token] is the TOTP token
  /// and is required when 2FA is enabled.
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

  /// Initiates security key registration (`/api/i/2fa/register-key`).
  ///
  /// Generates a WebAuthn registration challenge
  /// (`PublicKeyCredentialCreationOptions` equivalent). Requires 2FA to be
  /// enabled.
  ///
  /// [password] is the current account password. [token] is the TOTP token
  /// and is required when 2FA is enabled.
  ///
  /// Returns a Map equivalent to WebAuthn's
  /// `PublicKeyCredentialCreationOptions`, containing `rp`, `user`,
  /// `challenge`, `pubKeyCredParams`, etc.
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

  /// Completes security key registration (`/api/i/2fa/key-done`).
  ///
  /// Verifies the client response to the challenge obtained via [registerKey]
  /// and registers the security key.
  ///
  /// [password] is the current account password. [name] is the key name
  /// (1-30 characters). [credential] is the WebAuthn response object.
  /// [token] is the TOTP token and is required when 2FA is enabled.
  ///
  /// Returns a Map containing the registered key's `id` and `name`.
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

  /// Removes a security key (`/api/i/2fa/remove-key`).
  ///
  /// [password] is the current account password. [credentialId] is the ID of
  /// the key to remove. [token] is the TOTP token and is required when 2FA is
  /// enabled.
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

  /// Updates the name of a security key (`/api/i/2fa/update-key`).
  ///
  /// [credentialId] identifies the target key. [name] is the new key name
  /// (1-30 characters).
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

  /// Toggles passwordless login (`/api/i/2fa/password-less`).
  ///
  /// Requires a security key to be registered. Pass `true` for [value] to
  /// enable passwordless login, or `false` to disable it.
  Future<void> passwordLess({required bool value}) => http.send<Object?>(
        '/i/2fa/password-less',
        body: <String, dynamic>{'value': value},
      );
}
