import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyFrequentUser.fromJson', () {
    late MisskeyFrequentUser frequentUser;

    setUp(() {
      final file = File('test/fixtures/frequent_users.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      frequentUser = MisskeyFrequentUser.fromJson(
        jsonList[0] as Map<String, dynamic>,
      );
    });

    test('user is not null', () {
      expect(frequentUser.user, isNotNull);
    });

    test('user has expected id', () {
      expect(frequentUser.user.id, 'ak3po4qort4w0001');
    });

    test('weight is >= 1', () {
      expect(frequentUser.weight, greaterThanOrEqualTo(1));
    });
  });
}
