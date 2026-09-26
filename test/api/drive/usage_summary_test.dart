import 'dart:async';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import 'package:misskey_client/src/internal/drive/folder_tree_builder.dart';
import 'package:misskey_client/src/internal/id_paginator.dart';
import '../../support/drive_fixtures.dart';
import '../../support/fake_drive_server.dart';
import '../../support/scripted_http_adapter.dart';

void main() {
  late FakeDriveServer server;

  setUp(() => server = FakeDriveServer());
  tearDown(() => server.client.dispose());

  test(
    'aggregates direct and recursive usage through three folder levels',
    () async {
      final top = server.addFolder(name: 'top');
      final middle = server.addFolder(parentId: top.id, name: 'middle');
      final bottom = server.addFolder(parentId: middle.id, name: 'bottom');
      final sibling = server.addFolder(parentId: top.id, name: 'sibling');
      server.addFile(folderId: middle.id, size: 20);
      server.addFile(folderId: bottom.id, size: 40);
      server.addFile(folderId: sibling.id, size: 30);

      final summary = await server.client.drive.getUsageSummary();
      final topUsage = summary.folderUsage(top.id)!;
      final middleUsage = summary.folderUsage(middle.id)!;
      final bottomUsage = summary.folderUsage(bottom.id)!;

      expect(
        summary.total,
        const DriveUsageStats(fileCount: 3, totalBytes: 90),
      );
      expect(topUsage.direct, DriveUsageStats.zero);
      expect(
        topUsage.recursive,
        const DriveUsageStats(fileCount: 3, totalBytes: 90),
      );
      expect(
        middleUsage.recursive,
        const DriveUsageStats(fileCount: 2, totalBytes: 60),
      );
      expect(
        bottomUsage.recursive,
        const DriveUsageStats(fileCount: 1, totalBytes: 40),
      );
      expect(
        summary.folderUsage(sibling.id)!.recursive,
        const DriveUsageStats(fileCount: 1, totalBytes: 30),
      );
    },
  );

  test(
    'separates root and unassigned files and groups exact MIME types',
    () async {
      final folder = server.addFolder();
      server.failWhen(
        '/drive/stream',
        (request) => request.jsonBody?['untilId'] == null,
        ScriptedResponse.json([
          driveFileJson(id: 'root', size: 4, type: 'text/plain'),
          driveFileJson(
            id: 'assigned',
            folderId: folder.id,
            size: 6,
            type: 'custom',
          ),
          driveFileJson(
            id: 'unassigned',
            folderId: 'missing',
            size: 8,
            type: 'custom',
          ),
        ]),
      );

      final summary = await server.client.drive.getUsageSummary();

      expect(summary.root, const DriveUsageStats(fileCount: 1, totalBytes: 4));
      expect(
        summary.unassigned,
        const DriveUsageStats(fileCount: 1, totalBytes: 8),
      );
      expect(
        summary.byMimeType['custom'],
        const DriveUsageStats(fileCount: 2, totalBytes: 14),
      );
      expect(
        summary.byMimeType['text/plain'],
        const DriveUsageStats(fileCount: 1, totalBytes: 4),
      );
      expect(
        () => summary.byMimeType['custom'] = DriveUsageStats.zero,
        throwsUnsupportedError,
      );
    },
  );

  test('returns an empty summary for an empty Drive', () async {
    final summary = await server.client.drive.getUsageSummary();

    expect(summary.total, DriveUsageStats.zero);
    expect(summary.root, DriveUsageStats.zero);
    expect(summary.unassigned, DriveUsageStats.zero);
    expect(summary.folders, isEmpty);
    expect(summary.byMimeType, isEmpty);
  });

  for (final path in ['/drive/stream', '/drive/folders']) {
    test('rethrows an error from $path', () async {
      server.failWhen(
        path,
        (_) => true,
        ScriptedResponse.error(400, code: 'TEST_ERROR'),
      );

      await expectLater(
        server.client.drive.getUsageSummary(),
        throwsA(isA<MisskeyApiException>()),
      );
    });
  }

  test('cancels file scanning when folder traversal fails', () async {
    for (var i = 0; i < 250; i++) {
      server.addFile();
    }
    final progress = <int>[];
    server.failWhen(
      '/drive/folders',
      (_) => true,
      ScriptedResponse.error(400, code: 'TEST_ERROR'),
    );

    await expectLater(
      server.client.drive.getUsageSummary(onProgress: progress.add),
      throwsA(isA<MisskeyApiException>()),
    );
    final streamRequestsAfterFailure = server.adapter.requests
        .where((request) => request.path == '/drive/stream')
        .length;
    final progressAfterFailure = List<int>.of(progress);

    await _waitForRequestsToSettle(server);

    expect(
      server.adapter.requests
          .where((request) => request.path == '/drive/stream')
          .length,
      streamRequestsAfterFailure,
    );
    expect(progress, progressAfterFailure);
  });

  test('stops tree traversal when the file stream fails', () async {
    final root = server.addFolder();
    final child = server.addFolder(parentId: root.id);
    server.addFolder(parentId: child.id);
    final folderGate = Completer<void>();
    final streamGate = Completer<void>();
    server.failWhen(
      '/drive/folders',
      (request) => request.jsonBody?['folderId'] == root.id,
      ScriptedResponse.gated(
        folderGate.future,
        ScriptedResponse.json([
          driveFolderJson(id: child.id, parentId: root.id),
        ]),
      ),
    );
    server.failWhen(
      '/drive/stream',
      (request) => request.jsonBody?['untilId'] == null,
      ScriptedResponse.gated(
        streamGate.future,
        ScriptedResponse.error(400, code: 'TEST_ERROR'),
      ),
    );

    final summary = server.client.drive.getUsageSummary();
    await _waitFor(
      () => server.adapter.requests.any(
        (request) =>
            request.path == '/drive/folders' &&
            request.jsonBody?['folderId'] == root.id,
      ),
    );
    streamGate.complete();
    await expectLater(summary, throwsA(isA<MisskeyApiException>()));
    final folderRequestsAfterFailure = server.adapter.requests
        .where((request) => request.path == '/drive/folders')
        .length;

    folderGate.complete();
    await _waitForRequestsToSettle(server);

    expect(
      server.adapter.requests
          .where((request) => request.path == '/drive/folders')
          .length,
      folderRequestsAfterFailure,
    );
  });

  test('stops tree traversal when progress reporting fails', () async {
    final root = server.addFolder();
    final child = server.addFolder(parentId: root.id);
    server.addFolder(parentId: child.id);
    final folderGate = Completer<void>();
    final streamGate = Completer<void>();
    server.failWhen(
      '/drive/folders',
      (request) => request.jsonBody?['folderId'] == root.id,
      ScriptedResponse.gated(
        folderGate.future,
        ScriptedResponse.json([
          driveFolderJson(id: child.id, parentId: root.id),
        ]),
      ),
    );
    server.failWhen(
      '/drive/stream',
      (request) => request.jsonBody?['untilId'] == null,
      ScriptedResponse.gated(
        streamGate.future,
        ScriptedResponse.json([driveFileJson(id: 'file')]),
      ),
    );

    final summary = server.client.drive.getUsageSummary(
      onProgress: (_) => throw StateError('progress failed'),
    );
    await _waitFor(
      () => server.adapter.requests.any(
        (request) =>
            request.path == '/drive/folders' &&
            request.jsonBody?['folderId'] == root.id,
      ),
    );
    streamGate.complete();
    await expectLater(summary, throwsStateError);
    final folderRequestsAfterFailure = server.adapter.requests
        .where((request) => request.path == '/drive/folders')
        .length;

    folderGate.complete();
    await _waitForRequestsToSettle(server);

    expect(
      server.adapter.requests
          .where((request) => request.path == '/drive/folders')
          .length,
      folderRequestsAfterFailure,
    );
  });

  test('does not start queued sibling listings after scan failure', () async {
    final first = server.addFolder();
    final second = server.addFolder();
    final third = server.addFolder();
    final folderGate = Completer<void>();
    final streamGate = Completer<void>();
    server.failWhen(
      '/drive/folders',
      (request) =>
          request.jsonBody?['folderId'] == second.id ||
          request.jsonBody?['folderId'] == third.id,
      ScriptedResponse.gated(folderGate.future, ScriptedResponse.json([])),
      times: -1,
    );
    server.failWhen(
      '/drive/stream',
      (request) => request.jsonBody?['untilId'] == null,
      ScriptedResponse.gated(
        streamGate.future,
        ScriptedResponse.error(400, code: 'TEST_ERROR'),
      ),
    );

    final summary = server.client.drive.getUsageSummary(concurrency: 2);
    await _waitFor(
      () =>
          server.adapter.requests
              .where(
                (request) =>
                    request.path == '/drive/folders' &&
                    request.jsonBody?['folderId'] != null,
              )
              .length ==
          2,
    );
    streamGate.complete();
    await expectLater(summary, throwsA(isA<MisskeyApiException>()));

    folderGate.complete();
    await _waitForRequestsToSettle(server);

    expect(
      server.adapter.requests.any(
        (request) =>
            request.path == '/drive/folders' &&
            request.jsonBody?['folderId'] == first.id,
      ),
      isFalse,
    );
  });

  test('cancels a full folder page before fetching its continuation', () async {
    final cancellation = MisskeyCancellationToken();
    var fetches = 0;
    var delivered = 0;
    final pageGate = Completer<void>();
    final page = [
      for (var i = 0; i < 100; i++)
        MisskeyDriveFolder.fromJson(driveFolderJson(id: idAt(i + 1))),
    ];

    final tree = buildDriveFolderTree(
      show: (_) => throw UnimplementedError(),
      listAll: (_) =>
          paginateById(
            fetchPage: (_, _) async {
              fetches++;
              await pageGate.future;
              return page;
            },
            idOf: (folder) => folder.id,
            pageSize: 100,
          ).map((folder) {
            if (++delivered == 100) cancellation.cancel();
            return folder;
          }),
      rootFolderId: null,
      maxDepth: null,
      concurrency: 1,
      cancellation: cancellation,
    );
    await _waitFor(() => fetches == 1);
    pageGate.complete();
    await tree;

    expect(fetches, 1);
  });

  test('discards an in-flight tree error after scan failure', () async {
    final root = server.addFolder();
    final folderGate = Completer<void>();
    final streamGate = Completer<void>();
    final uncaught = <Object>[];
    server.failWhen(
      '/drive/folders',
      (request) => request.jsonBody?['folderId'] == root.id,
      ScriptedResponse.gated(
        folderGate.future,
        ScriptedResponse.error(400, code: 'TREE_ERROR'),
      ),
    );
    server.failWhen(
      '/drive/stream',
      (request) => request.jsonBody?['untilId'] == null,
      ScriptedResponse.gated(
        streamGate.future,
        ScriptedResponse.error(400, code: 'SCAN_ERROR'),
      ),
    );

    await runZonedGuarded(() async {
      final summary = server.client.drive.getUsageSummary();
      await _waitFor(
        () => server.adapter.requests.any(
          (request) =>
              request.path == '/drive/folders' &&
              request.jsonBody?['folderId'] == root.id,
        ),
      );
      streamGate.complete();
      await expectLater(summary, throwsA(isA<MisskeyApiException>()));
      folderGate.complete();
      await _waitForRequestsToSettle(server);
    }, (error, _) => uncaught.add(error));

    expect(uncaught, isEmpty);
  });

  test(
    'reports progress across pages through the final scanned file count',
    () async {
      for (var i = 0; i < 101; i++) {
        server.addFile();
      }
      final progress = <int>[];

      final summary = await server.client.drive.getUsageSummary(
        onProgress: progress.add,
      );

      expect(progress, [for (var i = 1; i <= 101; i++) i]);
      expect(progress.last, summary.total.fileCount);
      expect(
        server.adapter.requests.where(
          (request) => request.path == '/drive/stream',
        ),
        hasLength(2),
      );
    },
  );

  test('exposes folder usage in pre-order and supports lookup', () async {
    final first = server.addFolder();
    final second = server.addFolder();
    final child = server.addFolder(parentId: first.id);

    final summary = await server.client.drive.getUsageSummary();

    expect(summary.allFolders.map((usage) => usage.folder.id), [
      second.id,
      first.id,
      child.id,
    ]);
    expect(summary.folderUsage(child.id)!.folder.id, child.id);
    expect(summary.folderUsage('missing'), isNull);
    expect(
      () => summary.folders.add(summary.folders.first),
      throwsUnsupportedError,
    );
  });

  test('validates concurrency before sending requests', () {
    expect(
      () => server.client.drive.getUsageSummary(concurrency: 0),
      throwsArgumentError,
    );
    expect(server.adapter.requests, isEmpty);
  });

  test('paginates 250 files in three stream requests', () async {
    for (var i = 0; i < 250; i++) {
      server.addFile(size: 1);
    }

    final summary = await server.client.drive.getUsageSummary();
    final streamRequests = server.adapter.requests
        .where((request) => request.path == '/drive/stream')
        .toList();

    expect(
      summary.total,
      const DriveUsageStats(fileCount: 250, totalBytes: 250),
    );
    expect(streamRequests, hasLength(3));
    expect(streamRequests.map((request) => request.jsonBody?['limit']), [
      100,
      100,
      100,
    ]);
  });
}

Future<void> _waitForRequestsToSettle(FakeDriveServer server) =>
    _waitFor(() => server.adapter.inFlight == 0);

Future<void> _waitFor(bool Function() condition) async {
  while (!condition()) {
    await Future<void>.delayed(Duration.zero);
  }
}
