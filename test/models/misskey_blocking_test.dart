import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyBlocking.fromJson', () {
    late List<MisskeyBlocking> list;

    setUp(() {
      final file = File('test/fixtures/blocking_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map((e) => MisskeyBlocking.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list', () {
      expect(list, isNotEmpty);
    });

    test('first item has correct id, createdAt, and blockeeId', () {
      final first = list[0];
      expect(first.id, 'ak6ngl1art4w000v');
      expect(first.createdAt, isA<DateTime>());
      expect(first.blockeeId, 'ak3qbtu5rt4w0009');
    });

    test('blockee is not null and has username', () {
      final blockee = list[0].blockee;
      expect(blockee, isNotNull);
      expect(blockee!.username, 'testuser2');
    });
  });
}
