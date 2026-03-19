import '../client/misskey_http.dart';
import '../models/ap_show_result.dart';

/// Provides ActivityPub APIs (`/api/ap/*`).
///
/// Resolves ActivityPub objects from remote servers.
class ApApi {
  const ApApi({required this.http});

  final MisskeyHttp http;

  /// Resolves a user or note from an ActivityPub URI (`/api/ap/show`).
  ///
  /// Returns [ApShowUser] if the URI corresponds to a user, or [ApShowNote]
  /// if it corresponds to a note. Pass the ActivityPub URI to resolve as
  /// [uri]. Requires authentication. Rate limit: 30 per hour.
  ///
  /// Common errors:
  /// - `FEDERATION_NOT_ALLOWED`: Federation with the target host is not
  ///   allowed
  /// - `URI_INVALID`: The URI is invalid
  /// - `REQUEST_FAILED`: Request to the remote server failed
  /// - `RESPONSE_INVALID`: Response from the remote server is invalid
  /// - `NO_SUCH_OBJECT`: The object was not found
  Future<ApShowResult> show({required String uri}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/ap/show',
      body: <String, dynamic>{'uri': uri},
    );
    return ApShowResult.fromJson(res);
  }

  /// Fetches a remote ActivityPub object directly (`/api/ap/get`).
  ///
  /// Admin-only endpoint. Requires authentication. Rate limit: 30 per hour.
  /// Pass the ActivityPub URI to fetch as [uri]. Returns the raw ActivityPub
  /// object data as a Map.
  Future<Map<String, dynamic>> get({required String uri}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/ap/get',
      body: <String, dynamic>{'uri': uri},
    );
    return res;
  }
}
