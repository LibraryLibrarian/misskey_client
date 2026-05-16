import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('DriveCapacityInfo.fromJson', () {
    late DriveCapacityInfo info;

    setUp(() {
      final file = File('test/fixtures/drive_capacity.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      info = DriveCapacityInfo.fromJson(json);
    });

    test('deserializes capacity', () {
      expect(info.capacity, 104857600);
    });

    test('deserializes usage', () {
      expect(info.usage, 85);
    });

    test('availableCapacity is capacity minus usage', () {
      expect(info.availableCapacity, 104857600 - 85);
    });

    test('usageRatio is within 0.0 to 1.0', () {
      expect(info.usageRatio, greaterThanOrEqualTo(0.0));
      expect(info.usageRatio, lessThanOrEqualTo(1.0));
    });

    test('usagePercentage equals usageRatio times 100', () {
      expect(info.usagePercentage, closeTo(info.usageRatio * 100, 0.0001));
    });
  });
}
