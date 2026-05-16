import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('ServerInfo.fromJson', () {
    test('deserializes real API response', () {
      final file = File('test/fixtures/server_info.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final info = ServerInfo.fromJson(json);

      expect(info.machine, '?');
      expect(info.cpu.model, '?');
      expect(info.cpu.cores, 0);
      expect(info.mem.total, 0);
      expect(info.fs.total, 0);
      expect(info.fs.used, 0);
    });
  });

  group('InstanceStats.fromJson', () {
    test('deserializes real API response', () {
      final file = File('test/fixtures/stats.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final stats = InstanceStats.fromJson(json);

      expect(stats.notesCount, 0);
      expect(stats.originalNotesCount, 0);
      expect(stats.usersCount, 0);
      expect(stats.originalUsersCount, 0);
      expect(stats.instances, 0);
      expect(stats.driveUsageLocal, 0);
      expect(stats.driveUsageRemote, 0);
    });
  });
}
