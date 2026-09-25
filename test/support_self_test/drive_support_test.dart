import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart' show RequestOptions, ResponseBody;
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
          ScriptedResponse.error(
            429,
            code: 'RATE_LIMIT_EXCEEDED',
            retryAfter: '12',
          ),
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
              .having((error) => error.code, 'code', 'RATE_LIMIT_EXCEEDED')
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
      final bothRequestsEntered = Completer<void>();
      var entered = 0;
      final adapter = ScriptedHttpClientAdapter()
        ..on('/i', (_) {
          if (++entered == 2) bothRequestsEntered.complete();
          return ScriptedResponse.gated(
            gate.future,
            ScriptedResponse.json(userJson()),
          );
        });
      final client = testClient(adapter);
      addTearDown(client.dispose);

      final first = client.account.i();
      final second = client.account.i();
      await bothRequestsEntered.future;
      expect(adapter.inFlight, 2);
      expect(adapter.maxInFlight, 2);
      gate.complete();
      await Future.wait([first, second]);
      expect(adapter.inFlight, 0);
    });

    test('counts an upload while its supplied stream is still open', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..on(
          '/drive/files/create',
          (_) => ScriptedResponse.json(driveFileJson(id: 'uploaded')),
        );
      final controller = StreamController<Uint8List>();

      final fetch = adapter.fetch(
        RequestOptions(
          path: '/api/drive/files/create',
          data: <String, dynamic>{},
        ),
        controller.stream,
        null,
      );
      expect(adapter.inFlight, 1);
      expect(adapter.maxInFlight, 1);
      await controller.close();
      await fetch;
      expect(adapter.inFlight, 0);
    });

    test('drains JSON streams and propagates stream failures', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..on('/i', (_) => ScriptedResponse.json(userJson()));
      var jsonStreamListened = false;
      final controller = StreamController<Uint8List>(
        onListen: () => jsonStreamListened = true,
      );
      controller.add(Uint8List.fromList([1]));
      final jsonFetch = adapter.fetch(
        RequestOptions(path: '/api/i', data: <String, dynamic>{}),
        controller.stream,
        null,
      );
      await controller.close();
      await jsonFetch;
      expect(jsonStreamListened, isTrue);

      await expectLater(
        adapter.fetch(
          RequestOptions(path: '/api/i', data: <String, dynamic>{}),
          Stream<Uint8List>.error(StateError('stream failure')),
          null,
        ),
        throwsA(isA<StateError>()),
      );
      expect(adapter.inFlight, 0);
      expect(adapter.maxInFlight, 1);
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
    test(
      'validates raw request boundaries with server-shaped errors',
      () async {
        final server = FakeDriveServer();
        addTearDown(server.client.dispose);

        Future<ResponseBody> request(String path, Map<String, dynamic> body) =>
            server.adapter.fetch(
              RequestOptions(path: '/api$path', data: body),
              Stream<Uint8List>.empty(),
              null,
            );

        expect((await request('/drive/stream', {'limit': 1})).statusCode, 200);
        final explicitNull = await request('/drive/stream', {
          'limit': 1,
          'type': null,
        });
        expect(explicitNull.statusCode, 400);
        final error = await _jsonBody(explicitNull);
        expect(error, {
          'error': {
            'message': 'Invalid param.',
            'code': 'INVALID_PARAM',
            'id': '3d81ceae-475f-4600-b2a8-2bc116157532',
            'kind': 'client',
            'info': {'param': '', 'reason': ''},
          },
        });
        expect(
          (await request('/drive/files', {'limit': null})).statusCode,
          400,
        );
        expect(
          (await request('/drive/files/move-bulk', {
            'fileIds': [1],
          })).statusCode,
          400,
        );
        expect(
          (await request('/drive/files/move-bulk', {
            'fileIds': ['invalid-id!'],
          })).statusCode,
          400,
        );
      },
    );

    test('validates before applying folder and file updates', () async {
      final server = FakeDriveServer();
      addTearDown(server.client.dispose);
      final parent = server.addFolder(name: 'parent');
      final child = server.addFolder(parentId: parent.id, name: 'child');
      final file = server.addFile(name: 'original', folderId: parent.id)
        ..isSensitive = false
        ..comment = 'original comment';

      await expectLater(
        server.client.drive.folders.update(
          folderId: child.id,
          name: 'changed',
          parentId: 'missing',
        ),
        throwsA(isA<MisskeyApiException>()),
      );
      expect(child.name, 'child');
      expect(child.parentId, parent.id);
      await expectLater(
        server.client.drive.folders.update(
          folderId: parent.id,
          name: 'changed parent',
          parentId: child.id,
        ),
        throwsA(isA<MisskeyApiException>()),
      );
      expect(parent.name, 'parent');

      await expectLater(
        server.client.drive.files.update(
          fileId: file.id,
          name: 'changed',
          folderId: 'missing',
          isSensitive: true,
          comment: const Optional('changed comment'),
        ),
        throwsA(isA<MisskeyApiException>()),
      );
      expect(file.name, 'original');
      expect(file.folderId, parent.id);
      expect(file.isSensitive, isFalse);
      expect(file.comment, 'original comment');
    });

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
        await server.client.drive.folders.update(folderId: child.id, name: '');
        expect(server.folders.last.name, 'renamed');
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

    test(
      'keeps delayed deletions visible until folder-delete advances lag',
      () async {
        final server = FakeDriveServer()..fileDeletionLagRequests = 1;
        addTearDown(server.client.dispose);
        final folder = server.addFolder();
        final file = server.addFile(folderId: folder.id, name: 'pending.png');

        await server.client.drive.files.delete(fileId: file.id);
        expect(server.files, hasLength(1));
        expect(
          (await server.client.drive.files.list(folderId: folder.id)).single.id,
          file.id,
        );
        expect(
          (await server.client.drive.stream(type: 'image/*')).single.id,
          file.id,
        );
        expect(
          (await server.client.drive.files.showByFileId(file.id)).id,
          file.id,
        );
        expect(
          (await server.client.drive.files.find(
            name: 'pending.png',
            folderId: folder.id,
          )).single.id,
          file.id,
        );
        await server.client.drive.files.delete(fileId: file.id);
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
        expect(server.files, isEmpty);
        await server.client.drive.folders.delete(folderId: folder.id);
        expect(server.folders, isEmpty);
      },
    );

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

    test('uses real MD5 so reordered bytes do not deduplicate', () async {
      final server = FakeDriveServer();
      addTearDown(server.client.dispose);

      final first = await server.client.drive.files.create(
        bytes: [1, 2],
        filename: 'first.bin',
      );
      final identical = await server.client.drive.files.create(
        bytes: [1, 2],
        filename: 'identical.bin',
      );
      final reordered = await server.client.drive.files.create(
        bytes: [2, 1],
        filename: 'reordered.bin',
      );
      expect(identical.id, first.id);
      expect(reordered.id, isNot(first.id));
      expect(server.files, hasLength(2));
    });

    test(
      'force upload bypasses MD5 deduplication and rejects missing folders',
      () async {
        final server = FakeDriveServer(md5Of: (_) => 'same-hash');
        addTearDown(server.client.dispose);

        final first = await server.client.drive.files.create(
          bytes: [1],
          filename: 'first.bin',
        );
        final forced = await server.client.drive.files.create(
          bytes: [2],
          filename: 'second.bin',
          force: true,
        );
        expect(forced.id, isNot(first.id));
        await expectLater(
          server.client.drive.files.create(
            bytes: [3],
            filename: 'missing.bin',
            folderId: 'missing',
            force: true,
          ),
          throwsA(isA<MisskeyServerException>()),
        );
      },
    );

    test('uses QueryService ordering for files and folders', () async {
      final server = FakeDriveServer();
      addTearDown(server.client.dispose);
      final files = [
        server.addFile(),
        server.addFile(),
        server.addFile(),
        server.addFile(),
      ];
      final folders = [
        server.addFolder(),
        server.addFolder(),
        server.addFolder(),
        server.addFolder(),
      ];

      expect(
        (await server.client.drive.files.list(
          sinceId: files[0].id,
        )).map((file) => file.id),
        [files[1].id, files[2].id, files[3].id],
      );
      expect(
        (await server.client.drive.folders.list(
          sinceId: folders[0].id,
        )).map((folder) => folder.id),
        [folders[1].id, folders[2].id, folders[3].id],
      );
      expect(
        (await server.client.drive.files.list(
          sinceId: files[0].id,
          untilId: files[3].id,
        )).map((file) => file.id),
        [files[2].id, files[1].id],
      );
      expect(
        (await server.client.drive.folders.list(
          sinceId: folders[0].id,
          untilId: folders[3].id,
        )).map((folder) => folder.id),
        [folders[2].id, folders[1].id],
      );
    });

    test(
      'filters stream MIME types and rejects server-invalid types',
      () async {
        final server = FakeDriveServer();
        addTearDown(server.client.dispose);
        final image = server.addFile(type: 'image/png');
        server.addFile(type: 'video/webm');

        expect(
          (await server.client.drive.stream(
            type: 'image/*',
          )).map((file) => file.id),
          [image.id],
        );
        // type の省略はすべての種類を返す
        expect(await server.client.drive.stream(), hasLength(2));
        await expectLater(
          server.client.drive.stream(type: 'video/mp4'),
          throwsA(
            isA<MisskeyApiException>().having(
              (error) => error.code,
              'code',
              'INVALID_PARAM',
            ),
          ),
        );
      },
    );

    test(
      'finds files and hashes and returns recursive folder detail',
      () async {
        final server = FakeDriveServer();
        addTearDown(server.client.dispose);
        final grandparent = server.addFolder(name: 'grandparent');
        final parent = server.addFolder(
          parentId: grandparent.id,
          name: 'parent',
        );
        final child = server.addFolder(parentId: parent.id, name: 'child');
        final file = server.addFile(
          folderId: child.id,
          name: 'needle.png',
          md5: 'needle',
        );

        expect(
          (await server.client.drive.files.find(
            name: 'needle.png',
            folderId: child.id,
          )).single.id,
          file.id,
        );
        expect(
          (await server.client.drive.files.findByHash(md5: 'needle')).single.id,
          file.id,
        );
        final detail = await server.client.drive.folders.show(
          folderId: child.id,
        );
        expect(detail.filesCount, 1);
        expect(detail.parent!.foldersCount, 1);
        expect(detail.parent!.parent!.id, grandparent.id);
        expect(detail.parent!.parent!.foldersCount, 1);
      },
    );

    test('round-trips UTF-8 multipart names and JSON folder names', () async {
      final server = FakeDriveServer();
      addTearDown(server.client.dispose);

      final file = await server.client.drive.files.create(
        bytes: [1],
        filename: '日本語.png',
        name: '写真.png',
      );
      final folder = await server.client.drive.folders.create(name: '資料');
      expect(file.name, '写真.png');
      expect(folder.name, '資料');
    });

    test('injects faults a finite number of times or forever', () async {
      final server = FakeDriveServer();
      addTearDown(server.client.dispose);
      server.failWhen(
        '/i',
        (_) => true,
        ScriptedResponse.error(400, code: 'ONCE'),
      );
      await expectLater(
        server.client.account.i(),
        throwsA(isA<MisskeyApiException>()),
      );
      await server.client.account.i();

      server.failWhen(
        '/i',
        (_) => true,
        ScriptedResponse.error(400, code: 'ALWAYS'),
        times: -1,
      );
      await expectLater(
        server.client.account.i(),
        throwsA(isA<MisskeyApiException>()),
      );
      await expectLater(
        server.client.account.i(),
        throwsA(isA<MisskeyApiException>()),
      );
    });
  });
}

Future<Map<String, dynamic>> _jsonBody(ResponseBody response) async {
  final bytes = <int>[];
  await for (final chunk in response.stream) {
    bytes.addAll(chunk);
  }
  return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
}
