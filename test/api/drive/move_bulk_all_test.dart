import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../../support/fake_drive_server.dart';
import '../../support/scripted_http_adapter.dart';

void main() {
  late FakeDriveServer server;

  setUp(() => server = FakeDriveServer());
  tearDown(() => server.client.dispose());

  test('zero IDs send no requests', () async {
    final result = await server.client.drive.files.moveBulkAll(fileIds: []);

    expect(result.requestedCount, 0);
    expect(result.uniqueFileIds, isEmpty);
    expect(result.chunks.items, isEmpty);
    expect(result.isComplete, isTrue);
    expect(result.unconfirmedFileIds, isEmpty);
    expect(server.adapter.requests, isEmpty);
  });

  test('zero IDs skip destination validation for a non-null folder', () async {
    final result = await server.client.drive.files.moveBulkAll(
      fileIds: [],
      folderId: 'missing-folder',
    );

    expect(result.isComplete, isTrue);
    expect(server.adapter.requests, isEmpty);
  });

  test(
    'moves 100 IDs in one root request with an explicit null folder',
    () async {
      final files = [for (var i = 0; i < 100; i++) server.addFile()];

      final result = await server.client.drive.files.moveBulkAll(
        fileIds: files.map((file) => file.id),
      );

      expect(result.isComplete, isTrue);
      expect(server.adapter.paths, ['/drive/files/move-bulk']);
      expect(
        server.adapter.requests.single.jsonBody?['fileIds'],
        files.map((file) => file.id).toList(),
      );
      expect(server.adapter.requests.single.jsonBody?['folderId'], isNull);
      expect(server.files.every((file) => file.folderId == null), isTrue);
    },
  );

  test('splits 101 IDs into chunks of 100 and 1', () async {
    final files = [for (var i = 0; i < 101; i++) server.addFile()];

    final result = await server.client.drive.files.moveBulkAll(
      fileIds: files.map((file) => file.id),
    );

    expect(result.chunks.items, hasLength(2));
    expect(
      server.adapter.requests.map((request) => request.jsonBody?['fileIds']),
      [
        files.take(100).map((file) => file.id).toList(),
        [files.last.id],
      ],
    );
  });

  test(
    'deduplicates IDs across a chunk boundary in first-occurrence order',
    () async {
      final files = [for (var i = 0; i < 101; i++) server.addFile()];
      final ids = files.map((file) => file.id).toList();
      final input = [...ids.take(100), ids[50], ids[100]];

      final result = await server.client.drive.files.moveBulkAll(
        fileIds: input,
      );

      expect(result.requestedCount, 102);
      expect(result.uniqueFileIds, ids);
      expect(result.chunks.items, hasLength(2));
      expect(
        server.adapter.requests.map((request) => request.jsonBody?['fileIds']),
        [
          ids.take(100).toList(),
          [ids[100]],
        ],
      );
    },
  );

  test('validates a non-null destination folder before moving files', () async {
    final folder = server.addFolder();
    final file = server.addFile();

    final result = await server.client.drive.files.moveBulkAll(
      fileIds: [file.id],
      folderId: folder.id,
    );

    expect(result.isComplete, isTrue);
    expect(server.adapter.paths, [
      '/drive/folders/show',
      '/drive/files/move-bulk',
    ]);
    expect(server.files.single.folderId, folder.id);
  });

  test(
    'a missing destination folder throws before move-bulk requests',
    () async {
      final file = server.addFile();

      await expectLater(
        server.client.drive.files.moveBulkAll(
          fileIds: [file.id],
          folderId: 'missing-folder',
        ),
        throwsA(
          isA<MisskeyApiException>().having(
            (error) => error.code,
            'code',
            'NO_SUCH_FOLDER',
          ),
        ),
      );
      expect(server.adapter.paths, ['/drive/folders/show']);
      expect(server.files.single.folderId, isNull);
    },
  );

  test(
    'stops after a failed second chunk and reports unconfirmed IDs',
    () async {
      final folder = server.addFolder();
      final files = [for (var i = 0; i < 250; i++) server.addFile()];
      final ids = files.map((file) => file.id).toList();
      server.failWhen(
        '/drive/files/move-bulk',
        (request) => (request.jsonBody?['fileIds'] as List?)?.first == ids[100],
        ScriptedResponse.error(500, code: 'TEST_ERROR'),
      );

      final result = await server.client.drive.files.moveBulkAll(
        fileIds: ids,
        folderId: folder.id,
      );

      expect(server.adapter.paths, [
        '/drive/folders/show',
        '/drive/files/move-bulk',
        '/drive/files/move-bulk',
      ]);
      expect(result.chunks.successes, hasLength(1));
      expect(result.chunks.failures, hasLength(1));
      expect(
        result.chunks.skipped.single.reason,
        MisskeyBatchSkipReason.stoppedAfterError,
      );
      expect(result.unconfirmedFileIds, ids.sublist(100));
      expect(result.isComplete, isFalse);
      expect(
        files.take(100).every((file) => file.folderId == folder.id),
        isTrue,
      );
      expect(files.skip(100).every((file) => file.folderId == null), isTrue);
    },
  );

  for (final status in [400, 404]) {
    test('an old-server $status move-bulk error is a chunk failure', () async {
      final file = server.addFile();
      server.failWhen(
        '/drive/files/move-bulk',
        (_) => true,
        ScriptedResponse.error(status, code: 'ENDPOINT_NOT_FOUND'),
      );

      final result = await server.client.drive.files.moveBulkAll(
        fileIds: [file.id],
      );

      final failure = result.chunks.failures.single;
      expect(failure.error, isA<MisskeyApiException>());
      expect((failure.error as MisskeyApiException).statusCode, status);
      expect(result.isComplete, isFalse);
      expect(result.unconfirmedFileIds, [file.id]);
    });
  }
}
