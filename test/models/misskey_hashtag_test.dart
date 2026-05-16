import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyHashtag.fromJson', () {
    late MisskeyHashtag hashtag;

    setUp(() {
      final file = File('test/fixtures/hashtag_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      hashtag = MisskeyHashtag.fromJson(json);
    });

    test('deserializes tag name', () {
      expect(hashtag.tag, 'testhashtag');
    });

    test('deserializes mentionedUsersCount', () {
      expect(hashtag.mentionedUsersCount, 1);
    });

    test('deserializes local and remote mentioned counts', () {
      expect(hashtag.mentionedLocalUsersCount, 1);
      expect(hashtag.mentionedRemoteUsersCount, 0);
    });

    test('deserializes attachedUsersCount', () {
      expect(hashtag.attachedUsersCount, 0);
    });

    test('deserializes local and remote attached counts', () {
      expect(hashtag.attachedLocalUsersCount, 0);
      expect(hashtag.attachedRemoteUsersCount, 0);
    });
  });
}
