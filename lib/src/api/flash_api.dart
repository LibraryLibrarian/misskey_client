import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/users/misskey_flash.dart';
import '../models/users/misskey_flash_like.dart';

/// Provides Flash (Play) operations (`/api/flash/*`).
///
/// Handles creating, updating, deleting, viewing, and liking Flashes.
/// Use [my] for the authenticated user's Flashes, or `UsersApi.flashs`
/// for another user's Flashes.
class FlashApi {
  const FlashApi({required this.http});

  final MisskeyHttp http;

  /// Creates a Flash (`/api/flash/create`).
  ///
  /// Authentication required. Rate limit: 10 requests/hour.
  ///
  /// Provide [title], [summary], [script] (AiScript code), and [permissions]
  /// as required fields. Optionally pass [visibility] to set the visibility
  /// (`public`/`private`, default: `public`).
  ///
  /// Notable errors:
  /// - `TOO_MANY_FLASHES`: The Flash limit has been reached.
  Future<MisskeyFlash> create({
    required String title,
    required String summary,
    required String script,
    required List<String> permissions,
    String? visibility,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/flash/create',
      body: <String, dynamic>{
        'title': title,
        'summary': summary,
        'script': script,
        'permissions': permissions,
        if (visibility != null) 'visibility': visibility,
      },
    );
    return MisskeyFlash.fromJson(res);
  }

  /// Updates a Flash (`/api/flash/update`).
  ///
  /// Authentication required. Rate limit: 300 requests/hour.
  /// Only [flashId] is required; other parameters update only the
  /// specified fields.
  ///
  /// Notable errors:
  /// - `NO_SUCH_FLASH`: The Flash does not exist.
  /// - `ACCESS_DENIED`: Insufficient permissions.
  Future<void> update({
    required String flashId,
    String? title,
    String? summary,
    String? script,
    List<String>? permissions,
    String? visibility,
  }) {
    final body = <String, dynamic>{
      'flashId': flashId,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (script != null) 'script': script,
      if (permissions != null) 'permissions': permissions,
      if (visibility != null) 'visibility': visibility,
    };
    return http.send<Object?>(
      '/flash/update',
      body: body,
    );
  }

  /// Deletes a Flash (`/api/flash/delete`).
  ///
  /// Authentication required. Only the owner or a moderator can delete.
  /// Pass [flashId] to identify the Flash to delete.
  ///
  /// Notable errors:
  /// - `NO_SUCH_FLASH`: The Flash does not exist.
  /// - `ACCESS_DENIED`: Insufficient permissions.
  Future<void> delete({required String flashId}) => http.send<Object?>(
        '/flash/delete',
        body: <String, dynamic>{'flashId': flashId},
      );

  /// Retrieves the details of a Flash (`/api/flash/show`).
  ///
  /// No authentication required. Pass [flashId] to identify the Flash
  /// to retrieve.
  ///
  /// Notable errors:
  /// - `NO_SUCH_FLASH`: The Flash does not exist.
  Future<MisskeyFlash> show({required String flashId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/flash/show',
      body: <String, dynamic>{'flashId': flashId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyFlash.fromJson(res);
  }

  /// Retrieves the authenticated user's Flashes (`/api/flash/my`).
  ///
  /// Authentication required. Use [limit] to cap the number of results
  /// (1-100, default 10). Pass [sinceId] or [untilId] to paginate by ID,
  /// or pass [sinceDate] or [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyFlash>> my({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/flash/my',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFlash.fromJson)
        .toList();
  }

  /// Retrieves featured Flashes (`/api/flash/featured`).
  ///
  /// No authentication required. Uses offset-based pagination.
  /// Pass [offset] to skip entries (default: 0) and use [limit] to cap
  /// the number of results (1-100, default 10).
  Future<List<MisskeyFlash>> featured({
    int? offset,
    int? limit,
  }) async {
    final body = <String, dynamic>{
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };
    final res = await http.send<List<dynamic>>(
      '/flash/featured',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFlash.fromJson)
        .toList();
  }

  /// Likes a Flash (`/api/flash/like`).
  ///
  /// Authentication required.
  ///
  /// Notable errors:
  /// - `NO_SUCH_FLASH`: The Flash does not exist.
  /// - `YOUR_FLASH`: Cannot like your own Flash.
  /// - `ALREADY_LIKED`: Already liked.
  Future<void> like({required String flashId}) => http.send<Object?>(
        '/flash/like',
        body: <String, dynamic>{'flashId': flashId},
      );

  /// Removes a like from a Flash (`/api/flash/unlike`).
  ///
  /// Authentication required.
  ///
  /// Notable errors:
  /// - `NO_SUCH_FLASH`: The Flash does not exist.
  /// - `NOT_LIKED`: Not liked.
  Future<void> unlike({required String flashId}) => http.send<Object?>(
        '/flash/unlike',
        body: <String, dynamic>{'flashId': flashId},
      );

  /// Retrieves the authenticated user's liked Flashes
  /// (`/api/flash/my-likes`).
  ///
  /// Authentication required. Use [limit] to cap the number of results
  /// (1-100, default 10). Pass [sinceId] or [untilId] to paginate by ID,
  /// or pass [sinceDate] or [untilDate] to paginate by Unix timestamp (ms).
  /// Pass [search] for space-separated AND search on note body
  /// (1-100 characters).
  Future<List<MisskeyFlashLike>> myLikes({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? search,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (search != null) 'search': search,
    };
    final res = await http.send<List<dynamic>>(
      '/flash/my-likes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFlashLike.fromJson)
        .toList();
  }

  /// Searches for Flashes (`/api/flash/search`).
  ///
  /// No authentication required. Pass [query] as the search string
  /// (1-100 characters). Use [limit] to cap the number of results
  /// (1-100, default 5). Pass [sinceId] or [untilId] to paginate by ID,
  /// or pass [sinceDate] or [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyFlash>> search({
    required String query,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'query': query,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/flash/search',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyFlash.fromJson)
        .toList();
  }
}
