import '../../client/auth_mode.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/gallery/misskey_gallery_post.dart';

/// Provides gallery operations (`/api/gallery/*`).
///
/// Handles viewing, creating, updating, deleting, and liking gallery posts.
/// Use `AccountApi.galleryPosts` for the authenticated user's posts,
/// or `UsersApi.galleryPosts` for another user's posts.
class GalleryApi {
  const GalleryApi({required this.http});

  final MisskeyHttp http;

  /// Retrieves featured gallery posts (`/api/gallery/featured`).
  ///
  /// Returns popular posts based on a ranking cache (30-minute TTL).
  /// No authentication required. Use [limit] to cap the number of results
  /// (1-100, default 10) and [untilId] to paginate by ID.
  Future<List<MisskeyGalleryPost>> featured({
    int? limit,
    String? untilId,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (untilId != null) 'untilId': untilId,
    };
    final res = await http.send<List<dynamic>>(
      '/gallery/featured',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyGalleryPost.fromJson)
        .toList();
  }

  /// Retrieves popular gallery posts (`/api/gallery/popular`).
  ///
  /// Returns up to 10 posts with at least one like, sorted by like count
  /// in descending order. No authentication required.
  Future<List<MisskeyGalleryPost>> popular() async {
    final res = await http.send<List<dynamic>>(
      '/gallery/popular',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyGalleryPost.fromJson)
        .toList();
  }

  /// Retrieves gallery posts as a timeline (`/api/gallery/posts`).
  ///
  /// Returns all users' posts in reverse chronological order.
  /// No authentication required. Use [limit] to cap the number of results
  /// (1-100, default 10). Paginate by ID with [sinceId] and [untilId], or by
  /// Unix timestamp (ms) with [sinceDate] and [untilDate].
  Future<List<MisskeyGalleryPost>> posts({
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
      '/gallery/posts',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyGalleryPost.fromJson)
        .toList();
  }

  /// Retrieves the details of a gallery post (`/api/gallery/posts/show`).
  ///
  /// No authentication required.
  ///
  /// Notable errors:
  /// - `NO_SUCH_POST`: The post does not exist.
  Future<MisskeyGalleryPost> postsShow({required String postId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/gallery/posts/show',
      body: <String, dynamic>{'postId': postId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyGalleryPost.fromJson(res);
  }

  /// Creates a gallery post (`/api/gallery/posts/create`).
  ///
  /// Authentication required. Rate limit: 20 requests/hour.
  /// [title] and [fileIds] are required; [fileIds] accepts 1-32 unique IDs.
  /// Optionally provide [description] and set [isSensitive] to `true` if the
  /// content is sensitive (default: false).
  Future<MisskeyGalleryPost> postsCreate({
    required String title,
    required List<String> fileIds,
    String? description,
    bool? isSensitive,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'fileIds': fileIds,
      if (description != null) 'description': description,
      if (isSensitive != null) 'isSensitive': isSensitive,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/gallery/posts/create',
      body: body,
    );
    return MisskeyGalleryPost.fromJson(res);
  }

  /// Updates a gallery post (`/api/gallery/posts/update`).
  ///
  /// Authentication required. Rate limit: 300 requests/hour.
  /// [postId] is required. Optionally provide [title], [fileIds] (1-32 unique
  /// IDs), [description], and [isSensitive] to update those fields.
  Future<MisskeyGalleryPost> postsUpdate({
    required String postId,
    String? title,
    List<String>? fileIds,
    String? description,
    bool? isSensitive,
  }) async {
    final body = <String, dynamic>{
      'postId': postId,
      if (title != null) 'title': title,
      if (fileIds != null) 'fileIds': fileIds,
      if (description != null) 'description': description,
      if (isSensitive != null) 'isSensitive': isSensitive,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/gallery/posts/update',
      body: body,
    );
    return MisskeyGalleryPost.fromJson(res);
  }

  /// Deletes a gallery post (`/api/gallery/posts/delete`).
  ///
  /// Authentication required. Only the owner or a moderator can delete.
  ///
  /// Notable errors:
  /// - `NO_SUCH_POST`: The post does not exist.
  /// - `ACCESS_DENIED`: Insufficient permissions.
  Future<void> postsDelete({required String postId}) => http.send<Object?>(
        '/gallery/posts/delete',
        body: <String, dynamic>{'postId': postId},
      );

  /// Likes a gallery post (`/api/gallery/posts/like`).
  ///
  /// Authentication required.
  ///
  /// Notable errors:
  /// - `NO_SUCH_POST`: The post does not exist.
  /// - `YOUR_POST`: Cannot like your own post.
  /// - `ALREADY_LIKED`: Already liked.
  Future<void> postsLike({required String postId}) => http.send<Object?>(
        '/gallery/posts/like',
        body: <String, dynamic>{'postId': postId},
      );

  /// Removes a like from a gallery post (`/api/gallery/posts/unlike`).
  ///
  /// Authentication required.
  ///
  /// Notable errors:
  /// - `NO_SUCH_POST`: The post does not exist.
  /// - `NOT_LIKED`: Not liked.
  Future<void> postsUnlike({required String postId}) => http.send<Object?>(
        '/gallery/posts/unlike',
        body: <String, dynamic>{'postId': postId},
      );
}
