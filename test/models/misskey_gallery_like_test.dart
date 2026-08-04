import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyGalleryLike.fromJson', () {
    late MisskeyGalleryLike galleryLike;

    setUp(() {
      final file = File('test/fixtures/gallery_likes.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      galleryLike = MisskeyGalleryLike.fromJson(
        jsonList[0] as Map<String, dynamic>,
      );
    });

    test('id is not empty', () {
      expect(galleryLike.id, isNotEmpty);
      expect(galleryLike.id, 'ak6ou7vkrt4w001q');
    });

    test('post (gallery post) is not null', () {
      expect(galleryLike.post, isNotNull);
    });

    test('post has expected id', () {
      expect(galleryLike.post.id, 'ak6otcb6rt4w001n');
    });

    test('post has title', () {
      expect(galleryLike.post.title, 'Test Gallery Post');
    });
  });
}
