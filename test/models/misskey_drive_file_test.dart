import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyDriveFile.fromJson', () {
    late List<MisskeyDriveFile> files;

    setUp(() {
      final file = File('test/fixtures/drive_files.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      files = jsonList
          .map((e) => MisskeyDriveFile.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    test('deserializes both files without error', () {
      expect(files, hasLength(2));
    });

    group('PNG file', () {
      late MisskeyDriveFile png;

      setUp(() => png = files[0]);

      test('name and type are correct', () {
        expect(png.name, 'test_emoji.png');
        expect(png.type, 'image/png');
      });

      test('size is correct', () {
        expect(png.size, 67);
      });

      test('has id, createdAt, md5, and url', () {
        expect(png.id, isNotEmpty);
        expect(png.createdAt, isA<DateTime>());
        expect(png.md5, isNotEmpty);
        expect(png.url, isNotEmpty);
      });

      test('image properties have width and height', () {
        expect(png.properties, isNotNull);
        expect(png.properties!.width, 1);
        expect(png.properties!.height, 1);
      });

      test('folder is null', () {
        expect(png.folder, isNull);
      });

      test('isSensitive is false', () {
        expect(png.isSensitive, isFalse);
      });

      // フィクスチャにisAiGeneratedフィールドがないのでデフォルト値falseになる
      test('isAiGenerated defaults to false when field is absent', () {
        expect(png.isAiGenerated, false);
      });
    });

    group('TXT file', () {
      late MisskeyDriveFile txt;

      setUp(() => txt = files[1]);

      test('name and type are correct', () {
        expect(txt.name, 'test_file.txt');
        expect(txt.type, 'text/plain');
      });

      test('size is correct', () {
        expect(txt.size, 18);
      });

      test('has id, createdAt, md5, and url', () {
        expect(txt.id, isNotEmpty);
        expect(txt.createdAt, isA<DateTime>());
        expect(txt.md5, isNotEmpty);
        expect(txt.url, isNotEmpty);
      });

      test('image properties have no width or height', () {
        expect(txt.properties, isNotNull);
        expect(txt.properties!.width, isNull);
        expect(txt.properties!.height, isNull);
      });

      test('folder is null', () {
        expect(txt.folder, isNull);
      });

      test('isSensitive is false', () {
        expect(txt.isSensitive, isFalse);
      });
    });
  });
}
