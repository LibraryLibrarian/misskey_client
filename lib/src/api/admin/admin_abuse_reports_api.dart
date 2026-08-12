import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/admin/misskey_abuse_report_notification_recipient.dart';
import '../../models/admin/misskey_abuse_user_report.dart';

/// Provides abuse report management admin APIs
/// (`/api/admin/abuse-user-reports`, `/api/admin/*-abuse-user-report`,
/// and `/api/admin/abuse-report/notification-recipient/*`).
///
/// All endpoints require moderator privileges unless noted otherwise.
class AdminAbuseReportsApi {
  const AdminAbuseReportsApi({required this.http});

  final MisskeyHttp http;

  /// Fetches abuse reports (`/api/admin/abuse-user-reports`).
  ///
  /// Use [limit] (1-100, default 10) to cap the number of results and
  /// [sinceId] / [untilId] for cursor-based pagination. [state] filters
  /// by resolution state (`resolved` or `unresolved`). [reporterOrigin]
  /// and [targetUserOrigin] filter by origin (`combined`, `local`,
  /// `remote`).
  Future<List<MisskeyAbuseUserReport>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    String? state,
    String? reporterOrigin,
    String? targetUserOrigin,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/abuse-user-reports',
      body: <String, dynamic>{
        'limit': ?limit,
        'sinceId': ?sinceId,
        'untilId': ?untilId,
        'state': ?state,
        'reporterOrigin': ?reporterOrigin,
        'targetUserOrigin': ?targetUserOrigin,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAbuseUserReport.fromJson)
        .toList();
  }

  /// Resolves an abuse report (`/api/admin/resolve-abuse-user-report`).
  ///
  /// Pass [resolvedAs] (`accept` or `reject`) to record how the report
  /// was resolved.
  ///
  /// Common errors:
  /// - `NO_SUCH_ABUSE_REPORT`: The specified report does not exist
  Future<void> resolve({required String reportId, String? resolvedAs}) =>
      http.send<Object?>(
        '/admin/resolve-abuse-user-report',
        body: <String, dynamic>{
          'reportId': reportId,
          'resolvedAs': ?resolvedAs,
        },
      );

  /// Forwards an abuse report to the remote instance of the reported user
  /// (`/api/admin/forward-abuse-user-report`).
  ///
  /// Only valid for reports whose target user is remote.
  Future<void> forward({required String reportId}) => http.send<Object?>(
    '/admin/forward-abuse-user-report',
    body: <String, dynamic>{'reportId': reportId},
  );

  /// Updates the moderation note of an abuse report
  /// (`/api/admin/update-abuse-user-report`).
  Future<void> update({required String reportId, String? moderationNote}) =>
      http.send<Object?>(
        '/admin/update-abuse-user-report',
        body: <String, dynamic>{
          'reportId': reportId,
          'moderationNote': ?moderationNote,
        },
      );

  /// Fetches abuse report notification recipients
  /// (`/api/admin/abuse-report/notification-recipient/list`).
  ///
  /// Use [method] to filter by notification methods
  /// (`email` / `webhook`).
  Future<List<MisskeyAbuseReportNotificationRecipient>>
  listNotificationRecipients({List<String>? method}) async {
    final res = await http.send<List<dynamic>>(
      '/admin/abuse-report/notification-recipient/list',
      body: <String, dynamic>{'method': ?method},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAbuseReportNotificationRecipient.fromJson)
        .toList();
  }

  /// Fetches a single abuse report notification recipient
  /// (`/api/admin/abuse-report/notification-recipient/show`).
  Future<MisskeyAbuseReportNotificationRecipient> showNotificationRecipient({
    required String id,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/abuse-report/notification-recipient/show',
      body: <String, dynamic>{'id': id},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyAbuseReportNotificationRecipient.fromJson(res);
  }

  /// Creates an abuse report notification recipient
  /// (`/api/admin/abuse-report/notification-recipient/create`).
  ///
  /// [method] is `email` (requires [userId]) or `webhook` (requires
  /// [systemWebhookId]).
  Future<MisskeyAbuseReportNotificationRecipient> createNotificationRecipient({
    required bool isActive,
    required String name,
    required String method,
    String? userId,
    String? systemWebhookId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/abuse-report/notification-recipient/create',
      body: <String, dynamic>{
        'isActive': isActive,
        'name': name,
        'method': method,
        'userId': ?userId,
        'systemWebhookId': ?systemWebhookId,
      },
    );
    return MisskeyAbuseReportNotificationRecipient.fromJson(res);
  }

  /// Updates an abuse report notification recipient
  /// (`/api/admin/abuse-report/notification-recipient/update`).
  Future<MisskeyAbuseReportNotificationRecipient> updateNotificationRecipient({
    required String id,
    required bool isActive,
    required String name,
    required String method,
    String? userId,
    String? systemWebhookId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/abuse-report/notification-recipient/update',
      body: <String, dynamic>{
        'id': id,
        'isActive': isActive,
        'name': name,
        'method': method,
        'userId': ?userId,
        'systemWebhookId': ?systemWebhookId,
      },
    );
    return MisskeyAbuseReportNotificationRecipient.fromJson(res);
  }

  /// Deletes an abuse report notification recipient
  /// (`/api/admin/abuse-report/notification-recipient/delete`).
  Future<void> deleteNotificationRecipient({required String id}) =>
      http.send<Object?>(
        '/admin/abuse-report/notification-recipient/delete',
        body: <String, dynamic>{'id': id},
      );
}
