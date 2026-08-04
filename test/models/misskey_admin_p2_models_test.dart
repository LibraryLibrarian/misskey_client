import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyAbuseUserReport.fromJson', () {
    test('deserializes an unresolved report', () {
      final file = File('test/fixtures/admin_abuse_user_reports.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final reports = jsonList
          .whereType<Map<String, dynamic>>()
          .map(MisskeyAbuseUserReport.fromJson)
          .toList();

      expect(reports, hasLength(1));
      final report = reports.single;
      expect(report.id, isNotEmpty);
      expect(report.comment, 'fixture report');
      expect(report.resolved, isFalse);
      expect(report.reporter, isNotNull);
      expect(report.targetUser!.username, 'e2e_alice');
      expect(report.assignee, isNull);
      expect(report.createdAt, isA<DateTime>());
    });
  });

  group('MisskeyAdminAnnouncement.fromJson', () {
    test('deserializes an announcement with management fields', () {
      final file = File('test/fixtures/admin_announcements_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final announcements = jsonList
          .whereType<Map<String, dynamic>>()
          .map(MisskeyAdminAnnouncement.fromJson)
          .toList();

      expect(announcements, isNotEmpty);
      final announcement = announcements.first;
      expect(announcement.id, isNotEmpty);
      expect(announcement.title, 'fixture');
      expect(announcement.text, 'fixture body');
      expect(announcement.imageUrl, isNull);
      expect(announcement.isActive, isTrue);
      expect(announcement.reads, isA<int>());
    });
  });

  group('MisskeyRelay.fromJson', () {
    test('deserializes and maps unknown status safely', () {
      final relay = MisskeyRelay.fromJson(const {
        'id': 'relay1',
        'inbox': 'https://relay.example.test/inbox',
        'status': 'accepted',
      });
      expect(relay.status, MisskeyRelayStatus.accepted);
    });
  });
}
