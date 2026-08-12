import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyAnnouncement.fromJson', () {
    late MisskeyAnnouncement announcement;

    setUp(() {
      final file = File('test/fixtures/announcements.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      announcement = MisskeyAnnouncement.fromJson(
        jsonList.first as Map<String, dynamic>,
      );
    });

    test('deserializes without error', () {
      expect(announcement, isNotNull);
    });

    test('id is correct', () {
      expect(announcement.id, 'ak3qcgvlrt4w000a');
    });

    test('title is correct', () {
      expect(announcement.title, 'Test Announcement');
    });

    test('text is correct', () {
      expect(announcement.text, 'This is a test announcement for API testing.');
    });

    test('icon and display are correct', () {
      expect(announcement.icon, 'info');
      expect(announcement.display, 'normal');
    });

    test('createdAt is a DateTime', () {
      expect(announcement.createdAt, isA<DateTime>());
    });

    test('updatedAt is null', () {
      expect(announcement.updatedAt, isNull);
    });

    test('imageUrl is null', () {
      expect(announcement.imageUrl, isNull);
    });

    test('boolean flags are false', () {
      expect(announcement.needConfirmationToRead, isFalse);
      expect(announcement.silence, isFalse);
      expect(announcement.forYou, isFalse);
    });

    test('isRead is false', () {
      expect(announcement.isRead, isFalse);
    });

    // フィクスチャにisActiveフィールドがないのでデフォルト値trueになる
    test('isActive defaults to true when field is absent', () {
      expect(announcement.isActive, true);
    });

    // フィクスチャにforExistingUsersフィールドがないのでデフォルト値falseになる
    test('forExistingUsers defaults to false when field is absent', () {
      expect(announcement.forExistingUsers, false);
    });

    test('userId is null', () {
      expect(announcement.userId, isNull);
    });
  });
}
