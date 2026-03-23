import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('RetentionRecord.fromJson', () {
    late List<RetentionRecord> records;

    setUp(() {
      final file = File('test/fixtures/retention_public.json');
      final json = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      records = json
          .cast<Map<String, dynamic>>()
          .map(RetentionRecord.fromJson)
          .toList();
    });

    test('deserializes exactly 30 records', () {
      expect(records, hasLength(30));
    });

    test('each record has a DateTime createdAt', () {
      for (final record in records) {
        expect(record.createdAt, isA<DateTime>());
      }
    });

    test('each record has a positive users count', () {
      for (final record in records) {
        expect(record.users, greaterThan(0));
      }
    });

    test('first record createdAt is correct', () {
      expect(records[0].createdAt, DateTime.utc(2026, 3, 23, 0, 0, 0, 214));
    });

    test('first record users count is correct', () {
      expect(records[0].users, 203);
    });

    test('first record data map is empty', () {
      expect(records[0].data, isEmpty);
    });

    test('second record data map contains one entry', () {
      expect(records[1].data, hasLength(1));
      expect(records[1].data['2026-3-23'], 58);
    });

    test('data map values are integers', () {
      for (final record in records) {
        for (final value in record.data.values) {
          expect(value, isA<int>());
        }
      }
    });
  });
}
