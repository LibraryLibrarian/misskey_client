import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyHashtagTrend.fromJson', () {
    late MisskeyHashtagTrend trend;

    setUp(() {
      final file = File('test/fixtures/hashtag_trend.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      trend = MisskeyHashtagTrend.fromJson(jsonList[0] as Map<String, dynamic>);
    });

    test('tag is "testhashtag"', () {
      expect(trend.tag, 'testhashtag');
    });

    test('chart is a non-empty list', () {
      expect(trend.chart, isA<List<int>>());
      expect(trend.chart, isNotEmpty);
    });

    test('chart has 20 data points', () {
      expect(trend.chart.length, 20);
    });

    test('usersCount is >= 1', () {
      expect(trend.usersCount, greaterThanOrEqualTo(1));
    });
  });
}
