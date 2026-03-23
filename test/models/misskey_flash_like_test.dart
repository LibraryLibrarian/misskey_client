import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyFlashLike.fromJson', () {
    late MisskeyFlashLike flashLike;

    setUp(() {
      final file = File('test/fixtures/flash_likes.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      flashLike = MisskeyFlashLike.fromJson(
        jsonList[0] as Map<String, dynamic>,
      );
    });

    test('id is not empty', () {
      expect(flashLike.id, isNotEmpty);
      expect(flashLike.id, 'ak6pcjiort4w001x');
    });

    test('flash is not null', () {
      expect(flashLike.flash, isNotNull);
    });

    test('flash has a title', () {
      expect(flashLike.flash.title, 'Test Flash');
    });

    test('flash has expected id', () {
      expect(flashLike.flash.id, 'ak6otxe0rt4w001o');
    });
  });
}
