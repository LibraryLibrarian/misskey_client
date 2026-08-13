import 'package:meta/meta.dart';

import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_renote_muting.dart';

/// Provides renote mute API endpoints (`/api/renote-mute/*`).
///
/// Allows muting only renotes from a specific user.
/// Unlike regular muting, the target user's original notes
/// remain visible in the timeline.
class RenoteMuteApi {
  const RenoteMuteApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Mutes renotes from a user (`/api/renote-mute/create`).
  ///
  /// Rate limit: 20 requests/hour.
  ///
  /// Pass [userId] to identify the user whose renotes should be muted.
  ///
  /// Common errors:
  /// - `NO_SUCH_USER`: The target user does not exist
  /// - `MUTEE_IS_YOURSELF`: Specified yourself
  /// - `ALREADY_MUTING`: Already renote-muting this user
  Future<void> create({required String userId}) => http.send<Object?>(
    '/renote-mute/create',
    body: <String, dynamic>{'userId': userId},
  );

  /// Unmutes renotes from a user (`/api/renote-mute/delete`).
  ///
  /// Pass [userId] to identify the user whose renotes should be unmuted.
  ///
  /// Common errors:
  /// - `NO_SUCH_USER`: The target user does not exist
  /// - `MUTEE_IS_YOURSELF`: Specified yourself
  /// - `NOT_MUTING`: Not renote-muting this user
  Future<void> delete({required String userId}) => http.send<Object?>(
    '/renote-mute/delete',
    body: <String, dynamic>{'userId': userId},
  );

  /// Lists users whose renotes are muted (`/api/renote-mute/list`).
  ///
  /// Use [limit] to cap the number of results (1–100, default 30).
  /// Pass [sinceId] or [untilId] for cursor-based pagination by ID,
  /// or [sinceDate] / [untilDate] for pagination by Unix timestamp (ms).
  Future<List<MisskeyRenoteMuting>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'limit': ?limit,
      'sinceId': ?sinceId,
      'untilId': ?untilId,
      'sinceDate': ?sinceDate,
      'untilDate': ?untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/renote-mute/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRenoteMuting.fromJson)
        .toList();
  }
}
