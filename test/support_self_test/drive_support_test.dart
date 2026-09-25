import 'dart:async';

import 'package:dio/dio.dart' show RequestOptions;
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/drive_fixtures.dart';
import '../support/fake_drive_server.dart';
import '../support/scripted_http_adapter.dart';

void main() {
  group('ScriptedHttpClientAdapter', () {
    test('uses FIFO responses before the registered handler', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..on('/i', (_) => ScriptedResponse.json(userJson(id: 'handler')))
        ..enqueue('/i', ScriptedResponse.json(userJson(id: 'first')))
        ..enqueue('/i', ScriptedResponse.json(userJson(id: 'second')));
      final client = testClient(adapter);
      addTearDown(client.dispose);

      expect((await client.account.i()).id, 'first');
      expect((await client.account.i()).id, 'second');
      expect((await client.account.i()).id, 'handler');
      expect(adapter.paths, ['/i', '/i', '/i']);
    });

    test('reports an unscripted path as a descriptive StateError', () async {
      final adapter = ScriptedHttpClientAdapter();

      await expectLater(
        adapter.fetch(RequestOptions(path: '/api/i'), null, null),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('No scripted response or handler registered for /i'),
          ),
        ),
      );
    });

    test('maps Misskey errors and Retry-After', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..enqueue(
          '/i',
          ScriptedResponse.error(400, code: 'BAD_REQUEST', message: 'bad'),
        )
        ..enqueue(
          '/i',
          ScriptedResponse.error(429, code: 'RATE_LIMITED', retryAfter: '12'),
        );
      final client = testClient(adapter);
      addTearDown(client.dispose);

      await expectLater(
        client.account.i(),
        throwsA(
          isA<MisskeyApiException>().having(
            (error) => error.code,
            'code',
            'BAD_REQUEST',
          ),
        ),
      );
      await expectLater(
        client.account.i(),
        throwsA(
          isA<MisskeyRateLimitException>()
              .having((error) => error.code, 'code', 'RATE_LIMITED')
              .having(
                (error) => error.retryAfter,
                'retryAfter',
                const Duration(seconds: 12),
              ),
        ),
      );
    });

    test('gated responses track concurrent requests', () async {
      final gate = Completer<void>();
      final adapter = ScriptedHttpClientAdapter()
        ..on(
          '/i',
          (_) => ScriptedResponse.gated(
            gate.future,
            ScriptedResponse.json(userJson()),
          ),
        );
      final client = testClient(adapter);
      addTearDown(client.dispose);

      final first = client.account.i();
      final second = client.account.i();
      for (var attempt = 0; attempt < 100 && adapter.inFlight < 2; attempt++) {
        await Future<void>.delayed(const Duration(milliseconds: 1));
      }
      expect(adapter.inFlight, 2);
      expect(adapter.maxInFlight, 2);
      gate.complete();
      await Future.wait([first, second]);
      expect(adapter.inFlight, 0);
    });

    test(
      'parses uploads and drains the stream for progress callbacks',
      () async {
        final adapter = ScriptedHttpClientAdapter()
          ..on(
            '/drive/files/create',
            (_) => ScriptedResponse.json(driveFileJson(id: 'uploaded')),
          );
        final client = testClient(adapter);
        addTearDown(client.dispose);
        final progress = <(int, int)>[];

        await client.drive.files.create(
          bytes: [0, 1, 255],
          filename: 'sample.bin',
          name: 'renamed.bin',
          onSendProgress: (sent, total) => progress.add((sent, total)),
        );

        final request = adapter.requests.single;
        expect(request.formFields, containsPair('i', 'test-token'));
        expect(request.formFields, containsPair('name', 'renamed.bin'));
        expect(request.formFileNames, ['sample.bin']);
        expect(request.formFileBytes, [0, 1, 255]);
        expect(progress, isNotEmpty);
        expect(progress.last.$1, progress.last.$2);
      },
    );
  });

  group('FakeDriveServer', () {
    test('paginates an untilId chain across 250 files', () async {
      final server = FakeDriveServer();
      addTearDown(server.client.dispose);
      for (var i = 0; i < 250; i++) {
        server.addFile(name: 'file-$i');
      }

      final ids = <String>[];
      String? untilId;
      for (;;) {
        final page = await server.client.drive.files.list(
          limit: 100,
          untilId: untilId,
        );
        ids.addAll(page.map((file) => file.id));
        if (page.length < 100) break;
        untilId = page.last.id;
      }

      expect(ids, hasLength(250));
      expect(ids.toSet(), hasLength(250));
      expect(
        server.adapter.paths.where((path) => path == '/drive/files'),
        hasLength(3),
      );
    });

    test('filters root, folders, and MIME prefixes', () async {
      final server = FakeDriveServer();
      addTearDown(server.client.dispose);
      final folder = server.addFolder(name: 'images');
      final root = server.addFile(name: 'root.txt', type: 'text/plain');
      final image = server.addFile(
        folderId: folder.id,
        name: 'image.png',
        type: 'image/png',
      );
      server.addFile(folderId: folder.id, name: 'movie.mp4', type: 'video/mp4');

      expect((await server.client.drive.files.list()).map((file) => file.id), [
        root.id,
      ]);
      expect(
        (await server.client.drive.files.list(
          folderId: folder.id,
          type: 'image/*',
        )).map((file) => file.id),
        [image.id],
      );
    });

    test(
      'moves known files, ignores unknown IDs, and errors for bad folders',
      () async {
        final server = FakeDriveServer();
        addTearDown(server.client.dispose);
        final folder = server.addFolder();
        final file = server.addFile();

        await server.client.drive.files.moveBulk(
          fileIds: [file.id, 'unknown'],
          folderId: folder.id,
        );
        expect(server.files.single.folderId, folder.id);
        await expectLater(
          server.client.drive.files.moveBulk(
            fileIds: [file.id],
            folderId: 'missing',
          ),
          throwsA(isA<MisskeyServerException>()),
        );
      },
    );

    test(
      'honors folder parentId omission, root move, and cycle errors',
      () async {
        final server = FakeDriveServer();
        addTearDown(server.client.dispose);
        final parent = server.addFolder(name: 'parent');
        final child = server.addFolder(parentId: parent.id, name: 'child');

        await server.client.drive.folders.update(
          folderId: child.id,
          name: 'renamed',
        );
        expect(server.folders.last.parentId, parent.id);
        await server.client.drive.folders.update(
          folderId: child.id,
          moveToRoot: true,
        );
        expect(server.folders.last.parentId, isNull);
        await server.client.drive.folders.update(
          folderId: child.id,
          parentId: parent.id,
        );
        await expectLater(
          server.client.drive.folders.update(
            folderId: parent.id,
            parentId: child.id,
          ),
          throwsA(
            isA<MisskeyApiException>().having(
              (error) => error.code,
              'code',
              'RECURSIVE_NESTING',
            ),
          ),
        );
      },
    );

    test('holds deleted files for the configured folder-delete lag', () async {
      final server = FakeDriveServer()..fileDeletionLagRequests = 1;
      addTearDown(server.client.dispose);
      final folder = server.addFolder();
      final file = server.addFile(folderId: folder.id);

      await server.client.drive.files.delete(fileId: file.id);
      expect(server.files, isEmpty);
      await expectLater(
        server.client.drive.folders.delete(folderId: folder.id),
        throwsA(
          isA<MisskeyApiException>().having(
            (error) => error.code,
            'code',
            'HAS_CHILD_FILES_OR_FOLDERS',
          ),
        ),
      );
      await server.client.drive.folders.delete(folderId: folder.id);
      expect(server.folders, isEmpty);
    });

    test('deduplicates uploaded bytes and upgrades sensitivity', () async {
      final server = FakeDriveServer(md5Of: (_) => 'same-hash');
      addTearDown(server.client.dispose);

      final first = await server.client.drive.files.create(
        bytes: [1, 2],
        filename: 'one.bin',
      );
      final second = await server.client.drive.files.create(
        bytes: [3, 4],
        filename: 'two.bin',
        isSensitive: true,
      );

      expect(second.id, first.id);
      expect(server.files, hasLength(1));
      expect(server.files.single.isSensitive, isTrue);
    });
  });
}
