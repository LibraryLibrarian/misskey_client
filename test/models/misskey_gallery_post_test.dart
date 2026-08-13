import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyGalleryPost.fromJson (list)', () {
    late MisskeyGalleryPost post;

    setUp(() {
      final file = File('test/fixtures/gallery_posts.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      post = MisskeyGalleryPost.fromJson(
        jsonList.first as Map<String, dynamic>,
      );
    });

    test('deserializes without error', () {
      expect(post, isNotNull);
    });

    test('id is correct', () {
      expect(post.id, 'ak6otcb6rt4w001n');
    });

    test('userId is correct', () {
      expect(post.userId, 'ak3po4qort4w0001');
    });

    test('title is correct', () {
      expect(post.title, 'Test Gallery Post');
    });

    test('description is correct', () {
      expect(post.description, 'A test gallery post');
    });

    test('fileIds contains one entry', () {
      expect(post.fileIds, ['ak3qfimsrt4w000d']);
    });

    test('files contains one entry', () {
      expect(post.files, hasLength(1));
      expect(post.files.first.id, 'ak3qfimsrt4w000d');
    });

    test('isSensitive is false', () {
      expect(post.isSensitive, isFalse);
    });

    test('likedCount is 0', () {
      expect(post.likedCount, 0);
    });

    test('isLiked is false', () {
      expect(post.isLiked, isFalse);
    });

    test('user is deserialized', () {
      expect(post.user, isNotNull);
      expect(post.user!.username, 'testadmin');
    });

    test('createdAt is deserialized', () {
      expect(post.createdAt, isNotNull);
    });
  });

  group('MisskeyGalleryPost.fromJson (single)', () {
    late MisskeyGalleryPost post;

    setUp(() {
      final file = File('test/fixtures/gallery_post_show.json');
      final jsonMap =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      post = MisskeyGalleryPost.fromJson(jsonMap);
    });

    test('deserializes without error', () {
      expect(post, isNotNull);
    });

    test('likedCount is 1', () {
      expect(post.likedCount, 1);
    });

    test('isLiked is false', () {
      expect(post.isLiked, isFalse);
    });
  });
}
