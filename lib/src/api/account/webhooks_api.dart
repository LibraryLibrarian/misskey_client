import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../models/account/misskey_webhook.dart';

/// Provides webhook management APIs (`/api/i/webhooks/*`).
///
/// Offers creation, retrieval, updating, deletion, and test delivery of
/// user webhooks.
class WebhooksApi {
  const WebhooksApi({required this.http});

  final MisskeyHttp http;

  /// Creates a new webhook (`/api/i/webhooks/create`).
  ///
  /// [name] is the webhook name (1-100 characters) and [url] is the
  /// destination URL (1-1024 characters). [secret] is an optional secret of
  /// up to 1024 characters and defaults to an empty string. [on] specifies
  /// the event types to subscribe to; valid values are `mention`, `unfollow`,
  /// `follow`, `followed`, `note`, `reply`, `renote`, and `reaction`.
  ///
  /// Throws a `TOO_MANY_WEBHOOKS` error if the role policy limit is exceeded.
  Future<MisskeyWebhook> create({
    required String name,
    required String url,
    required List<String> on,
    String? secret,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'url': url,
      'on': on,
      if (secret != null) 'secret': secret,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/i/webhooks/create',
      body: body,
    );
    return MisskeyWebhook.fromJson(res);
  }

  /// Retrieves the list of webhooks (`/api/i/webhooks/list`).
  ///
  /// Returns all webhooks owned by the authenticated user.
  Future<List<MisskeyWebhook>> list() async {
    final res = await http.send<List<dynamic>>(
      '/i/webhooks/list',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyWebhook.fromJson)
        .toList();
  }

  /// Retrieves the details of a webhook (`/api/i/webhooks/show`).
  ///
  /// Specify the target webhook with [webhookId].
  /// Throws a `NO_SUCH_WEBHOOK` error if the webhook does not exist or is not
  /// owned by the user.
  Future<MisskeyWebhook> show({required String webhookId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/i/webhooks/show',
      body: <String, dynamic>{'webhookId': webhookId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyWebhook.fromJson(res);
  }

  /// Updates a webhook (`/api/i/webhooks/update`).
  ///
  /// [webhookId] identifies the webhook to update. [name] sets a new name
  /// (1-100 characters) and [url] sets a new destination URL (1-1024
  /// characters). [secret] sets a new secret of up to 1024 characters; pass
  /// `Optional.null_()` to reset it. [on] updates the subscribed event types
  /// and [active] enables or disables the webhook.
  ///
  /// Throws a `NO_SUCH_WEBHOOK` error if the webhook does not exist or is not
  /// owned by the user.
  Future<void> update({
    required String webhookId,
    String? name,
    String? url,
    Optional<String>? secret,
    List<String>? on,
    bool? active,
  }) {
    final body = <String, dynamic>{
      'webhookId': webhookId,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (on != null) 'on': on,
      if (active != null) 'active': active,
    };
    if (secret case Some<String>(:final value)) {
      body['secret'] = value;
    }
    return http.send<Object?>(
      '/i/webhooks/update',
      body: body,
    );
  }

  /// Deletes a webhook (`/api/i/webhooks/delete`).
  ///
  /// Specify the target webhook with [webhookId].
  /// Throws a `NO_SUCH_WEBHOOK` error if the webhook does not exist or is not
  /// owned by the user.
  Future<void> delete({required String webhookId}) => http.send<Object?>(
        '/i/webhooks/delete',
        body: <String, dynamic>{'webhookId': webhookId},
      );

  /// Sends a test event to a webhook (`/api/i/webhooks/test`).
  ///
  /// Sends a test event to the specified webhook.
  /// Rate limit: 60 times per 15 minutes.
  ///
  /// [webhookId] identifies the target webhook. [type] is the event type to
  /// test; valid values are `mention`, `unfollow`, `follow`, `followed`,
  /// `note`, `reply`, `renote`, and `reaction`. [override] allows temporarily
  /// changing settings such as `url` and `secret` for the test only.
  Future<void> test({
    required String webhookId,
    required String type,
    Map<String, String>? override,
  }) =>
      http.send<Object?>(
        '/i/webhooks/test',
        body: <String, dynamic>{
          'webhookId': webhookId,
          'type': type,
          if (override != null) 'override': override,
        },
      );
}
