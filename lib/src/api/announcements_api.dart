import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_announcement.dart';

/// Provides announcement APIs (`/api/announcements`).
///
/// Retrieves server announcements.
/// Use `AccountApi.readAnnouncement` to mark announcements as read.
class AnnouncementsApi {
  const AnnouncementsApi({required this.http});

  final MisskeyHttp http;

  /// Retrieves the list of announcements (`/api/announcements`).
  ///
  /// Authentication is optional. When authenticated, the `isRead` field is
  /// included in the response. Use [limit] to cap the number of items
  /// (1-100, default 10). Paginate by ID with [sinceId] and [untilId], or by
  /// Unix timestamp (ms) with [sinceDate] and [untilDate]. Set [isActive] to
  /// `false` to include inactive announcements (default: true).
  Future<List<MisskeyAnnouncement>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? isActive,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (isActive != null) 'isActive': isActive,
    };
    final res = await http.send<List<dynamic>>(
      '/announcements',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAnnouncement.fromJson)
        .toList();
  }

  /// Retrieves the details of an announcement (`/api/announcements/show`).
  ///
  /// Authentication is optional. Pass the target announcement's ID as
  /// [announcementId].
  ///
  /// Common errors:
  /// - `NO_SUCH_ANNOUNCEMENT`: The specified announcement does not exist
  Future<MisskeyAnnouncement> show({
    required String announcementId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/announcements/show',
      body: <String, dynamic>{'announcementId': announcementId},
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyAnnouncement.fromJson(res);
  }
}
