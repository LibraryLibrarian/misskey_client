import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/admin/misskey_relay.dart';

/// Provides relay management admin APIs (`/api/admin/relays/*`).
///
/// All endpoints require administrator privileges.
class AdminRelaysApi {
  const AdminRelaysApi({required this.http});

  final MisskeyHttp http;

  /// Subscribes to a relay (`/api/admin/relays/add`).
  ///
  /// Pass the relay's inbox URL (e.g. `https://relay.example.com/inbox`)
  /// in [inbox]. The subscription starts in the `requesting` state until
  /// the relay accepts it.
  ///
  /// Common errors:
  /// - `INVALID_URL`: The inbox URL is invalid
  Future<MisskeyRelay> add({required String inbox}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/relays/add',
      body: <String, dynamic>{'inbox': inbox},
    );
    return MisskeyRelay.fromJson(res);
  }

  /// Fetches the list of relays (`/api/admin/relays/list`).
  Future<List<MisskeyRelay>> list() async {
    final res = await http.send<List<dynamic>>(
      '/admin/relays/list',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRelay.fromJson)
        .toList();
  }

  /// Unsubscribes from a relay (`/api/admin/relays/remove`).
  ///
  /// Pass the relay's inbox URL in [inbox].
  Future<void> remove({required String inbox}) => http.send<Object?>(
        '/admin/relays/remove',
        body: <String, dynamic>{'inbox': inbox},
      );
}
