import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/admin/misskey_system_webhook.dart';

/// Provides system webhook management admin APIs
/// (`/api/admin/system-webhook/*`).
///
/// System webhooks notify external endpoints about instance-level events,
/// unlike user webhooks which are scoped to a single account.
///
/// All endpoints require administrator privileges.
class AdminSystemWebhookApi {
  const AdminSystemWebhookApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Creates a system webhook (`/api/admin/system-webhook/create`).
  ///
  /// [on] lists the events to subscribe to: `abuseReport`,
  /// `abuseReportResolved`, `userCreated`, `inactiveModeratorsWarning`,
  /// and `inactiveModeratorsInvitationOnlyChanged`.
  Future<MisskeySystemWebhook> create({
    required bool isActive,
    required String name,
    required List<String> on,
    required String url,
    String? secret,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/system-webhook/create',
      body: <String, dynamic>{
        'isActive': isActive,
        'name': name,
        'on': on,
        'url': url,
        'secret': ?secret,
      },
    );
    return MisskeySystemWebhook.fromJson(res);
  }

  /// Fetches system webhooks (`/api/admin/system-webhook/list`).
  ///
  /// Use [isActive] and [on] to filter the results.
  Future<List<MisskeySystemWebhook>> list({
    bool? isActive,
    List<String>? on,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/system-webhook/list',
      body: <String, dynamic>{'isActive': ?isActive, 'on': ?on},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeySystemWebhook.fromJson)
        .toList();
  }

  /// Fetches a single system webhook (`/api/admin/system-webhook/show`).
  ///
  /// Common errors:
  /// - `NO_SUCH_WEBHOOK`: The specified webhook does not exist
  Future<MisskeySystemWebhook> show({required String id}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/system-webhook/show',
      body: <String, dynamic>{'id': id},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeySystemWebhook.fromJson(res);
  }

  /// Updates a system webhook (`/api/admin/system-webhook/update`).
  ///
  /// All of [isActive], [name], [on], and [url] are required by the
  /// server, so pass the full desired state.
  ///
  /// Common errors:
  /// - `NO_SUCH_WEBHOOK`: The specified webhook does not exist
  Future<MisskeySystemWebhook> update({
    required String id,
    required bool isActive,
    required String name,
    required List<String> on,
    required String url,
    String? secret,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/system-webhook/update',
      body: <String, dynamic>{
        'id': id,
        'isActive': isActive,
        'name': name,
        'on': on,
        'url': url,
        'secret': ?secret,
      },
    );
    return MisskeySystemWebhook.fromJson(res);
  }

  /// Deletes a system webhook (`/api/admin/system-webhook/delete`).
  ///
  /// Common errors:
  /// - `NO_SUCH_WEBHOOK`: The specified webhook does not exist
  Future<void> delete({required String id}) => http.send<Object?>(
    '/admin/system-webhook/delete',
    body: <String, dynamic>{'id': id},
  );

  /// Sends a test delivery for a system webhook
  /// (`/api/admin/system-webhook/test`).
  ///
  /// [type] selects the event to simulate. Pass [override] to replace
  /// parts of the generated dummy payload.
  Future<void> test({
    required String webhookId,
    required String type,
    Map<String, dynamic>? override,
  }) => http.send<Object?>(
    '/admin/system-webhook/test',
    body: <String, dynamic>{
      'webhookId': webhookId,
      'type': type,
      'override': ?override,
    },
  );
}
