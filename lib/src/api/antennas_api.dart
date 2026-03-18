import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_antenna.dart';
import '../models/misskey_note.dart';

/// Provides antenna APIs (`/api/antennas/*`).
///
/// Offers creation, updating, deletion, listing, and note retrieval for
/// custom timeline filters (antennas). All endpoints require authentication.
class AntennasApi {
  const AntennasApi({required this.http});

  final MisskeyHttp http;

  /// Creates an antenna (`/api/antennas/create`).
  ///
  /// [name] (1-100 characters), [src], [keywords], [excludeKeywords],
  /// [users], [caseSensitive], [withReplies], and [withFile] are required.
  /// [src] must be one of `home`, `all`, `users`, `list`, or
  /// `users_blacklist`; when using `list`, supply [userListId].
  /// [keywords] and [excludeKeywords] use outer-OR / inner-AND matching.
  /// Optionally set [localOnly] to target only local notes, [excludeBots] to
  /// skip bot accounts, and [excludeNotesInSensitiveChannel] to skip
  /// sensitive channels.
  ///
  /// Common errors:
  /// - `NO_SUCH_USER_LIST`: The specified user list does not exist
  /// - `TOO_MANY_ANTENNAS`: Antenna limit reached
  /// - `EMPTY_KEYWORD`: Both keywords and excluded keywords are empty
  Future<MisskeyAntenna> create({
    required String name,
    required String src,
    String? userListId,
    required List<List<String>> keywords,
    required List<List<String>> excludeKeywords,
    required List<String> users,
    required bool caseSensitive,
    bool? localOnly,
    bool? excludeBots,
    required bool withReplies,
    required bool withFile,
    bool? excludeNotesInSensitiveChannel,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/antennas/create',
      body: <String, dynamic>{
        'name': name,
        'src': src,
        'userListId': userListId,
        'keywords': keywords,
        'excludeKeywords': excludeKeywords,
        'users': users,
        'caseSensitive': caseSensitive,
        if (localOnly != null) 'localOnly': localOnly,
        if (excludeBots != null) 'excludeBots': excludeBots,
        'withReplies': withReplies,
        'withFile': withFile,
        if (excludeNotesInSensitiveChannel != null)
          'excludeNotesInSensitiveChannel': excludeNotesInSensitiveChannel,
      },
    );
    return MisskeyAntenna.fromJson(res);
  }

  /// Updates an antenna (`/api/antennas/update`).
  ///
  /// Only [antennaId] is required. Other parameters update only the specified
  /// fields.
  ///
  /// Common errors:
  /// - `NO_SUCH_ANTENNA`: The antenna does not exist
  /// - `NO_SUCH_USER_LIST`: The specified user list does not exist
  /// - `EMPTY_KEYWORD`: Both keywords and excluded keywords are empty
  Future<MisskeyAntenna> update({
    required String antennaId,
    String? name,
    String? src,
    String? userListId,
    List<List<String>>? keywords,
    List<List<String>>? excludeKeywords,
    List<String>? users,
    bool? caseSensitive,
    bool? localOnly,
    bool? excludeBots,
    bool? withReplies,
    bool? withFile,
    bool? excludeNotesInSensitiveChannel,
  }) async {
    final body = <String, dynamic>{
      'antennaId': antennaId,
      if (name != null) 'name': name,
      if (src != null) 'src': src,
      if (userListId != null) 'userListId': userListId,
      if (keywords != null) 'keywords': keywords,
      if (excludeKeywords != null) 'excludeKeywords': excludeKeywords,
      if (users != null) 'users': users,
      if (caseSensitive != null) 'caseSensitive': caseSensitive,
      if (localOnly != null) 'localOnly': localOnly,
      if (excludeBots != null) 'excludeBots': excludeBots,
      if (withReplies != null) 'withReplies': withReplies,
      if (withFile != null) 'withFile': withFile,
      if (excludeNotesInSensitiveChannel != null)
        'excludeNotesInSensitiveChannel': excludeNotesInSensitiveChannel,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/antennas/update',
      body: body,
    );
    return MisskeyAntenna.fromJson(res);
  }

  /// Deletes an antenna (`/api/antennas/delete`).
  ///
  /// Pass the target antenna's ID as [antennaId].
  ///
  /// Common errors:
  /// - `NO_SUCH_ANTENNA`: The antenna does not exist
  Future<void> delete({required String antennaId}) => http.send<Object?>(
        '/antennas/delete',
        body: <String, dynamic>{'antennaId': antennaId},
      );

  /// Retrieves the details of an antenna (`/api/antennas/show`).
  ///
  /// Pass the target antenna's ID as [antennaId].
  ///
  /// Common errors:
  /// - `NO_SUCH_ANTENNA`: The antenna does not exist
  Future<MisskeyAntenna> show({required String antennaId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/antennas/show',
      body: <String, dynamic>{'antennaId': antennaId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyAntenna.fromJson(res);
  }

  /// Retrieves the list of antennas (`/api/antennas/list`).
  ///
  /// Returns all antennas owned by the authenticated user.
  Future<List<MisskeyAntenna>> list() async {
    final res = await http.send<List<dynamic>>(
      '/antennas/list',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAntenna.fromJson)
        .toList();
  }

  /// Retrieves notes matching an antenna (`/api/antennas/notes`).
  ///
  /// Pass the target antenna's ID as [antennaId]. Use [limit] to cap the
  /// number of items (1-100, default 10). Paginate by ID with [sinceId] and
  /// [untilId], or by Unix timestamp (ms) with [sinceDate] and [untilDate].
  ///
  /// Common errors:
  /// - `NO_SUCH_ANTENNA`: The antenna does not exist
  Future<List<MisskeyNote>> notes({
    required String antennaId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'antennaId': antennaId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/antennas/notes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }
}
