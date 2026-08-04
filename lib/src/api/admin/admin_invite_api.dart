import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/misskey_invite_code.dart';

/// Provides invite code management admin APIs (`/api/admin/invite/*`).
class AdminInviteApi {
  const AdminInviteApi({required this.http});

  final MisskeyHttp http;

  /// Creates invite codes (`/api/admin/invite/create`).
  ///
  /// Requires moderator privileges. Use [count] (1-100, default 1) to
  /// create multiple codes at once. Pass [expiresAt] as an ISO 8601
  /// date-time string to set an expiration.
  Future<List<MisskeyInviteCode>> create({
    int? count,
    String? expiresAt,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/invite/create',
      body: <String, dynamic>{
        if (count != null) 'count': count,
        if (expiresAt != null) 'expiresAt': expiresAt,
      },
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyInviteCode.fromJson)
        .toList();
  }

  /// Fetches issued invite codes (`/api/admin/invite/list`).
  ///
  /// Requires moderator privileges. Use [limit] (1-100, default 30) and
  /// [offset] for paging. [type] filters by state (`unused`, `used`,
  /// `expired`, `all`). Pass [sort] such as `+createdAt` / `-createdAt` /
  /// `+usedAt` / `-usedAt`.
  Future<List<MisskeyInviteCode>> list({
    int? limit,
    int? offset,
    String? type,
    String? sort,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/invite/list',
      body: <String, dynamic>{
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (type != null) 'type': type,
        if (sort != null) 'sort': sort,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyInviteCode.fromJson)
        .toList();
  }
}
