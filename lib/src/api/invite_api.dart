import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_invite_code.dart';

/// Provides invite code API endpoints (`/api/invite/*`).
///
/// Supports creating, deleting, listing invite codes and checking
/// remaining invite quota on invitation-only servers.
/// All endpoints require authentication and the `canInvite` role policy.
class InviteApi {
  const InviteApi({required this.http});

  final MisskeyHttp http;

  /// Creates a new invite code (`/api/invite/create`).
  ///
  /// Generates a time-limited ticket based on the role policy quota.
  ///
  /// Common errors:
  /// - `EXCEEDED_LIMIT_OF_CREATE_INVITE_CODE`:
  ///   Invite code creation limit exceeded
  Future<MisskeyInviteCode> create() async {
    final res = await http.send<Map<String, dynamic>>(
      '/invite/create',
      body: const <String, dynamic>{},
    );
    return MisskeyInviteCode.fromJson(res);
  }

  /// Deletes an invite code (`/api/invite/delete`).
  ///
  /// Pass [inviteId] to identify the invite code to remove.
  ///
  /// Common errors:
  /// - `NO_SUCH_INVITE_CODE`: The specified invite code does not exist
  /// - `CAN_NOT_DELETE_INVITE_CODE`: This invite code cannot be deleted
  /// - `ACCESS_DENIED`: Not the creator or a moderator
  Future<void> delete({required String inviteId}) => http.send<Object?>(
        '/invite/delete',
        body: <String, dynamic>{'inviteId': inviteId},
      );

  /// Retrieves the remaining invite quota (`/api/invite/limit`).
  ///
  /// Returns `null` if there is no limit.
  Future<int?> limit() async {
    final res = await http.send<Map<String, dynamic>>(
      '/invite/limit',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res['remaining'] as int?;
  }

  /// Lists invite codes created by the authenticated user (`/api/invite/list`).
  ///
  /// Use [limit] to cap the number of results (1–100, default 30).
  /// Pass [sinceId] or [untilId] for cursor-based pagination by ID,
  /// or [sinceDate] / [untilDate] for pagination by Unix timestamp (ms).
  Future<List<MisskeyInviteCode>> list({
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
      '/invite/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyInviteCode.fromJson)
        .toList();
  }
}
