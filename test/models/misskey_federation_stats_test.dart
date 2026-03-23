import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyFederationStats.fromJson', () {
    late MisskeyFederationStats stats;

    setUp(() {
      final file = File('test/fixtures/federation_stats.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      stats = MisskeyFederationStats.fromJson(json);
    });

    test('deserializes without error', () {
      expect(stats, isNotNull);
    });

    test('topSubInstances is a non-empty list', () {
      expect(stats.topSubInstances, isA<List<MisskeyFederationInstance>>());
      expect(stats.topSubInstances, isNotEmpty);
    });

    test('topPubInstances is a non-empty list', () {
      expect(stats.topPubInstances, isA<List<MisskeyFederationInstance>>());
      expect(stats.topPubInstances, isNotEmpty);
    });

    test('otherFollowersCount is the expected value', () {
      expect(stats.otherFollowersCount, 320576);
    });

    test('otherFollowingCount is the expected value', () {
      expect(stats.otherFollowingCount, 523904);
    });

    test('first topSubInstances item has correct host and softwareName', () {
      final first = stats.topSubInstances[0];
      expect(first.host, 'pawoo.net');
      expect(first.softwareName, 'mastodon');
    });

    test('nested instance objects have valid DateTime fields', () {
      final first = stats.topSubInstances[0];
      expect(first.firstRetrievedAt, isA<DateTime>());
      expect(first.infoUpdatedAt, isA<DateTime>());
    });
  });
}
