import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyRegistryScope.fromJson', () {
    late MisskeyRegistryScope scope;

    setUp(() {
      final file = File('test/fixtures/registry_scopes.json');
      // registry_scopes.jsonは配列形式
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      scope = MisskeyRegistryScope.fromJson(
        jsonList.first as Map<String, dynamic>,
      );
    });

    test('deserializes without error', () {
      expect(scope, isNotNull);
    });

    test('domain is null', () {
      expect(scope.domain, isNull);
    });

    test('scopes has one entry', () {
      expect(scope.scopes, hasLength(1));
    });

    test('scopes first entry is correct', () {
      expect(scope.scopes.first, ['client', 'test']);
    });
  });
}
