import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_blocking.dart';
import '../models/misskey_user.dart';

/// Provides blocking APIs (`/api/blocking/*`).
///
/// Offers blocking, unblocking, and listing blocked users.
class BlockingApi {
  const BlockingApi({required this.http});

  final MisskeyHttp http;

  /// Blocks a user (`/api/blocking/create`).
  ///
  /// Blocking removes the mutual follow relationship. Pass the target user's
  /// ID as [userId]. Rate limit: 20 per hour.
  ///
  /// Common errors:
  /// - `NO_SUCH_USER`: The target user does not exist
  /// - `BLOCKEE_IS_YOURSELF`: Attempted to block yourself
  /// - `ALREADY_BLOCKING`: Already blocking the user
  Future<MisskeyUser> create({required String userId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/blocking/create',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Unblocks a user (`/api/blocking/delete`).
  ///
  /// Pass the target user's ID as [userId]. Rate limit: 100 per hour.
  ///
  /// Common errors:
  /// - `NO_SUCH_USER`: The target user does not exist
  /// - `BLOCKEE_IS_YOURSELF`: Specified yourself
  /// - `NOT_BLOCKING`: Not blocking the user
  Future<MisskeyUser> delete({required String userId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/blocking/delete',
      body: <String, dynamic>{'userId': userId},
    );
    return MisskeyUser.fromJson(res);
  }

  /// Retrieves the list of blocked users (`/api/blocking/list`).
  ///
  /// Use [limit] to cap the number of items (1-100, default 30). Paginate by
  /// ID with [sinceId] and [untilId], or by Unix timestamp (ms) with
  /// [sinceDate] and [untilDate].
  Future<List<MisskeyBlocking>> list({
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
      '/blocking/list',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyBlocking.fromJson)
        .toList();
  }
}
