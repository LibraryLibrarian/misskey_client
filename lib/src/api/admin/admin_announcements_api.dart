import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../internal/request_body.dart';
import '../../models/admin/misskey_admin_announcement.dart';

/// Provides announcement management admin APIs
/// (`/api/admin/announcements/*`).
///
/// All endpoints require moderator privileges.
class AdminAnnouncementsApi {
  @internal
  const AdminAnnouncementsApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Creates an announcement (`/api/admin/announcements/create`).
  ///
  /// [icon] is `info`, `warning`, `error`, or `success` (default `info`).
  /// [display] is `normal`, `banner`, or `dialog` (default `normal`).
  /// Pass [userId] to create a user-specific announcement.
  /// [autoArchiveAt] schedules archiving at a Unix timestamp in milliseconds
  /// (Misskey 2026.10.1 or later). Past timestamps are not allowed.
  /// Earlier servers ignore this parameter without returning an error.
  ///
  /// Common errors:
  /// - `INVALID_AUTO_ARCHIVE_AT`: The scheduled archive time is in the past
  Future<MisskeyAdminAnnouncement> create({
    required String title,
    required String text,
    String? imageUrl,
    String? icon,
    String? display,
    bool? forExistingUsers,
    bool? silence,
    bool? needConfirmationToRead,
    String? userId,
    int? autoArchiveAt,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/announcements/create',
      body: <String, dynamic>{
        'title': title,
        'text': text,
        // imageUrlはnull込みで必須パラメータ
        'imageUrl': imageUrl,
        'icon': ?icon,
        'display': ?display,
        'forExistingUsers': ?forExistingUsers,
        'silence': ?silence,
        'needConfirmationToRead': ?needConfirmationToRead,
        'userId': ?userId,
        'autoArchiveAt': ?autoArchiveAt,
      },
    );
    return MisskeyAdminAnnouncement.fromJson(res);
  }

  /// Fetches announcements (`/api/admin/announcements/list`).
  ///
  /// Use [limit] (1-100, default 10) to cap the number of results and
  /// [sinceId] / [untilId] for cursor-based pagination. [sinceDate] /
  /// [untilDate] paginate by Unix timestamp in milliseconds. [status]
  /// filters by state (`all`, `active`, `archived`; default `active`).
  /// Pass [userId] to fetch user-specific announcements.
  Future<List<MisskeyAdminAnnouncement>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    String? userId,
    String? status,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/announcements/list',
      body: <String, dynamic>{
        'limit': ?limit,
        'sinceId': ?sinceId,
        'untilId': ?untilId,
        'sinceDate': ?sinceDate,
        'untilDate': ?untilDate,
        'userId': ?userId,
        'status': ?status,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAdminAnnouncement.fromJson)
        .toList();
  }

  /// Updates an announcement (`/api/admin/announcements/update`).
  ///
  /// Only the parameters that are provided are sent; omitted parameters
  /// remain unchanged. Set [isActive] to `false` to archive the
  /// announcement. It is also treated as inactive once [autoArchiveAt] passes.
  ///
  /// For [imageUrl], use the [Optional] type: pass `Optional('value')` to set
  /// and `Optional.null_()` to clear.
  /// [autoArchiveAt] schedules archiving at a non-negative Unix timestamp in
  /// milliseconds (Misskey 2026.10.1 or later); use `Optional.null_()` to clear
  /// the schedule. Earlier servers ignore this parameter without returning
  /// an error.
  ///
  /// Beware that this endpoint always overwrites `imageUrl`: the server
  /// evaluates it as `imageUrl || null`, so omitting the parameter clears the
  /// existing image rather than keeping it. Pass the current value explicitly
  /// to preserve it. An empty string is stored as `null` for the same reason
  /// (deliberate on the server's side, so that an emptied input field clears
  /// the image). The other parameters are not affected.
  ///
  /// Common errors:
  /// - `NO_SUCH_ANNOUNCEMENT`: The specified announcement does not exist
  /// - `INVALID_AUTO_ARCHIVE_AT`: The scheduled archive time is negative
  Future<void> update({
    required String id,
    String? title,
    String? text,
    Optional<String>? imageUrl,
    String? icon,
    String? display,
    bool? forExistingUsers,
    bool? silence,
    bool? needConfirmationToRead,
    bool? isActive,
    Optional<int>? autoArchiveAt,
  }) {
    final body = <String, dynamic>{
      'id': id,
      'title': ?title,
      'text': ?text,
      'icon': ?icon,
      'display': ?display,
      'forExistingUsers': ?forExistingUsers,
      'silence': ?silence,
      'needConfirmationToRead': ?needConfirmationToRead,
      'isActive': ?isActive,
    };
    putOptional(body, 'imageUrl', imageUrl);
    putOptional(body, 'autoArchiveAt', autoArchiveAt);
    return http.send<Object?>('/admin/announcements/update', body: body);
  }

  /// Deletes an announcement (`/api/admin/announcements/delete`).
  ///
  /// Common errors:
  /// - `NO_SUCH_ANNOUNCEMENT`: The specified announcement does not exist
  Future<void> delete({required String id}) => http.send<Object?>(
    '/admin/announcements/delete',
    body: <String, dynamic>{'id': id},
  );
}
