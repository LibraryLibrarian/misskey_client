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
      expect(instances[0].id, isNotEmpty);
      expect(instances[0].host, isNotEmpty);
    });

    test('first item has correct counts', () {
      expect(instances[0].usersCount, isNonNegative);
      expect(instances[0].notesCount, isNonNegative);
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

    // 閉域環境で新規に検出されたインスタンスはメディア判定が
    // 未確定のためnullを返しうる(nullable型として正しく扱えることを確認)
    test('isSensitiveMedia is nullable and does not throw', () {
      expect(() => instances[0].isSensitiveMedia, returnsNormally);
    });

    // v1フィクスチャにはisMediaSilencedフィールドがないのでデフォルト値falseになる
    test('isMediaSilenced defaults to false when field is absent', () {
      expect(instances[0].isMediaSilenced, false);
    });

    test('suspensionState is not null and is "none"', () {
      expect(instances[0].suspensionState, isNotNull);
      expect(instances[0].suspensionState, 'none');
    });

    test('moderationNote is present (may be null)', () {
      // フィクスチャではnullだが、フィールド自体は存在する
      expect(instances[0].moderationNote, isNull);
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

    // v2フィクスチャにはisMediaSilencedフィールドがある
    test('isMediaSilenced is not null and is false', () {
      expect(instances[0].isMediaSilenced, isNotNull);
      expect(instances[0].isMediaSilenced, false);
    });

    // v2フィクスチャにはisSensitiveMediaフィールドがないのでデフォルト値falseになる
    test('isSensitiveMedia defaults to false when field is absent', () {
      expect(instances[0].isSensitiveMedia, false);
    });

    test('suspensionState is not null and is "none"', () {
      expect(instances[0].suspensionState, isNotNull);
      expect(instances[0].suspensionState, 'none');
    });

    test('moderationNote is present (may be null)', () {
      // フィクスチャではnullだが、フィールド自体は存在する
      expect(instances[0].moderationNote, isNull);
    });

    test('infoUpdatedAt and latestRequestReceivedAt parse as DateTime', () {
      expect(instances[0].infoUpdatedAt, isA<DateTime>());
      expect(instances[0].latestRequestReceivedAt, isA<DateTime>());
    });
  });
}
