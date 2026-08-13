import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';
import '../../models/admin/misskey_admin_created_account.dart';
import '../../models/misskey_user.dart';

/// Provides account management admin APIs (`/api/admin/accounts/*`).
class AdminAccountsApi {
  const AdminAccountsApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Creates a new local account (`/api/admin/accounts/create`).
  ///
  /// On a freshly set-up instance with no users this endpoint can be
  /// called without authentication and creates the initial administrator.
  /// Afterwards it requires administrator privileges. The response
  /// includes the new account's API token.
  ///
  /// [username] and [password] are required. [setupPassword] is only
  /// used during initial setup when the instance is configured with
  /// `setupPassword`.
  ///
  /// Common errors:
  /// - `ACCESS_DENIED`: Not permitted to create accounts
  /// - `INVALID_PARAM`: The username or password is invalid
  Future<MisskeyAdminCreatedAccount> create({
    required String username,
    required String password,
    String? setupPassword,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/accounts/create',
      body: <String, dynamic>{
        'username': username,
        'password': password,
        'setupPassword': ?setupPassword,
      },
    );
    return MisskeyAdminCreatedAccount.fromJson(res);
  }

  /// Deletes an account (`/api/admin/accounts/delete`).
  ///
  /// Requires administrator privileges. Pass the target user ID in
  /// [userId]. The deletion is processed asynchronously on the server.
  Future<void> delete({required String userId}) => http.send<Object?>(
    '/admin/accounts/delete',
    body: <String, dynamic>{'userId': userId},
  );

  /// Finds a local user by email address
  /// (`/api/admin/accounts/find-by-email`).
  ///
  /// Requires administrator privileges.
  ///
  /// Common errors:
  /// - `USER_NOT_FOUND`: No user has the specified email address
  Future<MisskeyUser> findByEmail({required String email}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/accounts/find-by-email',
      body: <String, dynamic>{'email': email},
    );
    return MisskeyUser.fromJson(res);
  }
}
