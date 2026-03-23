import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyInviteCode.fromJson', () {
    late List<MisskeyInviteCode> list;

    setUp(() {
      final file = File('test/fixtures/invite_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map((e) => MisskeyInviteCode.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list', () {
      expect(list, isNotEmpty);
    });

    test('first item has correct id and code', () {
      final first = list[0];
      expect(first.id, 'ak6o6boart4w0014');
      expect(first.code, 'PFN7HXD9W8G2M');
    });

    test('createdAt is a DateTime', () {
      expect(list[0].createdAt, isA<DateTime>());
    });

    test('used is false', () {
      expect(list[0].used, false);
    });

    test('expiresAt is null', () {
      expect(list[0].expiresAt, isNull);
    });

    test('usedBy is null', () {
      expect(list[0].usedBy, isNull);
    });

    test('usedAt is null', () {
      expect(list[0].usedAt, isNull);
    });

    test('createdBy is not null and has username', () {
      final createdBy = list[0].createdBy;
      expect(createdBy, isNotNull);
      expect(createdBy!.username, 'testadmin');
    });
  });
}
