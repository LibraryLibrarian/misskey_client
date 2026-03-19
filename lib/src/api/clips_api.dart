import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_clip.dart';
import '../models/misskey_note.dart';

/// Provides clip operations (`/api/clips/*`).
///
/// Handles creating, updating, deleting clips (note bookmarks),
/// adding/removing notes, and managing favorites.
/// All endpoints require authentication.
class ClipsApi {
  const ClipsApi({required this.http});

  final MisskeyHttp http;

  /// Creates a clip (`/api/clips/create`).
  ///
  /// Pass [name] as the clip name (1-100 characters, required).
  /// Set [isPublic] to make the clip visible to others (default: false).
  /// Pass [description] to add a description (up to 2048 characters).
  ///
  /// Notable errors:
  /// - `TOO_MANY_CLIPS`: The clip limit has been reached.
  Future<MisskeyClip> create({
    required String name,
    bool? isPublic,
    String? description,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/clips/create',
      body: <String, dynamic>{
        'name': name,
        if (isPublic != null) 'isPublic': isPublic,
        if (description != null) 'description': description,
      },
    );
    return MisskeyClip.fromJson(res);
  }

  /// Updates a clip (`/api/clips/update`).
  ///
  /// Pass [clipId] to identify the clip to update.
  /// Optionally supply [name] (1-100 characters), [isPublic], or
  /// [description] (up to 2048 characters) to change those fields.
  ///
  /// Notable errors:
  /// - `NO_SUCH_CLIP`: The clip does not exist.
  Future<MisskeyClip> update({
    required String clipId,
    String? name,
    bool? isPublic,
    String? description,
  }) async {
    final body = <String, dynamic>{
      'clipId': clipId,
      if (name != null) 'name': name,
      if (isPublic != null) 'isPublic': isPublic,
      if (description != null) 'description': description,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/clips/update',
      body: body,
    );
    return MisskeyClip.fromJson(res);
  }

  /// Deletes a clip (`/api/clips/delete`).
  ///
  /// Pass [clipId] to identify the clip to delete.
  ///
  /// Notable errors:
  /// - `NO_SUCH_CLIP`: The clip does not exist.
  Future<void> delete({required String clipId}) => http.send<Object?>(
        '/clips/delete',
        body: <String, dynamic>{'clipId': clipId},
      );

  /// Retrieves the details of a clip (`/api/clips/show`).
  ///
  /// Pass [clipId] to identify the clip to retrieve.
  ///
  /// Notable errors:
  /// - `NO_SUCH_CLIP`: The clip does not exist.
  Future<MisskeyClip> show({required String clipId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/clips/show',
      body: <String, dynamic>{'clipId': clipId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyClip.fromJson(res);
  }

  /// Retrieves the authenticated user's clips (`/api/clips/list`).
  ///
  /// Use [limit] to cap the number of results (1-100, default 10).
  /// Pass [sinceId] or [untilId] to paginate by ID, or pass [sinceDate]
  /// or [untilDate] to paginate by Unix timestamp (ms).
  Future<List<MisskeyClip>> list({
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
      '/clips/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyClip.fromJson)
        .toList();
  }

  /// Adds a note to a clip (`/api/clips/add-note`).
  ///
  /// Pass [clipId] to identify the clip and [noteId] to identify the note
  /// to add.
  ///
  /// Notable errors:
  /// - `NO_SUCH_CLIP`: The clip does not exist.
  /// - `NO_SUCH_NOTE`: The note does not exist.
  /// - `ALREADY_CLIPPED`: The note is already clipped.
  /// - `TOO_MANY_CLIP_NOTES`: The clip's note limit has been reached.
  Future<void> addNote({
    required String clipId,
    required String noteId,
  }) =>
      http.send<Object?>(
        '/clips/add-note',
        body: <String, dynamic>{'clipId': clipId, 'noteId': noteId},
      );

  /// Removes a note from a clip (`/api/clips/remove-note`).
  ///
  /// Pass [clipId] to identify the clip and [noteId] to identify the note
  /// to remove.
  ///
  /// Notable errors:
  /// - `NO_SUCH_CLIP`: The clip does not exist.
  /// - `NO_SUCH_NOTE`: The note does not exist.
  Future<void> removeNote({
    required String clipId,
    required String noteId,
  }) =>
      http.send<Object?>(
        '/clips/remove-note',
        body: <String, dynamic>{'clipId': clipId, 'noteId': noteId},
      );

  /// Retrieves the notes in a clip (`/api/clips/notes`).
  ///
  /// Pass [clipId] to identify the clip. Use [limit] to cap the number of
  /// results (1-100, default 10). Pass [sinceId] or [untilId] to paginate
  /// by ID, or pass [sinceDate] or [untilDate] to paginate by Unix timestamp
  /// (ms). Pass [search] for space-separated AND search on note body
  /// (1-100 characters).
  ///
  /// Notable errors:
  /// - `NO_SUCH_CLIP`: The clip does not exist.
  Future<List<MisskeyNote>> notes({
    required String clipId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? search,
  }) async {
    final body = <String, dynamic>{
      'clipId': clipId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (search != null) 'search': search,
    };
    final res = await http.send<List<dynamic>>(
      '/clips/notes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Adds a clip to favorites (`/api/clips/favorite`).
  ///
  /// Pass [clipId] to identify the clip to favorite.
  ///
  /// Notable errors:
  /// - `NO_SUCH_CLIP`: The clip does not exist.
  /// - `ALREADY_FAVORITED`: The clip is already favorited.
  Future<void> favorite({required String clipId}) => http.send<Object?>(
        '/clips/favorite',
        body: <String, dynamic>{'clipId': clipId},
      );

  /// Removes a clip from favorites (`/api/clips/unfavorite`).
  ///
  /// Pass [clipId] to identify the clip to unfavorite.
  ///
  /// Notable errors:
  /// - `NO_SUCH_CLIP`: The clip does not exist.
  /// - `NOT_FAVORITED`: The clip is not favorited.
  Future<void> unfavorite({required String clipId}) => http.send<Object?>(
        '/clips/unfavorite',
        body: <String, dynamic>{'clipId': clipId},
      );

  /// Retrieves the authenticated user's favorited clips
  /// (`/api/clips/my-favorites`).
  Future<List<MisskeyClip>> myFavorites() async {
    final res = await http.send<List<dynamic>>(
      '/clips/my-favorites',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyClip.fromJson)
        .toList();
  }
}
