import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/account/misskey_registry_detail.dart';
import '../../models/account/misskey_registry_scope.dart';

/// Provides registry APIs (`/api/i/registry/*`).
///
/// Operates a key-value store for client settings and similar data.
/// All endpoints require authentication.
class RegistryApi {
  const RegistryApi({required this.http});

  final MisskeyHttp http;

  /// Retrieves the value of a specific key (`/api/i/registry/get`).
  ///
  /// [key] specifies the registry key name. [scope] is the scope array and
  /// defaults to empty. [domain] defaults to the access token's domain.
  ///
  /// Throws a `NO_SUCH_KEY` error from the server if the key does not exist.
  Future<dynamic> get({
    required String key,
    List<String> scope = const <String>[],
    String? domain,
  }) =>
      http.send<dynamic>(
        '/i/registry/get',
        body: <String, dynamic>{
          'key': key,
          'scope': scope,
          if (domain != null) 'domain': domain,
        },
        options: const RequestOptions(idempotent: true),
      );

  /// Retrieves all key-value pairs within a scope
  /// (`/api/i/registry/get-all`).
  ///
  /// [scope] is the scope array and defaults to empty. [domain] defaults to
  /// the access token's domain.
  ///
  /// Returns a Map with key names as keys and registry values as values.
  Future<Map<String, dynamic>> getAll({
    List<String> scope = const <String>[],
    String? domain,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/registry/get-all',
      body: <String, dynamic>{
        'scope': scope,
        if (domain != null) 'domain': domain,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res;
  }

  /// Retrieves detailed information for a specific key
  /// (`/api/i/registry/get-detail`).
  ///
  /// Returns the value along with the last updated timestamp.
  ///
  /// [key] specifies the registry key name. [scope] is the scope array and
  /// defaults to empty. [domain] defaults to the access token's domain.
  ///
  /// Throws a `NO_SUCH_KEY` error from the server if the key does not exist.
  Future<MisskeyRegistryDetail> getDetail({
    required String key,
    List<String> scope = const <String>[],
    String? domain,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/registry/get-detail',
      body: <String, dynamic>{
        'key': key,
        'scope': scope,
        if (domain != null) 'domain': domain,
      },
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyRegistryDetail.fromJson(res);
  }

  /// Retrieves the list of key names within a scope
  /// (`/api/i/registry/keys`).
  ///
  /// [scope] is the scope array and defaults to empty. [domain] defaults to
  /// the access token's domain.
  Future<List<String>> keys({
    List<String> scope = const <String>[],
    String? domain,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/i/registry/keys',
      body: <String, dynamic>{
        'scope': scope,
        if (domain != null) 'domain': domain,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res.cast<String>();
  }

  /// Retrieves the list of key names with type information
  /// (`/api/i/registry/keys-with-type`).
  ///
  /// Returns a Map with key names as keys and type names (`'null'`/`'array'`/
  /// `'number'`/`'string'`/`'boolean'`/`'object'`) as values.
  ///
  /// [scope] is the scope array and defaults to empty. [domain] defaults to
  /// the access token's domain.
  Future<Map<String, String>> keysWithType({
    List<String> scope = const <String>[],
    String? domain,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/registry/keys-with-type',
      body: <String, dynamic>{
        'scope': scope,
        if (domain != null) 'domain': domain,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res.map((k, v) => MapEntry(k, v.toString()));
  }

  /// Sets a key-value pair (`/api/i/registry/set`).
  ///
  /// Creates a new entry if the key does not exist, or overwrites it if it
  /// does.
  ///
  /// [key] is the registry key name (at least 1 character) and [value] is the
  /// value to store (any type). [scope] is the scope array and defaults to
  /// empty. [domain] defaults to the access token's domain.
  Future<void> set({
    required String key,
    required dynamic value,
    List<String> scope = const <String>[],
    String? domain,
  }) =>
      http.send<Object?>(
        '/i/registry/set',
        body: <String, dynamic>{
          'key': key,
          'value': value,
          'scope': scope,
          if (domain != null) 'domain': domain,
        },
      );

  /// Removes a key (`/api/i/registry/remove`).
  ///
  /// [key] is the registry key name to remove. [scope] is the scope array and
  /// defaults to empty. [domain] defaults to the access token's domain.
  ///
  /// Throws a `NO_SUCH_KEY` error from the server if the key does not exist.
  Future<void> remove({
    required String key,
    List<String> scope = const <String>[],
    String? domain,
  }) =>
      http.send<Object?>(
        '/i/registry/remove',
        body: <String, dynamic>{
          'key': key,
          'scope': scope,
          if (domain != null) 'domain': domain,
        },
      );

  /// Retrieves all scopes and domains
  /// (`/api/i/registry/scopes-with-domain`).
  ///
  /// Takes no parameters. Returns all scope-domain combinations held by the
  /// user's registry.
  Future<List<MisskeyRegistryScope>> scopesWithDomain() async {
    final res = await http.send<List<dynamic>>(
      '/i/registry/scopes-with-domain',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRegistryScope.fromJson)
        .toList();
  }
}
