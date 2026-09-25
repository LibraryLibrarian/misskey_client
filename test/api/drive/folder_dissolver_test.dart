import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../../support/fake_drive_server.dart';
import '../../support/scripted_http_adapter.dart';

void main() {
  late FakeDriveServer server;

  setUp(() => server = FakeDriveServer());
  tearDown(() => server.client.dispose());

  test('dissolves a root folder into root and deletes it', () async {
    final folder = server.addFolder();
    final file = server.addFile(folderId: folder.id);
    final subfolder = server.addFolder(parentId: folder.id);

    final result = await server.client.drive.dissolveFolder(
      folderId: folder.id,
    );

    expect(result.folder.id, folder.id);
    expect(result.targetFolderId, isNull);
    expect(result.isComplete, isTrue);
    expect(result.files.isComplete, isTrue);
    expect(result.subfolders.isComplete, isTrue);
    expect(
      result.deletion,
      isA<MisskeyBatchSuccess<MisskeyDriveFolder, Null>>(),
    );
    expect(server.adapter.paths, [
      '/drive/folders/show',
      '/drive/files',
      '/drive/folders',
      '/drive/files/move-bulk',
      '/drive/folders/update',
      '/drive/folders/delete',
    ]);
    expect(server.adapter.requests[3].jsonBody?['folderId'], isNull);
    expect(
      server.adapter.requests[4].jsonBody,
      containsPair('parentId', isNull),
    );
    expect(server.files.single.id, file.id);
    expect(server.files.single.folderId, isNull);
    expect(server.folders.single.id, subfolder.id);
    expect(server.folders.single.parentId, isNull);
  });

  test('dissolves a nested folder into its parent', () async {
    final parent = server.addFolder();
    final folder = server.addFolder(parentId: parent.id);
    final file = server.addFile(folderId: folder.id);
    final subfolder = server.addFolder(parentId: folder.id);

    final result = await server.client.drive.dissolveFolder(
      folderId: folder.id,
    );

    expect(result.targetFolderId, parent.id);
    expect(server.adapter.paths, [
      '/drive/folders/show',
      '/drive/files',
      '/drive/folders',
      '/drive/folders/show',
      '/drive/files/move-bulk',
      '/drive/folders/update',
      '/drive/folders/delete',
    ]);
    expect(server.adapter.requests[4].jsonBody?['folderId'], parent.id);
    expect(server.adapter.requests[5].jsonBody?['parentId'], parent.id);
    expect(
      server.files.singleWhere((item) => item.id == file.id).folderId,
      parent.id,
    );
    expect(
      server.folders.singleWhere((item) => item.id == subfolder.id).parentId,
      parent.id,
    );
    expect(
      server.folders.map((item) => item.id),
      containsAll([parent.id, subfolder.id]),
    );
    expect(server.folders.map((item) => item.id), isNot(contains(folder.id)));
  });

  test('splits 150 direct files into two move-bulk requests', () async {
    final folder = server.addFolder();
    for (var index = 0; index < 150; index++) {
      server.addFile(folderId: folder.id);
    }

    final result = await server.client.drive.dissolveFolder(
      folderId: folder.id,
    );

    expect(result.files.chunks.items, hasLength(2));
    final bulkRequests = server.adapter.requests
        .where((request) => request.path == '/drive/files/move-bulk')
        .toList();
    expect(bulkRequests, hasLength(2));
    expect(
      bulkRequests.map(
        (request) => (request.jsonBody?['fileIds'] as List).length,
      ),
      [100, 50],
    );
    expect(server.files.every((file) => file.folderId == null), isTrue);
  });

  test(
    'dissolves an empty folder with only read and delete requests',
    () async {
      final folder = server.addFolder();

      final result = await server.client.drive.dissolveFolder(
        folderId: folder.id,
      );

      expect(result.isComplete, isTrue);
      expect(result.files.chunks.items, isEmpty);
      expect(result.subfolders.items, isEmpty);
      expect(server.adapter.paths, [
        '/drive/folders/show',
        '/drive/files',
        '/drive/folders',
        '/drive/folders/delete',
      ]);
    },
  );

  test('skips deletion after a subfolder move fails', () async {
    final folder = server.addFolder();
    final subfolder = server.addFolder(parentId: folder.id);
    server.failWhen(
      '/drive/folders/update',
      (request) => request.jsonBody?['folderId'] == subfolder.id,
      ScriptedResponse.error(400, code: 'TEST_ERROR'),
    );

    final result = await server.client.drive.dissolveFolder(
      folderId: folder.id,
    );

    expect(result.subfolders.failures, hasLength(1));
    final deletion =
        result.deletion as MisskeyBatchSkipped<MisskeyDriveFolder, Null>;
    expect(deletion.reason, MisskeyBatchSkipReason.dependencyFailed);
    expect(server.adapter.paths, isNot(contains('/drive/folders/delete')));
    expect(
      server.folders.map((item) => item.id),
      containsAll([folder.id, subfolder.id]),
    );
  });

  test('reports a failed delete after all moves succeed', () async {
    final folder = server.addFolder();
    server.failWhen(
      '/drive/folders/delete',
      (_) => true,
      ScriptedResponse.error(400, code: 'HAS_CHILD_FILES_OR_FOLDERS'),
    );

    final result = await server.client.drive.dissolveFolder(
      folderId: folder.id,
    );

    final deletion =
        result.deletion as MisskeyBatchFailure<MisskeyDriveFolder, Null>;
    expect(
      deletion.error,
      isA<MisskeyApiException>().having(
        (error) => error.code,
        'code',
        'HAS_CHILD_FILES_OR_FOLDERS',
      ),
    );
    expect(result.isComplete, isFalse);
    expect(server.folders.map((item) => item.id), contains(folder.id));
  });

  test('throws for a missing folder before any mutation request', () async {
    await expectLater(
      server.client.drive.dissolveFolder(folderId: 'missing-folder'),
      throwsA(
        isA<MisskeyApiException>().having(
          (error) => error.code,
          'code',
          'NO_SUCH_FOLDER',
        ),
      ),
    );

    expect(server.adapter.paths, ['/drive/folders/show']);
  });

  test('throws for a list error before any mutation request', () async {
    final folder = server.addFolder();
    server.failWhen(
      '/drive/files',
      (_) => true,
      ScriptedResponse.error(400, code: 'TEST_ERROR'),
    );

    await expectLater(
      server.client.drive.dissolveFolder(folderId: folder.id),
      throwsA(isA<MisskeyApiException>()),
    );

    expect(server.adapter.paths, ['/drive/folders/show', '/drive/files']);
    expect(
      server.adapter.paths,
      isNot(
        containsAll([
          '/drive/files/move-bulk',
          '/drive/folders/update',
          '/drive/folders/delete',
        ]),
      ),
    );
  });

  test('validates concurrency before sending a request', () async {
    await expectLater(
      server.client.drive.dissolveFolder(folderId: 'folder', concurrency: 0),
      throwsArgumentError,
    );

    expect(server.adapter.requests, isEmpty);
  });
}
