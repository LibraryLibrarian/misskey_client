import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_hashtag.dart';
import '../models/misskey_hashtag_trend.dart';
import '../models/misskey_user.dart';

/// Provides hashtag-related API endpoints (`/api/hashtags/*`).
///
/// Supports searching, listing, and retrieving trending hashtags.
class HashtagsApi {
  const HashtagsApi({required this.http});

  final MisskeyHttp http;

  /// Fetches a list of hashtags (`/api/hashtags/list`).
  ///
  /// Returns hashtags sorted by the specified order.
  /// No authentication required.
  ///
  /// Pass [sort] to specify the sort order (required); accepted values are
  /// `+mentionedUsers` / `-mentionedUsers` /
  /// `+mentionedLocalUsers` / `-mentionedLocalUsers` /
  /// `+mentionedRemoteUsers` / `-mentionedRemoteUsers` /
  /// `+attachedUsers` / `-attachedUsers` /
  /// `+attachedLocalUsers` / `-attachedLocalUsers` /
  /// `+attachedRemoteUsers` / `-attachedRemoteUsers`.
  /// Use [limit] to cap the number of results (1-100, default: 10).
  /// Set [attachedToUserOnly], [attachedToLocalUserOnly], or
  /// [attachedToRemoteUserOnly] to restrict results to tags attached
  /// to those profile types.
  Future<List<MisskeyHashtag>> list({
    required String sort,
    int? limit,
    bool? attachedToUserOnly,
    bool? attachedToLocalUserOnly,
    bool? attachedToRemoteUserOnly,
  }) async {
    final body = <String, dynamic>{
      'sort': sort,
      if (limit != null) 'limit': limit,
      if (attachedToUserOnly != null) 'attachedToUserOnly': attachedToUserOnly,
      if (attachedToLocalUserOnly != null)
        'attachedToLocalUserOnly': attachedToLocalUserOnly,
      if (attachedToRemoteUserOnly != null)
        'attachedToRemoteUserOnly': attachedToRemoteUserOnly,
    };
    final res = await http.send<List<dynamic>>(
      '/hashtags/list',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyHashtag.fromJson)
        .toList();
  }

  /// Searches for hashtags by prefix (`/api/hashtags/search`).
  ///
  /// Performs a prefix match on hashtag names. No authentication required.
  /// Returns a list of matching hashtag name strings.
  ///
  /// Pass [query] as the search string. Use [limit] to cap the number of
  /// results (1-100, default: 10) and [offset] to skip entries
  /// (default: 0).
  Future<List<String>> search({
    required String query,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'query': query,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<List<dynamic>>(
      '/hashtags/search',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res.cast<String>();
  }

  /// Retrieves detailed information for a hashtag (`/api/hashtags/show`).
  ///
  /// No authentication required. Pass [tag] as the hashtag name to look up.
  ///
  /// Common errors:
  /// - `NO_SUCH_HASHTAG`: The specified hashtag does not exist
  Future<MisskeyHashtag> show({required String tag}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/hashtags/show',
      body: <String, dynamic>{'tag': tag},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return MisskeyHashtag.fromJson(res);
  }

  /// Retrieves trending hashtags (`/api/hashtags/trend`).
  ///
  /// Returns up to 10 recently popular hashtags. No authentication required.
  /// The response is cached for 60 seconds on the server.
  Future<List<MisskeyHashtagTrend>> trend() async {
    final res = await http.send<List<dynamic>>(
      '/hashtags/trend',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyHashtagTrend.fromJson)
        .toList();
  }

  /// Retrieves users associated with a hashtag (`/api/hashtags/users`).
  ///
  /// No authentication required. Pass [tag] as the hashtag name and [sort]
  /// to control the order; accepted values are `+follower` / `-follower` /
  /// `+createdAt` / `-createdAt` / `+updatedAt` / `-updatedAt`.
  /// Use [limit] to cap the number of results (1-100, default: 10) and
  /// [offset] to skip entries (default: 0). Pass [state] to filter by
  /// activity state (`all` / `alive`, default: `all`) and [origin] to
  /// filter by user origin (`combined` / `local` / `remote`,
  /// default: `local`).
  Future<List<MisskeyUser>> users({
    required String tag,
    required String sort,
    int? limit,
    int? offset,
    String? state,
    String? origin,
  }) async {
    final body = <String, dynamic>{
      'tag': tag,
      'sort': sort,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (state != null) 'state': state,
      if (origin != null) 'origin': origin,
    };
    final res = await http.send<List<dynamic>>(
      '/hashtags/users',
      body: body,
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
}
