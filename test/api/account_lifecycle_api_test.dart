import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  test('all account lifecycle APIs send unauthenticated wire bodies', () async {
    final adapter = _LifecycleAdapter();
    var tokenProviderCalls = 0;
    final client = MisskeyClient(
      config: MisskeyClientConfig(
        baseUrl: Uri.parse('https://misskey.example.com'),
      ),
      tokenProvider: () {
        tokenProviderCalls++;
        return 'must-not-be-read';
      },
      httpClientAdapter: adapter,
    );
    addTearDown(client.dispose);

    final username = await client.accountLifecycle.checkUsernameAvailability(
      username: 'alice',
    );
    final email = await client.accountLifecycle.checkEmailAddressAvailability(
      emailAddress: 'alice@example.com',
    );
    await client.accountLifecycle.requestPasswordReset(
      username: 'alice',
      email: 'alice@example.com',
    );
    await client.accountLifecycle.resetPassword(
      token: 'reset-token',
      password: 'new-password',
    );
    await client.accountLifecycle.verifyEmail(code: 'verification-code');

    expect(username.available, isTrue);
    expect(email.available, isFalse);
    expect(email.reason, 'used');
    expect(tokenProviderCalls, 0);
    expect(adapter.requests, [
      {
        'path': '/api/username/available',
        'body': {'username': 'alice'},
      },
      {
        'path': '/api/email-address/available',
        'body': {'emailAddress': 'alice@example.com'},
      },
      {
        'path': '/api/request-reset-password',
        'body': {'username': 'alice', 'email': 'alice@example.com'},
      },
      {
        'path': '/api/reset-password',
        'body': {'token': 'reset-token', 'password': 'new-password'},
      },
      {
        'path': '/api/verify-email',
        'body': {'code': 'verification-code'},
      },
    ]);
  });

  test('lifecycle secrets and access tokens are redacted from logs', () async {
    final adapter = _LifecycleAdapter();
    final logs = <String>[];
    final client = MisskeyClient(
      config: MisskeyClientConfig(
        baseUrl: Uri.parse('https://misskey.example.com'),
        enableLog: true,
      ),
      tokenProvider: () => 'access-token-secret',
      logger: FunctionLogger((level, message) => logs.add('$level $message')),
      httpClientAdapter: adapter,
    );
    addTearDown(client.dispose);

    await client.accountLifecycle.checkUsernameAvailability(
      username: 'private-username',
    );
    await client.accountLifecycle.checkEmailAddressAvailability(
      emailAddress: 'private@example.com',
    );
    await client.accountLifecycle.requestPasswordReset(
      username: 'private-user',
      email: 'private@example.com',
    );
    await client.accountLifecycle.resetPassword(
      token: 'reset-token-secret',
      password: 'password-secret',
    );
    await client.accountLifecycle.verifyEmail(code: 'verify-code-secret');
    await client.account.i();

    final output = logs.join('\n');
    expect(output, contains('<redacted>'));
    for (final secret in [
      'private-username',
      'private@example.com',
      'private-user',
      'reset-token-secret',
      'password-secret',
      'verify-code-secret',
      'access-token-secret',
    ]) {
      expect(output, isNot(contains(secret)));
    }

    expect(
      adapter.requests.singleWhere(
        (request) => request['path'] == '/api/username/available',
      )['body'],
      containsPair('username', 'private-username'),
      reason: 'redaction must not modify the username availability body',
    );
    expect(
      adapter.requests.last['body'],
      containsPair('i', 'access-token-secret'),
      reason: 'redaction must not modify the actual request body',
    );
  });
}

final class _LifecycleAdapter implements HttpClientAdapter {
  final List<Map<String, dynamic>> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add({
      'path': options.uri.path,
      'body': Map<String, dynamic>.from(options.data as Map<String, dynamic>),
    });
    final response = switch (options.uri.path) {
      '/api/username/available' => <String, dynamic>{'available': true},
      '/api/email-address/available' => <String, dynamic>{
        'available': false,
        'reason': 'used',
      },
      '/api/i' => <String, dynamic>{'id': 'user-id', 'username': 'alice'},
      _ => null,
    };
    return ResponseBody.fromString(
      jsonEncode(response),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
