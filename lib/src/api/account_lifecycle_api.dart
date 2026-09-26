import 'package:meta/meta.dart';

import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/account/misskey_email_address_availability.dart';
import '../models/account/misskey_username_availability.dart';

/// Provides unauthenticated account lifecycle APIs.
///
/// These endpoints support sign-up validation, password reset, and email
/// verification. They never attach the client's authentication token.
class AccountLifecycleApi {
  const AccountLifecycleApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Checks whether [username] can be registered
  /// (`/api/username/available`).
  ///
  /// The server also rejects preserved and previously used local usernames.
  Future<MisskeyUsernameAvailability> checkUsernameAvailability({
    required String username,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/username/available',
      body: <String, dynamic>{'username': username},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
        redactedBodyFields: {'username'},
      ),
    );
    return MisskeyUsernameAvailability.fromJson(res);
  }

  /// Checks whether [emailAddress] can be registered
  /// (`/api/email-address/available`).
  ///
  /// The nullable response reason is server-defined and may describe an
  /// existing account, invalid format, disposable address, DNS/SMTP failure,
  /// a banned domain, a network failure, or a blacklist match.
  Future<MisskeyEmailAddressAvailability> checkEmailAddressAvailability({
    required String emailAddress,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/email-address/available',
      body: <String, dynamic>{'emailAddress': emailAddress},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
        redactedBodyFields: {'emailAddress'},
      ),
    );
    return MisskeyEmailAddressAvailability.fromJson(res);
  }

  /// Requests a password-reset email for [username] and [email]
  /// (`/api/request-reset-password`).
  ///
  /// The upstream server deliberately returns success even when the account,
  /// email address, or verification state does not match, preventing account
  /// enumeration. This endpoint is limited to three requests per hour.
  Future<void> requestPasswordReset({
    required String username,
    required String email,
  }) => http.send<Object?>(
    '/request-reset-password',
    body: <String, dynamic>{'username': username, 'email': email},
    options: const RequestOptions(
      authMode: AuthMode.none,
      redactedBodyFields: {'username', 'email'},
    ),
  );

  /// Completes a password reset using the emailed [token]
  /// (`/api/reset-password`).
  ///
  /// Upstream reset tokens expire 30 minutes after issuance. Neither [token]
  /// nor [password] is written to HTTP debug logs.
  Future<void> resetPassword({
    required String token,
    required String password,
  }) => http.send<Object?>(
    '/reset-password',
    body: <String, dynamic>{'token': token, 'password': password},
    options: const RequestOptions(
      authMode: AuthMode.none,
      redactedBodyFields: {'token', 'password'},
    ),
  );

  /// Verifies an email address using its one-time [code]
  /// (`/api/verify-email`).
  ///
  /// Throws a `MisskeyApiException` with code `NO_SUCH_CODE` when the code is
  /// unknown. The code is excluded from HTTP debug logs.
  Future<void> verifyEmail({required String code}) => http.send<Object?>(
    '/verify-email',
    body: <String, dynamic>{'code': code},
    options: const RequestOptions(
      authMode: AuthMode.none,
      redactedBodyFields: {'code'},
    ),
  );
}
