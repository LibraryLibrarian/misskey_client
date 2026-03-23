import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('EndpointInfo.fromJson', () {
    late EndpointInfo info;

    setUp(() {
      final file = File('test/fixtures/endpoint_info.json');
      final jsonMap =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      info = EndpointInfo.fromJson(jsonMap);
    });

    test('deserializes without error', () {
      expect(info, isNotNull);
    });

    test('params list is not empty', () {
      expect(info.params, isNotEmpty);
    });

    test('params has correct count', () {
      expect(info.params, hasLength(15));
    });

    test('first param name is visibility', () {
      expect(info.params.first.name, 'visibility');
    });

    test('first param type is String', () {
      expect(info.params.first.type, 'String');
    });

    test('contains visibleUserIds param of type Array', () {
      final param =
          info.params.firstWhere((p) => p.name == 'visibleUserIds');
      expect(param.type, 'Array');
    });

    test('contains localOnly param of type Boolean', () {
      final param = info.params.firstWhere((p) => p.name == 'localOnly');
      expect(param.type, 'Boolean');
    });

    test('contains poll param of type Object', () {
      final param = info.params.firstWhere((p) => p.name == 'poll');
      expect(param.type, 'Object');
    });
  });

  group('EndpointParam.fromJson', () {
    test('deserializes name and type', () {
      final param =
          EndpointParam.fromJson({'name': 'limit', 'type': 'Integer'});
      expect(param.name, 'limit');
      expect(param.type, 'Integer');
    });
  });
}
