import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyChatRoomInvitation.fromJson', () {
    late MisskeyChatRoomInvitation invitation;

    setUp(() {
      final file = File('test/fixtures/chat_room_invitations.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      invitation = MisskeyChatRoomInvitation.fromJson(
        jsonList[0] as Map<String, dynamic>,
      );
    });

    test('has expected id', () {
      expect(invitation.id, 'ak6ph6syrt4w001y');
    });

    test('createdAt is a DateTime', () {
      expect(invitation.createdAt, isA<DateTime>());
    });

    test('room is not null', () {
      expect(invitation.room, isNotNull);
    });

    test('room has expected id and name', () {
      expect(invitation.room!.id, 'ak6o878krt4w0018');
      expect(invitation.room!.name, 'Test Room');
    });

    test('user is not null', () {
      expect(invitation.user, isNotNull);
    });

    test('user has expected username', () {
      expect(invitation.user!.username, 'testuser3');
    });
  });
}
