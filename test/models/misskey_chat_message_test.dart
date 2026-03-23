import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyChatMessage.fromJson (single)', () {
    late MisskeyChatMessage message;

    setUp(() {
      final file = File('test/fixtures/chat_message_create.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      message = MisskeyChatMessage.fromJson(json);
    });

    test('deserializes id and createdAt', () {
      expect(message.id, 'ak6ogs02rt4w001l');
      expect(message.createdAt, isA<DateTime>());
    });

    test('deserializes fromUserId', () {
      expect(message.fromUserId, 'ak3qbtu5rt4w0009');
    });

    test('deserializes text', () {
      expect(message.text, 'Hello from testuser2!');
    });

    test('toUserId is set for direct message', () {
      expect(message.toUserId, 'ak3po4qort4w0001');
    });

    test('file and fileId are null', () {
      expect(message.fileId, isNull);
      expect(message.file, isNull);
    });

    test('reactions is empty list', () {
      expect(message.reactions, isEmpty);
    });

    test('toRoom and toRoomId are null', () {
      expect(message.toRoomId, isNull);
      expect(message.toRoom, isNull);
    });
  });

  group('MisskeyChatMessage.fromJson (list)', () {
    late List<MisskeyChatMessage> list;

    setUp(() {
      final file = File('test/fixtures/chat_messages.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map((e) => MisskeyChatMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list with two items', () {
      expect(list.length, 2);
    });

    test('first item has correct id', () {
      expect(list[0].id, 'ak6ogs02rt4w001l');
    });

    test('second item has correct id', () {
      expect(list[1].id, 'ak6od3f6rt4w001j');
    });

    test('all items have fromUserId', () {
      for (final msg in list) {
        expect(msg.fromUserId, 'ak3qbtu5rt4w0009');
      }
    });
  });
}
