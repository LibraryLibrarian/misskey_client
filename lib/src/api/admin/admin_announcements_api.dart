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
  const AdminAnnouncementsApi({required this.http});

  final MisskeyHttp http;

  /// Creates an announcement (`/api/admin/announcements/create`).
  ///
  /// [icon] is `info`, `warning`, `error`, or `success` (default `info`).
  /// [display] is `normal`, `banner`, or `dialog` (default `normal`).
  /// Pass [userId] to create a user-specific announcement.
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
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/announcements/create',
      body: <String, dynamic>{
        'title': title,
        'text': text,
        // imageUrlはnull込みで必須パラメータ
        'imageUrl': imageUrl,
        if (icon != null) 'icon': icon,
        if (display != null) 'display': display,
        if (forExistingUsers != null) 'forExistingUsers': forExistingUsers,
        if (silence != null) 'silence': silence,
        if (needConfirmationToRead != null)
          'needConfirmationToRead': needConfirmationToRead,
        if (userId != null) 'userId': userId,
      },
    );
    return MisskeyAdminAnnouncement.fromJson(res);
  }

  /// Fetches announcements (`/api/admin/announcements/list`).
  ///
  /// Use [limit] (1-100, default 10) to cap the number of results and
  /// [sinceId] / [untilId] for cursor-based pagination. [status] filters
  /// by state (`all`, `active`, `archived`; default `active`). Pass
  /// [userId] to fetch user-specific announcements.
  Future<List<MisskeyAdminAnnouncement>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    String? userId,
    String? status,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/announcements/list',
      body: <String, dynamic>{
        if (limit != null) 'limit': limit,
        if (sinceId != null) 'sinceId': sinceId,
        if (untilId != null) 'untilId': untilId,
        if (userId != null) 'userId': userId,
        if (status != null) 'status': status,
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
  /// announcement.
  ///
  /// For [imageUrl], use the [Optional] type: pass `Optional('value')` to set
  /// and `Optional.null_()` to clear.
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
  }) {
    final body = <String, dynamic>{
      'id': id,
      if (title != null) 'title': title,
      if (text != null) 'text': text,
      if (icon != null) 'icon': icon,
      if (display != null) 'display': display,
      if (forExistingUsers != null) 'forExistingUsers': forExistingUsers,
      if (silence != null) 'silence': silence,
      if (needConfirmationToRead != null)
        'needConfirmationToRead': needConfirmationToRead,
      if (isActive != null) 'isActive': isActive,
    };
    putOptional(body, 'imageUrl', imageUrl);
    return http.send<Object?>(
      '/admin/announcements/update',
      body: body,
    );
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
