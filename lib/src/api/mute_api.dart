import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_muting.dart';

/// Provides mute-related API endpoints (`/api/mute/*`).
///
/// Supports muting, unmuting, and listing muted users.
class MuteApi {
  const MuteApi({required this.http});

  final MisskeyHttp http;

  /// Mutes a user (`/api/mute/create`).
  ///
  /// Rate limit: 20 requests/hour.
  ///
  /// Pass the ID of the user to mute in [userId]. Optionally set [expiresAt]
  /// to a Unix timestamp in milliseconds for a time-limited mute; if omitted
  /// the mute is permanent. Specifying a past time has no effect.
  ///
  /// Common errors:
  /// - `NO_SUCH_USER`: The target user does not exist
  /// - `MUTEE_IS_YOURSELF`: Attempted to mute yourself
  /// - `ALREADY_MUTING`: Already muting this user
  Future<void> create({
    required String userId,
    int? expiresAt,
  }) =>
      http.send<Object?>(
        '/mute/create',
        body: <String, dynamic>{
          'userId': userId,
          if (expiresAt != null) 'expiresAt': expiresAt,
        },
      );

  /// Unmutes a user (`/api/mute/delete`).
  ///
  /// Pass the ID of the user to unmute in [userId].
  ///
  /// Common errors:
  /// - `NO_SUCH_USER`: The target user does not exist
  /// - `MUTEE_IS_YOURSELF`: Specified yourself
  /// - `NOT_MUTING`: Not currently muting this user
  Future<void> delete({required String userId}) => http.send<Object?>(
        '/mute/delete',
        body: <String, dynamic>{'userId': userId},
      );

  /// Lists currently muted users (`/api/mute/list`).
  ///
  /// Use [limit] to cap the number of results (1–100, default 30).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  Future<List<MisskeyMuting>> list({
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
      '/mute/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyMuting.fromJson)
        .toList();
  }
}
