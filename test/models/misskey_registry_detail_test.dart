import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyRegistryDetail.fromJson', () {
    late MisskeyRegistryDetail detail;

    setUp(() {
      final file = File('test/fixtures/registry_detail.json');
      final jsonMap =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      detail = MisskeyRegistryDetail.fromJson(jsonMap);
    });

    test('deserializes without error', () {
      expect(detail, isNotNull);
    });

    test('updatedAt is deserialized', () {
      expect(detail.updatedAt, isNotNull);
      expect(detail.updatedAt, isA<DateTime>());
    });

    test('value is correct', () {
      expect(detail.value, 'testValue');
    });
  });
}
