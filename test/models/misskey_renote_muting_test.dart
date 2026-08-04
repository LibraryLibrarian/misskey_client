import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyRenoteMuting.fromJson', () {
    late List<MisskeyRenoteMuting> list;

    setUp(() {
      final file = File('test/fixtures/renote_mute_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map(
            (e) => MisskeyRenoteMuting.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    });

    test('deserializes list', () {
      expect(list, isNotEmpty);
    });

    test('first item has correct id, createdAt, and muteeId', () {
      final first = list[0];
      expect(first.id, 'ak6o6a7vrt4w0011');
      expect(first.createdAt, isA<DateTime>());
      expect(first.muteeId, 'ak3qbtu5rt4w0009');
    });

    test('mutee is not null and has username', () {
      final mutee = list[0].mutee;
      expect(mutee, isNotNull);
      expect(mutee!.username, 'testuser2');
    });
  });
}
