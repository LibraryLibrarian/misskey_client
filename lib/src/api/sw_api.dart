import 'package:meta/meta.dart';

import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../internal/nullable_json_object.dart';
import '../models/sw/misskey_sw_registration.dart';
import '../models/sw/misskey_sw_subscription.dart';

/// Provides Service Worker push notification API endpoints.
///
/// Delegates `/api/sw/*` endpoint calls to [MisskeyHttp].
class SwApi {
  /// Creates an instance.
  @internal
  const SwApi({required this.http});

  /// HTTP client.
  @internal
  final MisskeyHttp http;

  /// Registers for push notifications (`/api/sw/register`).
  ///
  /// Returns an `already-subscribed` state if already registered
  /// with the same information.
  ///
  /// Provide the push service [endpoint] URL, the Web Push authentication
  /// secret in [auth], and the client-side VAPID public key in [publickey].
  /// Set [sendReadMessage] to `true` to also receive read message
  /// notifications (default: false).
  ///
  /// Common errors:
  /// - `INVALID_ENDPOINT`: The push service endpoint is invalid
  ///   (Misskey 2026.10.0 or later)
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
      'sendReadMessage': ?sendReadMessage,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/sw/register',
      body: body,
    );
    return MisskeySwRegistration.fromJson(res);
  }

  /// Unregisters from push notifications (`/api/sw/unregister`).
  ///
  /// Pass the endpoint URL to unregister in [endpoint]. [auth] and [publickey]
  /// are the subscription's authentication secret and public key, using the
  /// same values as [register]. They are required on Misskey 2026.10.0 and
  /// later; older servers ignore them.
  ///
  /// This endpoint does not require an access token on any supported Misskey
  /// version. Misskey 2026.10.0 and later limit it to 30 requests per hour
  /// (HTTP 429).
  ///
  /// On upstream Misskey 2026.11.0, supplying an access token restricts deletion
  /// to the authenticated user's registrations. Without a token, registrations
  /// for all accounts matching [endpoint], [auth], and [publickey] are deleted.
  /// Use a client without an access token to remove all accounts' registrations
  /// for the subscription.
  Future<void> unregister({
    required String endpoint,
    String? auth,
    String? publickey,
  }) async {
    await http.send<void>(
      '/sw/unregister',
      body: <String, dynamic>{
        'endpoint': endpoint,
        'auth': ?auth,
        'publickey': ?publickey,
      },
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
  }

  /// Checks push notification registration (`/api/sw/show-registration`).
  ///
  /// Returns `null` if the registration does not exist. Throws a
  /// [FormatException] if the server responds with anything other than a JSON
  /// object or an empty body.
  ///
  /// Pass the endpoint URL to check in [endpoint].
  Future<MisskeySwSubscription?> showRegistration({
    required String endpoint,
  }) async {
    final res = await http.send<Object?>(
      '/sw/show-registration',
      body: <String, dynamic>{'endpoint': endpoint},
      options: const RequestOptions(idempotent: true),
    );
    final json = nullableJsonObject(res, '/sw/show-registration');
    if (json == null) return null;
    return MisskeySwSubscription.fromJson(json);
  }

  /// Updates push notification registration (`/api/sw/update-registration`).
  ///
  /// Returns an error if the corresponding registration does not exist.
  ///
  /// Pass the endpoint URL of the registration to update in [endpoint].
  /// Set [sendReadMessage] to control whether read message notifications
  /// are sent.
  Future<MisskeySwSubscription> updateRegistration({
    required String endpoint,
    bool? sendReadMessage,
  }) async {
    final body = <String, dynamic>{
      'endpoint': endpoint,
      'sendReadMessage': ?sendReadMessage,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/sw/update-registration',
      body: body,
    );
    return MisskeySwSubscription.fromJson(res);
  }
}
