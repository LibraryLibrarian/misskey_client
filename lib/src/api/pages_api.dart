import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/users/misskey_page.dart';

/// Provides page-related API endpoints (`/api/pages/*`).
///
/// Supports creating, updating, deleting, viewing, and liking pages.
/// For own pages, use `AccountApi.pages`;
/// for other users' pages, use `UsersApi.pages`.
class PagesApi {
  const PagesApi({required this.http});

  final MisskeyHttp http;

  /// Retrieves page details by page ID (`/api/pages/show`).
  ///
  /// No authentication required.
  ///
  /// Common errors:
  /// - `NO_SUCH_PAGE`: The page does not exist
  Future<MisskeyPage> showById({required String pageId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/pages/show',
      body: <String, dynamic>{'pageId': pageId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyPage.fromJson(res);
  }

  /// Retrieves page details by username and page name (`/api/pages/show`).
  ///
  /// No authentication required.
  ///
  /// Pass the URL path name of the page in [name] and the username of the
  /// page creator in [username].
  ///
  /// Common errors:
  /// - `NO_SUCH_PAGE`: The page does not exist
  Future<MisskeyPage> showByName({
    required String name,
    required String username,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/pages/show',
      body: <String, dynamic>{'name': name, 'username': username},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyPage.fromJson(res);
  }

  /// Fetches featured pages (`/api/pages/featured`).
  ///
  /// Returns up to 10 pages with at least one like, sorted by like count
  /// in descending order. No authentication required.
  Future<List<MisskeyPage>> featured() async {
    final res = await http.send<List<dynamic>>(
      '/pages/featured',
      body: const <String, dynamic>{},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyPage.fromJson)
        .toList();
  }

  /// Creates a page (`/api/pages/create`).
  ///
  /// Authentication required. Rate limit: 10 requests/hour.
  ///
  /// Provide a [title], a URL path [name] (min 1 character), a [content]
  /// block array, a [variables] definition array, and a [script].
  /// Optionally supply a [summary], an [eyeCatchingImageId] for the
  /// eye-catching drive file, a [font] setting (`serif` / `sans-serif`,
  /// default: `sans-serif`), and boolean flags [alignCenter] (default: false)
  /// and [hideTitleWhenPinned] (default: false).
  ///
  /// Common errors:
  /// - `NO_SUCH_FILE`: The eye-catching image does not exist
  /// - `NAME_ALREADY_EXISTS`: A page with the same name already exists
  Future<MisskeyPage> create({
    required String title,
    required String name,
    required List<Map<String, dynamic>> content,
    required List<Map<String, dynamic>> variables,
    required String script,
    String? summary,
    String? eyeCatchingImageId,
    String? font,
    bool? alignCenter,
    bool? hideTitleWhenPinned,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'name': name,
      'content': content,
      'variables': variables,
      'script': script,
      if (summary != null) 'summary': summary,
      if (eyeCatchingImageId != null) 'eyeCatchingImageId': eyeCatchingImageId,
      if (font != null) 'font': font,
      if (alignCenter != null) 'alignCenter': alignCenter,
      if (hideTitleWhenPinned != null)
        'hideTitleWhenPinned': hideTitleWhenPinned,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/pages/create',
      body: body,
    );
    return MisskeyPage.fromJson(res);
  }

  /// Updates a page (`/api/pages/update`).
  ///
  /// Authentication required. Rate limit: 300 requests/hour.
  /// Only [pageId] is required.
  /// Other parameters update only the specified fields.
  ///
  /// Pass the ID of the page to update in [pageId]. All other parameters are
  /// optional and update only the specified fields: [title], [name] (min 1
  /// character), [content] block array, [variables] definition array,
  /// [script], [summary], [eyeCatchingImageId], [font] (`serif` /
  /// `sans-serif`), [alignCenter], and [hideTitleWhenPinned].
  ///
  /// Common errors:
  /// - `NO_SUCH_PAGE`: The page does not exist
  /// - `ACCESS_DENIED`: Insufficient permissions
  /// - `NO_SUCH_FILE`: The eye-catching image does not exist
  /// - `NAME_ALREADY_EXISTS`: A page with the same name already exists
  Future<void> update({
    required String pageId,
    String? title,
    String? name,
    List<Map<String, dynamic>>? content,
    List<Map<String, dynamic>>? variables,
    String? script,
    String? summary,
    String? eyeCatchingImageId,
    String? font,
    bool? alignCenter,
    bool? hideTitleWhenPinned,
  }) {
    final body = <String, dynamic>{
      'pageId': pageId,
      if (title != null) 'title': title,
      if (name != null) 'name': name,
      if (content != null) 'content': content,
      if (variables != null) 'variables': variables,
      if (script != null) 'script': script,
      if (summary != null) 'summary': summary,
      if (eyeCatchingImageId != null) 'eyeCatchingImageId': eyeCatchingImageId,
      if (font != null) 'font': font,
      if (alignCenter != null) 'alignCenter': alignCenter,
      if (hideTitleWhenPinned != null)
        'hideTitleWhenPinned': hideTitleWhenPinned,
    };
    return http.send<Object?>(
      '/pages/update',
      body: body,
    );
  }

  /// Deletes a page (`/api/pages/delete`).
  ///
  /// Authentication required. Only the owner or a moderator can delete.
  ///
  /// Pass the ID of the page to delete in [pageId].
  ///
  /// Common errors:
  /// - `NO_SUCH_PAGE`: The page does not exist
  /// - `ACCESS_DENIED`: Insufficient permissions
  Future<void> delete({required String pageId}) => http.send<Object?>(
        '/pages/delete',
        body: <String, dynamic>{'pageId': pageId},
      );

  /// Likes a page (`/api/pages/like`).
  ///
  /// Authentication required.
  ///
  /// Common errors:
  /// - `NO_SUCH_PAGE`: The page does not exist
  /// - `YOUR_PAGE`: Cannot like your own page
  /// - `ALREADY_LIKED`: Already liked
  Future<void> like({required String pageId}) => http.send<Object?>(
        '/pages/like',
        body: <String, dynamic>{'pageId': pageId},
      );

  /// Unlikes a page (`/api/pages/unlike`).
  ///
  /// Authentication required.
  ///
  /// Common errors:
  /// - `NO_SUCH_PAGE`: The page does not exist
  /// - `NOT_LIKED`: Not liked yet
  Future<void> unlike({required String pageId}) => http.send<Object?>(
        '/pages/unlike',
        body: <String, dynamic>{'pageId': pageId},
      );
}
