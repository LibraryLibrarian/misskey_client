import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyPage.fromJson', () {
    late MisskeyPage page;

    setUp(() {
      final file = File('test/fixtures/pages_list.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      page = MisskeyPage.fromJson(jsonList.first as Map<String, dynamic>);
    });

    test('deserializes without error', () {
      expect(page, isNotNull);
    });

    test('id is correct', () {
      expect(page.id, 'ak6oumrprt4w001r');
    });

    test('userId is correct', () {
      expect(page.userId, 'ak3po4qort4w0001');
    });

    test('title is correct', () {
      expect(page.title, 'Test Page');
    });

    test('name is correct', () {
      expect(page.name, 'test-page');
    });

    test('summary is correct', () {
      expect(page.summary, 'A test page summary');
    });

    test('content has one block', () {
      expect(page.content, hasLength(1));
    });

    test('variables is empty', () {
      expect(page.variables, isEmpty);
    });

    test('alignCenter is false', () {
      expect(page.alignCenter, isFalse);
    });

    test('hideTitleWhenPinned is false', () {
      expect(page.hideTitleWhenPinned, isFalse);
    });

    test('font is correct', () {
      expect(page.font, 'sans-serif');
    });

    test('eyeCatchingImageId is null', () {
      expect(page.eyeCatchingImageId, isNull);
    });

    test('attachedFiles is empty', () {
      expect(page.attachedFiles, isEmpty);
    });

    test('likedCount is 0', () {
      expect(page.likedCount, 0);
    });

    test('user is deserialized', () {
      expect(page.user, isNotNull);
      expect(page.user!.username, 'testadmin');
    });
  });
}
