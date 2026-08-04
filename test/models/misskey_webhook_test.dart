import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyWebhook.fromJson', () {
    late MisskeyWebhook webhook;

    setUp(() {
      final file = File('test/fixtures/webhooks_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      webhook = MisskeyWebhook.fromJson(jsonList.first as Map<String, dynamic>);
    });

    test('deserializes without error', () {
      expect(webhook, isNotNull);
    });

    test('id is correct', () {
      expect(webhook.id, 'ak6ot3ezrt4w001m');
    });

    test('userId is correct', () {
      expect(webhook.userId, 'ak3po4qort4w0001');
    });

    test('name is correct', () {
      expect(webhook.name, 'Test Webhook');
    });

    test('on contains correct events', () {
      expect(webhook.on, ['mention', 'reply']);
    });

    test('url is correct', () {
      expect(webhook.url, 'https://example.com/webhook');
    });

    test('secret is correct', () {
      expect(webhook.secret, 'testsecret');
    });

    test('active is true', () {
      expect(webhook.active, isTrue);
    });

    test('latestSentAt is null', () {
      expect(webhook.latestSentAt, isNull);
    });

    test('latestStatus is null', () {
      expect(webhook.latestStatus, isNull);
    });
  });
}
