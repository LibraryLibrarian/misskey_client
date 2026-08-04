import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyFlash.fromJson', () {
    late MisskeyFlash flash;

    setUp(() {
      final file = File('test/fixtures/flash_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      flash = MisskeyFlash.fromJson(jsonList.first as Map<String, dynamic>);
    });

    test('deserializes without error', () {
      expect(flash, isNotNull);
    });

    test('id is correct', () {
      expect(flash.id, 'ak6otxe0rt4w001o');
    });

    test('userId is correct', () {
      expect(flash.userId, 'ak3po4qort4w0001');
    });

    test('title is correct', () {
      expect(flash.title, 'Test Flash');
    });

    test('summary is correct', () {
      expect(flash.summary, 'A test flash');
    });

    test('script is correct', () {
      expect(flash.script, 'Ui:render([Ui:C:text({text: "Hello"})])');
    });

    test('visibility is public', () {
      expect(flash.visibility, 'public');
    });

    test('likedCount is 0', () {
      expect(flash.likedCount, 0);
    });

    test('user is deserialized', () {
      expect(flash.user, isNotNull);
      expect(flash.user!.username, 'testadmin');
    });
  });
}
