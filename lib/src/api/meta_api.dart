import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/meta.dart';
import '../models/misskey_custom_emoji.dart';
import '../models/misskey_user.dart';
import '../models/server/avatar_decoration.dart';
import '../models/server/emoji_detailed.dart';
import '../models/server/endpoint_info.dart';
import '../models/server/instance_stats.dart';
import '../models/server/retention_record.dart';
import '../models/server/server_info.dart';

/// Provides server metadata API endpoints (`/api/meta`).
///
/// Caches results in memory so that subsequent calls skip the network request.
/// Use [supports] to detect server capabilities via dot-notation key paths.
class MetaApi {
  /// Creates an instance that operates the metadata API using [http].
  MetaApi({required this.http});

  /// HTTP client.
  final MisskeyHttp http;

  Meta? _cached;

  /// Retrieves server metadata (`/api/meta`).
  ///
  /// Set [refresh] to `true` to bypass the cache and always fetch
  /// the latest information from the server.
  /// By default, the result is cached after the first fetch
  /// and subsequent calls return the cached value.
  ///
  /// Set [detail] to `false` to retrieve a lightweight `MetaLite`-equivalent
  /// response (default: `true`).
  Future<Meta> getMeta({bool refresh = false, bool? detail}) async {
    if (!refresh && detail != false && _cached != null) return _cached!;
    final res = await http.send<Map<String, dynamic>>(
      '/meta',
      body: <String, dynamic>{
        if (detail != null) 'detail': detail,
      },
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    final meta = Meta.fromJson(res);
    if (detail != false) _cached = meta;
    return meta;
  }

  /// Retrieves server machine information (`/api/server-info`).
  ///
  /// Returns technical details such as CPU, memory, and disk usage.
  /// If `enableServerMachineStats` is disabled on the server,
  /// placeholder values are returned.
  Future<ServerInfo> getServerInfo() async {
    final res = await http.send<Map<String, dynamic>>(
      '/server-info',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return ServerInfo.fromJson(res);
  }

  /// Retrieves instance statistics (`/api/stats`).
  ///
  /// Returns user count, note count, federated instance count,
  /// drive usage, and more.
  Future<InstanceStats> getStats() async {
    final res = await http.send<Map<String, dynamic>>(
      '/stats',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return InstanceStats.fromJson(res);
  }

  /// Pings the server (`/api/ping`).
  ///
  /// Returns the server's current time as a Unix timestamp in milliseconds
  /// on success.
  Future<int> ping() async {
    final res = await http.send<Map<String, dynamic>>(
      '/ping',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return (res['pong'] as num).toInt();
  }

  /// Retrieves all available endpoint names (`/api/endpoints`).
  Future<List<String>> getEndpoints() async {
    final res = await http.send<List<dynamic>>(
      '/endpoints',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res.cast<String>();
  }

  /// Retrieves parameter information for a specific endpoint (`/api/endpoint`).
  ///
  /// Specify the target endpoint name in [endpoint].
  /// Returns `null` if the endpoint does not exist.
  Future<EndpointInfo?> getEndpoint({required String endpoint}) async {
    final res = await http.send<Map<String, dynamic>?>(
      '/endpoint',
      body: <String, dynamic>{'endpoint': endpoint},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    if (res == null) return null;
    return EndpointInfo.fromJson(res);
  }

  /// Retrieves the list of local custom emoji (`/api/emojis`).
  ///
  /// Returns local emoji sorted by category and name.
  Future<List<MisskeyCustomEmoji>> getEmojis() async {
    final res = await http.send<Map<String, dynamic>>(
      '/emojis',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    final list = res['emojis'] as List<dynamic>;
    return list
        .map((e) => MisskeyCustomEmoji.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Retrieves detailed information for a custom emoji by name (`/api/emoji`).
  ///
  /// Specify the emoji shortcode in [name].
  Future<EmojiDetailed> getEmoji({required String name}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/emoji',
      body: <String, dynamic>{'name': name},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return EmojiDetailed.fromJson(res);
  }

  /// Retrieves the list of pinned users set by administrators (`/api/pinned-users`).
  ///
  /// No authentication required.
  Future<List<MisskeyUser>> getPinnedUsers() async {
    final res = await http.send<List<dynamic>>(
      '/pinned-users',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUser.fromJson)
        .toList();
  }

  /// Retrieves the count of online users (`/api/get-online-users-count`).
  ///
  /// No authentication required. The response is cached for 60 seconds.
  Future<int> getOnlineUsersCount() async {
    final res = await http.send<Map<String, dynamic>>(
      '/get-online-users-count',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return (res['count'] as num).toInt();
  }

  /// Retrieves the list of available avatar decorations
  /// (`/api/get-avatar-decorations`).
  ///
  /// No authentication required.
  Future<List<AvatarDecoration>> getAvatarDecorations() async {
    final res = await http.send<List<dynamic>>(
      '/get-avatar-decorations',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(AvatarDecoration.fromJson)
        .toList();
  }

  /// Retrieves user retention statistics (`/api/retention`).
  ///
  /// No authentication required. The response is cached for 3600 seconds.
  /// Returns up to 30 daily retention records.
  Future<List<RetentionRecord>> getRetention() async {
    final res = await http.send<List<dynamic>>(
      '/retention',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(RetentionRecord.fromJson)
        .toList();
  }

  /// Performs a simple capability check against cached metadata.
  ///
  /// Specify a dot-separated key path in [keyPath] (e.g., `"features.miauth"`)
  /// and returns `true` if that key exists in [Meta.raw].
  /// Always returns `false` if [getMeta] has not been called yet.
  bool supports(String keyPath) {
    final meta = _cached;
    if (meta == null) return false;
    final parts = keyPath.split('.');
    dynamic cursor = meta.raw;
    for (final p in parts) {
      if (cursor is Map && cursor.containsKey(p)) {
        cursor = cursor[p];
      } else {
        return false;
      }
    }
    return true;
  }
}
