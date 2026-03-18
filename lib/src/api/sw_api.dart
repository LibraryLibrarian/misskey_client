import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/sw/misskey_sw_registration.dart';
import '../models/sw/misskey_sw_subscription.dart';

/// Provides Service Worker push notification API endpoints.
///
/// Delegates `/api/sw/*` endpoint calls to [MisskeyHttp].
class SwApi {
  /// Creates an instance.
  const SwApi({required this.http});

  /// HTTP client.
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

  /// Unregisters from push notifications (`/api/sw/unregister`).
  ///
  /// Pass the endpoint URL to unregister in [endpoint].
  Future<void> unregister({required String endpoint}) async {
    await http.send<void>(
      '/sw/unregister',
      body: <String, dynamic>{
        'endpoint': endpoint,
      },
      options: const RequestOptions(idempotent: true),
    );
  }

  /// Checks push notification registration (`/api/sw/show-registration`).
  ///
  /// Returns `null` if the registration does not exist.
  ///
  /// Pass the endpoint URL to check in [endpoint].
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
      if (sendReadMessage != null) 'sendReadMessage': sendReadMessage,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/sw/update-registration',
      body: body,
    );
    return MisskeySwSubscription.fromJson(res);
  }
}
