import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyChatRoom.fromJson', () {
    late MisskeyChatRoom room;

    setUp(() {
      final file = File('test/fixtures/chat_room_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      room = MisskeyChatRoom.fromJson(json);
    });

    test('deserializes id and createdAt', () {
      expect(room.id, 'ak6o878krt4w0018');
      expect(room.createdAt, isA<DateTime>());
    });

    test('deserializes name and description', () {
      expect(room.name, 'Test Room');
      expect(room.description, '');
    });

    test('deserializes ownerId', () {
      expect(room.ownerId, 'ak3po4qort4w0001');
    });

    test('owner is not null and has username', () {
      expect(room.owner, isNotNull);
      expect(room.owner!.username, 'testadmin');
    });

    test('isMuted is false', () {
      expect(room.isMuted, false);
    });

    test('invitationExists is false', () {
      expect(room.invitationExists, false);
    });
  });

  group('MisskeyChatRoomMember.fromJson', () {
    late List<MisskeyChatRoomMember> list;

    setUp(() {
      final file = File('test/fixtures/chat_room_members.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      list = jsonList
          .map((e) => MisskeyChatRoomMember.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes list', () {
      expect(list, isNotEmpty);
    });

    test('first item has correct id, createdAt, userId, roomId', () {
      final first = list[0];
      expect(first.id, 'ak6o8tqprt4w001h');
      expect(first.createdAt, isA<DateTime>());
      expect(first.userId, 'ak3qbtu5rt4w0009');
      expect(first.roomId, 'ak6o878krt4w0018');
    });

    test('user is not null and has username', () {
      final user = list[0].user;
      expect(user, isNotNull);
      expect(user!.username, 'testuser2');
    });
  });
}
