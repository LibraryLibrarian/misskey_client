import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../internal/request_body.dart';
import '../../models/server/emoji_detailed.dart';

/// Provides custom emoji management admin APIs (`/api/admin/emoji/*`).
///
/// All endpoints require moderator privileges unless noted otherwise.
class AdminEmojiApi {
  const AdminEmojiApi({required this.http});

  final MisskeyHttp http;

  /// Registers a custom emoji (`/api/admin/emoji/add`).
  ///
  /// [name] is the emoji shortcode and [fileId] is the drive file to use
  /// as the emoji image. Returns the registered emoji.
  ///
  /// Common errors:
  /// - `NO_SUCH_FILE`: The specified drive file does not exist
  /// - `DUPLICATE_NAME`: An emoji with the same name already exists
  Future<EmojiDetailed> add({
    required String name,
    required String fileId,
    String? category,
    List<String>? aliases,
    String? license,
    bool? isSensitive,
    bool? localOnly,
    List<String>? roleIdsThatCanBeUsedThisEmojiAsReaction,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/emoji/add',
      body: <String, dynamic>{
        'name': name,
        'fileId': fileId,
        'category': ?category,
        'aliases': ?aliases,
        'license': ?license,
        'isSensitive': ?isSensitive,
        'localOnly': ?localOnly,
        'roleIdsThatCanBeUsedThisEmojiAsReaction':
            ?roleIdsThatCanBeUsedThisEmojiAsReaction,
      },
    );
    return EmojiDetailed.fromJson(res);
  }

  /// Updates a custom emoji (`/api/admin/emoji/update`).
  ///
  /// Identify the target by [id] or [name] (at least one is required).
  /// Only the parameters that are provided are sent. [category] and
  /// [license] use the [Optional] type: pass `Optional('value')` to set
  /// and `Optional.null_()` to clear.
  ///
  /// Common errors:
  /// - `NO_SUCH_EMOJI`: The specified emoji does not exist
  /// - `DUPLICATE_NAME`: An emoji with the new name already exists
  Future<void> update({
    String? id,
    String? name,
    String? fileId,
    Optional<String>? category,
    List<String>? aliases,
    Optional<String>? license,
    bool? isSensitive,
    bool? localOnly,
    List<String>? roleIdsThatCanBeUsedThisEmojiAsReaction,
  }) async {
    assert(
      id != null || name != null,
      'Either id or name must be provided to identify the emoji.',
    );
    final body = <String, dynamic>{
      'id': ?id,
      'name': ?name,
      'fileId': ?fileId,
      'aliases': ?aliases,
      'isSensitive': ?isSensitive,
      'localOnly': ?localOnly,
      'roleIdsThatCanBeUsedThisEmojiAsReaction':
          ?roleIdsThatCanBeUsedThisEmojiAsReaction,
    };
    putOptional(body, 'category', category);
    putOptional(body, 'license', license);
    await http.send<Object?>('/admin/emoji/update', body: body);
  }

  /// Deletes a custom emoji (`/api/admin/emoji/delete`).
  ///
  /// Common errors:
  /// - `NO_SUCH_EMOJI`: The specified emoji does not exist
  Future<void> delete({required String id}) => http.send<Object?>(
    '/admin/emoji/delete',
    body: <String, dynamic>{'id': id},
  );

  /// Deletes multiple custom emojis (`/api/admin/emoji/delete-bulk`).
  Future<void> deleteBulk({required List<String> ids}) => http.send<Object?>(
    '/admin/emoji/delete-bulk',
    body: <String, dynamic>{'ids': ids},
  );

  /// Fetches local custom emojis (`/api/admin/emoji/list`).
  ///
  /// Use [query] to filter by name, [limit] (1-100, default 10) to cap
  /// the number of results, and [sinceId] / [untilId] for cursor-based
  /// pagination.
  Future<List<EmojiDetailed>> list({
    String? query,
    int? limit,
    String? sinceId,
    String? untilId,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/emoji/list',
      body: <String, dynamic>{
        'query': ?query,
        'limit': ?limit,
        'sinceId': ?sinceId,
        'untilId': ?untilId,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(EmojiDetailed.fromJson)
        .toList();
  }

  /// Fetches remote custom emojis (`/api/admin/emoji/list-remote`).
  ///
  /// Use [host] to filter by the remote host, [query] to filter by name,
  /// [limit] (1-100, default 10) to cap the number of results, and
  /// [sinceId] / [untilId] for cursor-based pagination.
  Future<List<EmojiDetailed>> listRemote({
    String? query,
    String? host,
    int? limit,
    String? sinceId,
    String? untilId,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/emoji/list-remote',
      body: <String, dynamic>{
        'query': ?query,
        'host': ?host,
        'limit': ?limit,
        'sinceId': ?sinceId,
        'untilId': ?untilId,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(EmojiDetailed.fromJson)
        .toList();
  }

  /// Copies a remote custom emoji to the local instance
  /// (`/api/admin/emoji/copy`).
  ///
  /// Returns the ID of the newly created local emoji.
  ///
  /// Common errors:
  /// - `NO_SUCH_EMOJI`: The specified emoji does not exist
  /// - `DUPLICATE_NAME`: A local emoji with the same name already exists
  Future<String> copy({required String emojiId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/emoji/copy',
      body: <String, dynamic>{'emojiId': emojiId},
    );
    return res['id'] as String;
  }

  /// Imports custom emojis from a zip file on the drive
  /// (`/api/admin/emoji/import-zip`).
  ///
  /// The import is processed asynchronously on the server.
  Future<void> importZip({required String fileId}) => http.send<Object?>(
    '/admin/emoji/import-zip',
    body: <String, dynamic>{'fileId': fileId},
  );

  /// Adds aliases to multiple emojis (`/api/admin/emoji/add-aliases-bulk`).
  Future<void> addAliasesBulk({
    required List<String> ids,
    required List<String> aliases,
  }) => http.send<Object?>(
    '/admin/emoji/add-aliases-bulk',
    body: <String, dynamic>{'ids': ids, 'aliases': aliases},
  );

  /// Removes aliases from multiple emojis
  /// (`/api/admin/emoji/remove-aliases-bulk`).
  Future<void> removeAliasesBulk({
    required List<String> ids,
    required List<String> aliases,
  }) => http.send<Object?>(
    '/admin/emoji/remove-aliases-bulk',
    body: <String, dynamic>{'ids': ids, 'aliases': aliases},
  );

  /// Replaces the aliases of multiple emojis
  /// (`/api/admin/emoji/set-aliases-bulk`).
  Future<void> setAliasesBulk({
    required List<String> ids,
    required List<String> aliases,
  }) => http.send<Object?>(
    '/admin/emoji/set-aliases-bulk',
    body: <String, dynamic>{'ids': ids, 'aliases': aliases},
  );

  /// Sets the category of multiple emojis
  /// (`/api/admin/emoji/set-category-bulk`).
  ///
  /// Pass `null` as [category] to clear the category.
  Future<void> setCategoryBulk({required List<String> ids, String? category}) =>
      http.send<Object?>(
        '/admin/emoji/set-category-bulk',
        body: <String, dynamic>{'ids': ids, 'category': category},
      );

  /// Sets the license of multiple emojis
  /// (`/api/admin/emoji/set-license-bulk`).
  ///
  /// Pass `null` as [license] to clear the license.
  Future<void> setLicenseBulk({required List<String> ids, String? license}) =>
      http.send<Object?>(
        '/admin/emoji/set-license-bulk',
        body: <String, dynamic>{'ids': ids, 'license': license},
      );
}
