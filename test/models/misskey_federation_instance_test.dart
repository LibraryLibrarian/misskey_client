import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyFederationInstance.fromJson (v1: isSensitiveMedia)', () {
    late List<MisskeyFederationInstance> instances;

    setUp(() {
      final file = File('test/fixtures/federation_instances.json');
      final json = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      instances = json
          .cast<Map<String, dynamic>>()
          .map(MisskeyFederationInstance.fromJson)
          .toList();
    });

    test('deserializes list without error', () {
      expect(instances, isNotEmpty);
    });

    test('first item has expected host and id', () {
      expect(instances[0].id, '7rkuxbbmcf');
      expect(instances[0].host, 'pawoo.net');
    });

    test('first item has correct counts', () {
      expect(instances[0].usersCount, 93506);
      expect(instances[0].notesCount, 19830765);
    });

    test('first item has expected softwareName', () {
      expect(instances[0].softwareName, 'mastodon');
    });

    test('first item boolean flags are false', () {
      expect(instances[0].isNotResponding, false);
      expect(instances[0].isSuspended, false);
      expect(instances[0].isBlocked, false);
      expect(instances[0].isSilenced, false);
    });

    // v1フィクスチャにはisSensitiveMediaフィールドがあるが、モデルにはこのフィールドがないため無視される
    test('unknown field isSensitiveMedia is ignored gracefully', () {
      // isSensitiveMediaはモデルにないのでデシリアライズ自体が成功すれば問題なし
      expect(instances[0], isNotNull);
    });

    test('firstRetrievedAt is parsed as DateTime', () {
      expect(instances[0].firstRetrievedAt, isA<DateTime>());
    });
  });

  group('MisskeyFederationInstance.fromJson (v2: isMediaSilenced)', () {
    late List<MisskeyFederationInstance> instances;

    setUp(() {
      final file = File('test/fixtures/federation_instances_v2.json');
      final json = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      instances = json
          .cast<Map<String, dynamic>>()
          .map(MisskeyFederationInstance.fromJson)
          .toList();
    });

    test('deserializes list without error', () {
      expect(instances, isNotEmpty);
    });

    test('first item has expected host', () {
      expect(instances[0].host, 'misskey.io');
    });

    test('first item has expected softwareName', () {
      expect(instances[0].softwareName, 'misskey');
    });

    test('first item boolean flags are false', () {
      expect(instances[0].isNotResponding, false);
      expect(instances[0].isSuspended, false);
      expect(instances[0].isBlocked, false);
      expect(instances[0].isSilenced, false);
    });

    // v2フィクスチャにはisMediaSilencedフィールドがあるが、モデルにはこのフィールドがないため無視される
    test('unknown field isMediaSilenced is ignored gracefully', () {
      expect(instances[0], isNotNull);
    });

    test('infoUpdatedAt and latestRequestReceivedAt parse as DateTime', () {
      expect(instances[0].infoUpdatedAt, isA<DateTime>());
      expect(instances[0].latestRequestReceivedAt, isA<DateTime>());
    });
  });
}
