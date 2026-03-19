import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_notification.dart';

/// Provides notification-related API endpoints.
class NotificationsApi {
  const NotificationsApi({required this.http});

  final MisskeyHttp http;

  /// Fetches a list of notifications (`/api/i/notifications`).
  ///
  /// Use [limit] to cap the number of results (1–100).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  /// Set [markAsRead] to `false` to suppress the read-marking on retrieval
  /// (default: true). Pass [includeTypes] to restrict to specific notification
  /// types (an empty list returns no results), or [excludeTypes] to omit
  /// certain types.
  Future<List<MisskeyNotification>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? markAsRead,
    List<String>? includeTypes,
    List<String>? excludeTypes,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (markAsRead != null) 'markAsRead': markAsRead,
      if (includeTypes != null) 'includeTypes': includeTypes,
      if (excludeTypes != null) 'excludeTypes': excludeTypes,
    };
    // markAsRead=false のときのみ冪等として再試行可
    final idempotent = markAsRead == false;
    final res = await http.send<List<dynamic>>(
      '/i/notifications',
      body: body,
      options: RequestOptions(idempotent: idempotent),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNotification.fromJson)
        .toList();
  }

  /// Fetches grouped notifications (`/api/i/notifications-grouped`).
  ///
  /// Groups reactions and renotes on the same note into a single entry.
  ///
  /// Use [limit] to cap the number of results (1–100).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  /// Set [markAsRead] to `false` to suppress the read-marking on retrieval
  /// (default: true). Pass [includeTypes] to restrict to specific notification
  /// types (an empty list returns no results), or [excludeTypes] to omit
  /// certain types.
  Future<List<MisskeyNotification>> listGrouped({
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    bool? markAsRead,
    List<String>? includeTypes,
    List<String>? excludeTypes,
  }) async {
    final body = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
      if (markAsRead != null) 'markAsRead': markAsRead,
      if (includeTypes != null) 'includeTypes': includeTypes,
      if (excludeTypes != null) 'excludeTypes': excludeTypes,
    };
    // markAsRead=false のときのみ冪等として再試行可
    final idempotent = markAsRead == false;
    final res = await http.send<List<dynamic>>(
      '/i/notifications-grouped',
      body: body,
      options: RequestOptions(idempotent: idempotent),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNotification.fromJson)
        .toList();
  }

  /// Flushes (deletes) all notifications (`/api/notifications/flush`).
  ///
  /// Returns 204 No Content.
  Future<void> flush() => http
      .send<Object?>('/notifications/flush', body: const <String, dynamic>{});

  /// Marks all notifications as read (`/api/notifications/mark-all-as-read`).
  ///
  /// Returns 204 No Content.
  Future<void> markAllAsRead() => http.send<Object?>(
        '/notifications/mark-all-as-read',
        body: const <String, dynamic>{},
      );

  /// Creates an app notification (`/api/notifications/create`).
  ///
  /// Sends a custom notification to the user from an app
  /// (e.g., third-party client).
  /// The notification type is created as `app`.
  /// Authentication required. Permission: `write:notifications`.
  /// Rate limit: 10 requests per minute.
  ///
  /// Provide the notification body text in [body]. Use [header] to set a
  /// custom title (defaults to the access token name if omitted), and [icon]
  /// to set a custom icon URL (defaults to the token's icon URL if omitted).
  Future<void> create({
    required String body,
    String? header,
    String? icon,
  }) =>
      http.send<Object?>(
        '/notifications/create',
        body: <String, dynamic>{
          'body': body,
          if (header != null) 'header': header,
          if (icon != null) 'icon': icon,
        },
      );

  /// Sends a test notification (`/api/notifications/test-notification`).
  ///
  /// Sends a test notification (type `test`) to yourself.
  /// An endpoint for verifying notification behavior.
  /// Authentication required. Permission: `write:notifications`.
  /// Rate limit: 10 requests per minute.
  Future<void> testNotification() => http.send<Object?>(
        '/notifications/test-notification',
        body: const <String, dynamic>{},
      );
}
