import '../misskey_user.dart';

/// Response model for the Misskey `/api/admin/accounts/create` endpoint.
///
/// The response is the created user object (`MeDetailed`) with an
/// additional `token` field containing the account's API token.
class MisskeyAdminCreatedAccount {
  const MisskeyAdminCreatedAccount({required this.user, required this.token});

  /// Creates an instance from the raw response JSON.
  factory MisskeyAdminCreatedAccount.fromJson(Map<String, dynamic> json) =>
      MisskeyAdminCreatedAccount(
        user: MisskeyUser.fromJson(json),
        token: json['token'] as String,
      );

  /// The created user.
  final MisskeyUser user;

  /// The API token (`i`) for the created account.
  final String token;
}
