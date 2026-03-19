import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_clip.dart';
import '../models/misskey_note.dart';
import '../models/misskey_note_draft.dart';
import '../models/misskey_note_partial.dart';
import '../models/misskey_note_reaction.dart';
import '../models/misskey_note_state.dart';
import '../models/misskey_note_translation.dart';

/// Provides note-related API endpoints.
class NotesApi {
  const NotesApi({required this.http});

  final MisskeyHttp http;

  /// Fetches public notes (`/api/notes`).
  ///
  /// Returns notes with `visibility = public` and `localOnly = false`.
  /// No authentication required.
  ///
  /// Set [local] to `true` to restrict results to local posts only
  /// (default: false).
  /// Use [reply], [renote], [withFiles], and [poll] to filter by note type
  /// (pass `null` for no filter on each).
  /// Use [limit] to cap the number of results (1–100, default 10).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in
  /// Unix milliseconds.
  Future<List<MisskeyNote>> list({
    bool? local,
    bool? reply,
    bool? renote,
    bool? withFiles,
    bool? poll,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (local != null) 'local': local,
      if (reply != null) 'reply': reply,
      if (renote != null) 'renote': renote,
      if (withFiles != null) 'withFiles': withFiles,
      if (poll != null) 'poll': poll,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches the home timeline (`/api/notes/timeline`).
  ///
  /// Returns notes from followed users. Authentication required.
  ///
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  /// Set [allowPartial] to `true` to return partial results even if the cache
  /// is insufficient. Use [includeMyRenotes], [includeRenotedMyNotes], and
  /// [includeLocalRenotes] to control renote inclusion (all default to `true`).
  Future<List<MisskeyNote>> timelineHome({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
    bool? withRenotes,
    bool? withFiles,
    bool? includeMyRenotes,
    bool? includeRenotedMyNotes,
    bool? includeLocalRenotes,
  }) =>
      _fetchTimeline(
        path: '/notes/timeline',
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
        allowPartial: allowPartial,
        withRenotes: withRenotes,
        withFiles: withFiles,
        includeMyRenotes: includeMyRenotes,
        includeRenotedMyNotes: includeRenotedMyNotes,
        includeLocalRenotes: includeLocalRenotes,
        authMode: AuthMode.required,
      );

  /// Fetches the global timeline (`/api/notes/global-timeline`).
  ///
  /// Returns public notes from the entire server.
  /// No authentication required (may be restricted by role policy).
  Future<List<MisskeyNote>> timelineGlobal({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? withRenotes,
    bool? withFiles,
  }) =>
      _fetchTimeline(
        path: '/notes/global-timeline',
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
        withRenotes: withRenotes,
        withFiles: withFiles,
        authMode: AuthMode.optional,
      );

  /// Fetches the hybrid timeline (`/api/notes/hybrid-timeline`).
  ///
  /// Returns a mix of notes from followed users and local public notes.
  /// Authentication required.
  ///
  /// Note that [withReplies] and [withFiles] cannot both be `true`.
  Future<List<MisskeyNote>> timelineHybrid({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
    bool? withRenotes,
    bool? withReplies,
    bool? withFiles,
    bool? includeMyRenotes,
    bool? includeRenotedMyNotes,
    bool? includeLocalRenotes,
  }) =>
      _fetchTimeline(
        path: '/notes/hybrid-timeline',
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
        allowPartial: allowPartial,
        withRenotes: withRenotes,
        withReplies: withReplies,
        withFiles: withFiles,
        includeMyRenotes: includeMyRenotes,
        includeRenotedMyNotes: includeRenotedMyNotes,
        includeLocalRenotes: includeLocalRenotes,
        authMode: AuthMode.required,
      );

  /// Fetches the local timeline (`/api/notes/local-timeline`).
  ///
  /// Returns public notes from local users on this server.
  /// No authentication required (may be restricted by role policy).
  ///
  /// Note that [withReplies] and [withFiles] cannot both be `true`.
  Future<List<MisskeyNote>> timelineLocal({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
    bool? withRenotes,
    bool? withReplies,
    bool? withFiles,
  }) =>
      _fetchTimeline(
        path: '/notes/local-timeline',
        limit: limit,
        sinceId: sinceId,
        untilId: untilId,
        sinceDate: sinceDate,
        untilDate: untilDate,
        allowPartial: allowPartial,
        withRenotes: withRenotes,
        withReplies: withReplies,
        withFiles: withFiles,
        authMode: AuthMode.optional,
      );

  /// Fetches a single note (`/api/notes/show`).
  ///
  /// Returns the details of the note specified by [noteId].
  /// No authentication required.
  ///
  /// Visibility restrictions apply based on authentication state
  /// and server settings.
  Future<MisskeyNote> show({required String noteId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/notes/show',
      body: <String, dynamic>{'noteId': noteId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyNote.fromJson(res);
  }

  /// Fetches replies to a note (`/api/notes/replies`).
  ///
  /// Returns reply notes for the specified [noteId].
  /// No authentication required.
  ///
  /// Use [limit] to cap the number of results (1–100).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  Future<List<MisskeyNote>> replies({
    required String noteId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/replies',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches renotes of a note (`/api/notes/renotes`).
  ///
  /// Returns a list of notes that renoted the specified [noteId].
  /// No authentication required.
  ///
  /// Use [limit] to cap the number of results (1–100).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  Future<List<MisskeyNote>> renotes({
    required String noteId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/renotes',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches reactions on a note (`/api/notes/reactions`).
  ///
  /// Returns a list of reactions on the specified [noteId].
  /// No authentication required.
  /// The response is cached for 60 seconds on the server.
  ///
  /// Pass [type] to filter by reaction type (e.g., `'👍'`, `':like:'`).
  /// Use [limit] to cap the number of results (1–100).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  Future<List<MisskeyNoteReaction>> reactions({
    required String noteId,
    String? type,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (type != null) 'type': type,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/reactions',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNoteReaction.fromJson)
        .toList();
  }

  /// Creates a note (`/api/notes/create`).
  ///
  /// Handles text posts, replies, renotes, and quote renotes.
  /// When [channelId] is specified, [visibility], [localOnly], and
  /// [visibleUserIds] are ignored by the server and thus omitted
  /// from the request body.
  ///
  /// Pass [pollChoices] (min 2, max 10) to attach a poll.
  /// Set [pollMultiple] to `true` to allow multiple selections.
  /// Specify the poll deadline using either [pollExpiresAt] (absolute epoch ms)
  /// or [pollExpiredAfter] (relative ms from now, min 1) -- not both.
  ///
  /// The response object contains the created note under the `createdNote` key.
  Future<MisskeyNote> create({
    String? text,
    String? cw,
    String? visibility,
    List<String>? visibleUserIds,
    bool? localOnly,
    String? reactionAcceptance,
    bool? noExtractMentions,
    bool? noExtractHashtags,
    bool? noExtractEmojis,
    String? replyId,
    String? renoteId,
    String? channelId,
    List<String>? fileIds,
    List<String>? mediaIds,
    // Poll parameters
    List<String>? pollChoices,
    bool? pollMultiple,
    int? pollExpiresAt,
    int? pollExpiredAfter,
  }) async {
    final hasContent = text != null ||
        renoteId != null ||
        (fileIds != null && fileIds.isNotEmpty) ||
        (mediaIds != null && mediaIds.isNotEmpty) ||
        (pollChoices != null && pollChoices.isNotEmpty);
    if (!hasContent) {
      throw ArgumentError(
        'text, renoteId, fileIds, mediaIds, pollChoices の'
        'いずれかを指定してください',
      );
    }

    final body = <String, dynamic>{
      if (text != null) 'text': text,
      if (cw != null) 'cw': cw,
      if (replyId != null) 'replyId': replyId,
      if (renoteId != null) 'renoteId': renoteId,
      if (channelId != null) 'channelId': channelId,
      if (reactionAcceptance != null) 'reactionAcceptance': reactionAcceptance,
      if (noExtractMentions != null) 'noExtractMentions': noExtractMentions,
      if (noExtractHashtags != null) 'noExtractHashtags': noExtractHashtags,
      if (noExtractEmojis != null) 'noExtractEmojis': noExtractEmojis,
    };

    if (channelId == null) {
      if (visibility != null) body['visibility'] = visibility;
      if (localOnly != null) body['localOnly'] = localOnly;
      if (visibleUserIds != null && visibleUserIds.isNotEmpty) {
        body['visibleUserIds'] = visibleUserIds;
      }
    }

    if (fileIds != null && fileIds.isNotEmpty) {
      body['fileIds'] = fileIds;
    }
    if (mediaIds != null && mediaIds.isNotEmpty) {
      body['mediaIds'] = mediaIds;
    }

    if (pollChoices != null && pollChoices.isNotEmpty) {
      final poll = <String, dynamic>{'choices': pollChoices};
      if (pollMultiple != null) poll['multiple'] = pollMultiple;
      if (pollExpiresAt != null) poll['expiresAt'] = pollExpiresAt;
      if (pollExpiredAfter != null) poll['expiredAfter'] = pollExpiredAfter;
      body['poll'] = poll;
    }

    final res = await http.send<Map<String, dynamic>>(
      '/notes/create',
      body: body,
    );
    final raw = (res['createdNote'] is Map<String, dynamic>)
        ? res['createdNote'] as Map<String, dynamic>
        : res;
    return MisskeyNote.fromJson(raw);
  }

  /// Votes on a poll attached to a note (`/api/notes/polls/vote`).
  ///
  /// Specify the note containing the poll in [noteId].
  /// Specify the zero-based choice index in [choice].
  Future<void> pollsVote({
    required String noteId,
    required int choice,
  }) =>
      http.send<Object?>(
        '/notes/polls/vote',
        body: <String, dynamic>{'noteId': noteId, 'choice': choice},
      );

  /// Adds a reaction to a note (`/api/notes/reactions/create`).
  ///
  /// Specify a Unicode emoji (e.g., `'👍'`) or a shortcode
  /// (e.g., `':like:'`) in [reaction].
  Future<void> reactionsCreate({
    required String noteId,
    required String reaction,
  }) =>
      http.send<Object?>(
        '/notes/reactions/create',
        body: <String, dynamic>{
          'noteId': noteId,
          'reaction': reaction,
        },
      );

  /// Removes the authenticated user's reaction from a note (`/api/notes/reactions/delete`).
  Future<void> reactionsDelete({required String noteId}) => http.send<Object?>(
        '/notes/reactions/delete',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// Deletes a note (`/api/notes/delete`).
  ///
  /// Deletes own note or another user's note with moderator privileges.
  /// Authentication required.
  Future<void> delete({required String noteId}) => http.send<Object?>(
        '/notes/delete',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// Cancels a renote of a note (`/api/notes/unrenote`).
  ///
  /// Deletes all renotes of the specified [noteId] by the authenticated user.
  /// Authentication required. Rate limit: 300 requests/hour, min interval 1 second.
  Future<void> unrenote({required String noteId}) => http.send<Object?>(
        '/notes/unrenote',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// Fetches child notes (replies and quote renotes) of a note (`/api/notes/children`).
  ///
  /// Returns replies and quote renotes for the specified [noteId].
  /// Authentication optional.
  ///
  /// Use [limit] to cap the number of results (1–100, default 10).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  Future<List<MisskeyNote>> children({
    required String noteId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/children',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches public clips containing a note (`/api/notes/clips`).
  ///
  /// Returns public clips that include the specified [noteId].
  /// Authentication optional.
  Future<List<MisskeyClip>> clips({required String noteId}) async {
    final res = await http.send<List<dynamic>>(
      '/notes/clips',
      body: <String, dynamic>{'noteId': noteId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyClip.fromJson)
        .toList();
  }

  /// Fetches the conversation thread by traversing the reply chain (`/api/notes/conversation`).
  ///
  /// Recursively retrieves parent notes of the specified [noteId].
  /// Authentication optional.
  ///
  /// Use [limit] to cap the number of results (1–100, default 10).
  /// Use [offset] to skip results (default: 0).
  Future<List<MisskeyNote>> conversation({
    required String noteId,
    int? limit,
    int? offset,
  }) async {
    final body = <String, dynamic>{
      'noteId': noteId,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/conversation',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches featured (trending) notes (`/api/notes/featured`).
  ///
  /// Returns ranked featured notes. Authentication optional.
  ///
  /// Use [limit] to cap the number of results (1–100, default 10).
  /// Pass [untilId] for cursor-based pagination.
  /// Pass [channelId] to filter results to a specific channel.
  Future<List<MisskeyNote>> featured({
    int? limit,
    String? untilId,
    String? channelId,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (untilId != null) 'untilId': untilId,
      if (channelId != null) 'channelId': channelId,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/featured',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches mentions addressed to the authenticated user (`/api/notes/mentions`).
  ///
  /// Returns notes that mention the authenticated user.
  /// Authentication required.
  ///
  /// Set [following] to `true` to restrict results to followed users
  /// only (default: false).
  /// Pass [visibility] to filter by visibility scope.
  /// Use [limit] to cap the number of results (1–100, default 10).
  Future<List<MisskeyNote>> mentions({
    bool? following,
    String? visibility,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      if (following != null) 'following': following,
      if (visibility != null) 'visibility': visibility,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/mentions',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Performs a full-text search on notes (`/api/notes/search`).
  ///
  /// Returns notes matching [query]. Authentication optional.
  ///
  /// Pass [host] to filter by host (`"."` for local), [userId] to filter by
  /// a specific user, or [channelId] to filter by channel.
  /// Use [offset] to skip results (default: 0).
  Future<List<MisskeyNote>> search({
    required String query,
    int? limit,
    int? offset,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? host,
    String? userId,
    String? channelId,
  }) async {
    final body = <String, dynamic>{
      'query': query,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (host != null) 'host': host,
      if (userId != null) 'userId': userId,
      if (channelId != null) 'channelId': channelId,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/search',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Searches notes by hashtag (`/api/notes/search-by-tag`).
  ///
  /// Specify either [tag] or [queryTags].
  /// [queryTags] is a nested array where the outer level is OR-joined
  /// and the inner level is AND-joined.
  /// Authentication optional.
  ///
  /// Use [reply], [renote], and [poll] to filter by note type (pass `null`
  /// for no filter). Set [withFiles] to `true` to return only notes with
  /// attached files (default: false).
  Future<List<MisskeyNote>> searchByTag({
    String? tag,
    List<List<String>>? queryTags,
    bool? reply,
    bool? renote,
    bool? withFiles,
    bool? poll,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    assert(
      tag != null || queryTags != null,
      'tag か queryTags のいずれかを指定してください',
    );
    final body = <String, dynamic>{
      if (tag != null) 'tag': tag,
      if (queryTags != null) 'query': queryTags,
      if (reply != null) 'reply': reply,
      if (renote != null) 'renote': renote,
      if (withFiles != null) 'withFiles': withFiles,
      if (poll != null) 'poll': poll,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/search-by-tag',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches reaction data for multiple notes in bulk (`/api/notes/show-partial-bulk`).
  ///
  /// Returns only reaction counts and emoji information for each note.
  /// A lightweight endpoint. No authentication required.
  ///
  /// Pass [noteIds] as a list of 1–100 target note IDs.
  Future<List<MisskeyNotePartial>> showPartialBulk({
    required List<String> noteIds,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/notes/show-partial-bulk',
      body: <String, dynamic>{'noteIds': noteIds},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNotePartial.fromJson)
        .toList();
  }

  /// Fetches the state of a note (`/api/notes/state`).
  ///
  /// Returns the authenticated user's state for the note
  /// (favorited, thread muted). Authentication required.
  Future<MisskeyNoteState> state({required String noteId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/notes/state',
      body: <String, dynamic>{'noteId': noteId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyNoteState.fromJson(res);
  }

  /// Translates a note (`/api/notes/translate`).
  ///
  /// Translates note text using a translation service such as DeepL.
  /// Authentication required.
  /// Returns an error if the translation service is not enabled on the server
  /// or the user lacks the `canUseTranslator` permission.
  ///
  /// Specify the note to translate in [noteId] and the target language
  /// code in [targetLang] (e.g., `'ja'`, `'en'`).
  Future<MisskeyNoteTranslation> translate({
    required String noteId,
    required String targetLang,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/notes/translate',
      body: <String, dynamic>{
        'noteId': noteId,
        'targetLang': targetLang,
      },
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyNoteTranslation.fromJson(res);
  }

  /// Fetches the user list timeline (`/api/notes/user-list-timeline`).
  ///
  /// Returns notes from users in the specified [listId].
  /// Authentication required.
  ///
  /// Set [withRenotes] to `false` to omit renotes (default: true), or
  /// [withFiles] to `true` to return only notes with attached files
  /// (default: false).
  /// Use [includeMyRenotes], [includeRenotedMyNotes], and [includeLocalRenotes]
  /// to control renote inclusion (all default to `true`).
  Future<List<MisskeyNote>> timelineUserList({
    required String listId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
    bool? withRenotes,
    bool? withFiles,
    bool? includeMyRenotes,
    bool? includeRenotedMyNotes,
    bool? includeLocalRenotes,
  }) async {
    final body = <String, dynamic>{
      'listId': listId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (allowPartial != null) 'allowPartial': allowPartial,
      if (withRenotes != null) 'withRenotes': withRenotes,
      if (withFiles != null) 'withFiles': withFiles,
      if (includeMyRenotes != null) 'includeMyRenotes': includeMyRenotes,
      if (includeRenotedMyNotes != null)
        'includeRenotedMyNotes': includeRenotedMyNotes,
      if (includeLocalRenotes != null)
        'includeLocalRenotes': includeLocalRenotes,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/user-list-timeline',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Adds a note to favorites (`/api/notes/favorites/create`).
  ///
  /// Authentication required. Rate limit: 20 requests/hour.
  Future<void> favoritesCreate({required String noteId}) => http.send<Object?>(
        '/notes/favorites/create',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// Removes a note from favorites (`/api/notes/favorites/delete`).
  ///
  /// Authentication required.
  Future<void> favoritesDelete({required String noteId}) => http.send<Object?>(
        '/notes/favorites/delete',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// Fetches recommended polls (`/api/notes/polls/recommendation`).
  ///
  /// Returns public polls that the user has not voted on yet.
  /// Authentication required.
  ///
  /// Use [limit] to cap the number of results (1–100, default 10).
  /// Use [offset] to skip results (default: 0).
  /// Set [excludeChannels] to `true` to omit polls in channels
  /// (default: false).
  Future<List<MisskeyNote>> pollsRecommendation({
    int? limit,
    int? offset,
    bool? excludeChannels,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (excludeChannels != null) 'excludeChannels': excludeChannels,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/polls/recommendation',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Mutes a thread (`/api/notes/thread-muting/create`).
  ///
  /// Stops notifications from the thread of the specified [noteId].
  /// Authentication required. Rate limit: 10 requests/hour.
  Future<void> threadMutingCreate({required String noteId}) =>
      http.send<Object?>(
        '/notes/thread-muting/create',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// Unmutes a thread (`/api/notes/thread-muting/delete`).
  ///
  /// Authentication required.
  Future<void> threadMutingDelete({required String noteId}) =>
      http.send<Object?>(
        '/notes/thread-muting/delete',
        body: <String, dynamic>{'noteId': noteId},
      );

  /// Retrieves the draft count (`/api/notes/drafts/count`).
  ///
  /// Authentication required.
  Future<int> draftsCount() async {
    final res = await http.send<int>(
      '/notes/drafts/count',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res;
  }

  /// Lists drafts (`/api/notes/drafts/list`).
  ///
  /// Authentication required.
  ///
  /// Use [limit] to cap the number of results (1–100, default 30).
  /// Set [scheduled] to `true` or `false` to filter by scheduled status
  /// (pass `null` for no filter).
  Future<List<MisskeyNoteDraft>> draftsList({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? scheduled,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (scheduled != null) 'scheduled': scheduled,
    };
    final res = await http.send<List<dynamic>>(
      '/notes/drafts/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNoteDraft.fromJson)
        .toList();
  }

  /// Creates a draft (`/api/notes/drafts/create`).
  ///
  /// Authentication required. Rate limit: 300 requests/hour.
  ///
  /// Set [visibility] to control the audience scope (default: `public`);
  /// supply [visibleUserIds] when using `specified` visibility.
  /// Use [cw] for a content warning (max 100 characters) and [hashtag] to
  /// attach a hashtag (max 200 characters). Set [localOnly] to `true` to
  /// restrict delivery to the local server (default: false).
  /// Pass [reactionAcceptance] to configure which reactions are accepted.
  /// Supply [replyId], [renoteId], or [channelId] to associate the draft with
  /// a thread, renote, or channel respectively. Provide [text] for the body
  /// and [fileIds] for attached files (max 16).
  /// To attach a poll, pass [pollChoices] (max 10 items), set [pollMultiple]
  /// to allow multiple selections, and specify the deadline via either
  /// [pollExpiresAt] (absolute epoch ms) or [pollExpiredAfter] (relative ms,
  /// min 1). To schedule the post, pass [scheduledAt] (Unix timestamp ms) and
  /// set [isActuallyScheduled] to `true` (default: false).
  Future<MisskeyNoteDraft> draftsCreate({
    String? visibility,
    List<String>? visibleUserIds,
    String? cw,
    String? hashtag,
    bool? localOnly,
    String? reactionAcceptance,
    String? replyId,
    String? renoteId,
    String? channelId,
    String? text,
    List<String>? fileIds,
    List<String>? pollChoices,
    bool? pollMultiple,
    int? pollExpiresAt,
    int? pollExpiredAfter,
    int? scheduledAt,
    bool? isActuallyScheduled,
  }) async {
    final body = <String, dynamic>{
      if (visibility != null) 'visibility': visibility,
      if (visibleUserIds != null) 'visibleUserIds': visibleUserIds,
      if (cw != null) 'cw': cw,
      if (hashtag != null) 'hashtag': hashtag,
      if (localOnly != null) 'localOnly': localOnly,
      if (reactionAcceptance != null) 'reactionAcceptance': reactionAcceptance,
      if (replyId != null) 'replyId': replyId,
      if (renoteId != null) 'renoteId': renoteId,
      if (channelId != null) 'channelId': channelId,
      if (text != null) 'text': text,
      if (fileIds != null) 'fileIds': fileIds,
      if (scheduledAt != null) 'scheduledAt': scheduledAt,
      if (isActuallyScheduled != null)
        'isActuallyScheduled': isActuallyScheduled,
    };
    if (pollChoices != null && pollChoices.isNotEmpty) {
      final poll = <String, dynamic>{'choices': pollChoices};
      if (pollMultiple != null) poll['multiple'] = pollMultiple;
      if (pollExpiresAt != null) poll['expiresAt'] = pollExpiresAt;
      if (pollExpiredAfter != null) poll['expiredAfter'] = pollExpiredAfter;
      body['poll'] = poll;
    }
    final res = await http.send<Map<String, dynamic>>(
      '/notes/drafts/create',
      body: body,
    );
    final raw = (res['createdDraft'] is Map<String, dynamic>)
        ? res['createdDraft'] as Map<String, dynamic>
        : res;
    return MisskeyNoteDraft.fromJson(raw);
  }

  /// Updates a draft (`/api/notes/drafts/update`).
  ///
  /// Authentication required. Only specified fields are updated.
  ///
  /// Pass the ID of the draft to update in [draftId].
  /// All other parameters are the same as [draftsCreate].
  Future<MisskeyNoteDraft> draftsUpdate({
    required String draftId,
    String? visibility,
    List<String>? visibleUserIds,
    String? cw,
    String? hashtag,
    bool? localOnly,
    String? reactionAcceptance,
    String? replyId,
    String? renoteId,
    String? channelId,
    String? text,
    List<String>? fileIds,
    List<String>? pollChoices,
    bool? pollMultiple,
    int? pollExpiresAt,
    int? pollExpiredAfter,
    int? scheduledAt,
    bool? isActuallyScheduled,
  }) async {
    final body = <String, dynamic>{
      'draftId': draftId,
      if (visibility != null) 'visibility': visibility,
      if (visibleUserIds != null) 'visibleUserIds': visibleUserIds,
      if (cw != null) 'cw': cw,
      if (hashtag != null) 'hashtag': hashtag,
      if (localOnly != null) 'localOnly': localOnly,
      if (reactionAcceptance != null) 'reactionAcceptance': reactionAcceptance,
      if (replyId != null) 'replyId': replyId,
      if (renoteId != null) 'renoteId': renoteId,
      if (channelId != null) 'channelId': channelId,
      if (text != null) 'text': text,
      if (fileIds != null) 'fileIds': fileIds,
      if (scheduledAt != null) 'scheduledAt': scheduledAt,
      if (isActuallyScheduled != null)
        'isActuallyScheduled': isActuallyScheduled,
    };
    if (pollChoices != null && pollChoices.isNotEmpty) {
      final poll = <String, dynamic>{'choices': pollChoices};
      if (pollMultiple != null) poll['multiple'] = pollMultiple;
      if (pollExpiresAt != null) poll['expiresAt'] = pollExpiresAt;
      if (pollExpiredAfter != null) poll['expiredAfter'] = pollExpiredAfter;
      body['poll'] = poll;
    }
    final res = await http.send<Map<String, dynamic>>(
      '/notes/drafts/update',
      body: body,
    );
    final raw = (res['updatedDraft'] is Map<String, dynamic>)
        ? res['updatedDraft'] as Map<String, dynamic>
        : res;
    return MisskeyNoteDraft.fromJson(raw);
  }

  /// Deletes a draft (`/api/notes/drafts/delete`).
  ///
  /// Authentication required.
  Future<void> draftsDelete({required String draftId}) => http.send<Object?>(
        '/notes/drafts/delete',
        body: <String, dynamic>{'draftId': draftId},
      );

  /// Resolves a list of username tokens to user IDs.
  ///
  /// Each token accepts any of the following formats:
  /// `'librarian'`, `'librarian@misskey.io'`, or `'@librarian@misskey.io'`.
  /// Unresolvable tokens are silently skipped, and resolution failures
  /// are logged at debug level via [MisskeyHttp.logger].
  Future<List<String>> resolveUsernamesToIds(List<String> tokens) async {
    final results = <String>[];
    for (final raw in tokens) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;

      var username = trimmed.startsWith('@') ? trimmed.substring(1) : trimmed;
      String? host;
      if (username.contains('@')) {
        final parts = username.split('@');
        username = parts.first;
        host = parts.sublist(1).join('@');
      }

      try {
        final res = await http.send<List<dynamic>>(
          '/users/search-by-username-and-host',
          body: <String, dynamic>{
            'username': username,
            if (host != null && host.isNotEmpty) 'host': host,
            'limit': 1,
          },
          options: const RequestOptions(
            authMode: AuthMode.optional,
            idempotent: true,
          ),
        );
        if (res.isNotEmpty && res.first is Map) {
          final user =
              (res.first as Map<dynamic, dynamic>).cast<String, dynamic>();
          final id = (user['id'] ?? '').toString();
          if (id.isNotEmpty) results.add(id);
        }
      } on Exception catch (e) {
        if (http.config.enableLog) {
          http.logger.debug(
            'resolveUsernamesToIds: failed to resolve'
            ' token="$trimmed": $e',
          );
        }
      }
    }
    return results;
  }

  Future<List<MisskeyNote>> _fetchTimeline({
    required String path,
    int? limit,
    required AuthMode authMode,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? allowPartial,
    bool? withRenotes,
    bool? withReplies,
    bool? withFiles,
    bool? includeMyRenotes,
    bool? includeRenotedMyNotes,
    bool? includeLocalRenotes,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (allowPartial != null) 'allowPartial': allowPartial,
      if (withRenotes != null) 'withRenotes': withRenotes,
      if (withReplies != null) 'withReplies': withReplies,
      if (withFiles != null) 'withFiles': withFiles,
      if (includeMyRenotes != null) 'includeMyRenotes': includeMyRenotes,
      if (includeRenotedMyNotes != null)
        'includeRenotedMyNotes': includeRenotedMyNotes,
      if (includeLocalRenotes != null)
        'includeLocalRenotes': includeLocalRenotes,
    };

    final res = await http.send<List<dynamic>>(
      path,
      body: body,
      options: RequestOptions(authMode: authMode, idempotent: true),
    );

    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }
}
