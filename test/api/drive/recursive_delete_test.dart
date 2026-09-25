import 'dart:async';

import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/internal/drive/recursive_deleter.dart';
import 'package:test/test.dart';

import '../../support/fake_drive_server.dart';
import '../../support/scripted_http_adapter.dart';

void main() {
  late FakeDriveServer server;
  setUp(() => server = FakeDriveServer());
  tearDown(() => server.client.dispose());

  List<RecordedRequest> deletes() => server.adapter.requests
      .where((request) => request.path.endsWith('/delete'))
      .toList();

  test(
    'dry run plans counts, bytes, ordering and immutable collections',
    () async {
      final root = server.addFolder();
      final a = server.addFolder(parentId: root.id);
      final b = server.addFolder(parentId: a.id);
      final c = server.addFolder(parentId: root.id);
      server.addFile(folderId: root.id, size: 10);
      server.addFile(folderId: b.id, size: 20);
      final result = await server.client.drive.deleteFolderRecursive(
        folderId: root.id,
        dryRun: true,
      );
      expect(result.plan.tree.rootNode!.folder.id, root.id);
      expect(result.plan.fileCount, 2);
      expect(result.plan.folderCount, 4);
      expect(result.plan.totalBytes, 30);
      expect(result.plan.foldersDeepestFirst.map((folder) => folder.id), [
        b.id,
        c.id,
        a.id,
        root.id,
      ]);
      expect(result.files.items, isEmpty);
      expect(result.folders.items, isEmpty);
      expect(result.dryRun, isTrue);
      expect(result.rootDeleted, isFalse);
      expect(result.isComplete, isFalse);
      expect(deletes(), isEmpty);
      expect(() => result.plan.filesByFolder.clear(), throwsUnsupportedError);
      expect(
        () => result.plan.filesByFolder[root.id]!.clear(),
        throwsUnsupportedError,
      );
      expect(() => result.plan.files.clear(), throwsUnsupportedError);
      expect(
        () => result.plan.foldersDeepestFirst.clear(),
        throwsUnsupportedError,
      );
    },
  );

  test(
    'deletes files before folders, children before parents, reports progress',
    () async {
      final root = server.addFolder();
      final a = server.addFolder(parentId: root.id);
      final b = server.addFolder(parentId: a.id);
      for (final folder in [root, a, b]) {
        server.addFile(folderId: folder.id);
        server.addFile(folderId: folder.id);
      }
      final progress = <DriveRecursiveDeleteProgress>[];
      final result = await server.client.drive.deleteFolderRecursive(
        folderId: root.id,
        concurrency: 2,
        onProgress: progress.add,
      );
      expect(result.isComplete, isTrue);
      expect(result.rootDeleted, isTrue);
      expect(server.files, isEmpty);
      expect(server.folders, isEmpty);
      expect(
        deletes().take(6).every((r) => r.path == '/drive/files/delete'),
        isTrue,
      );
      expect(deletes().skip(6).map((r) => r.jsonBody!['folderId']), [
        b.id,
        a.id,
        root.id,
      ]);
      expect(result.folders.items.map((item) => item.index), [0, 1, 2]);
      expect(server.adapter.maxInFlight, lessThanOrEqualTo(2));
      for (final phase in DriveRecursiveDeletePhase.values) {
        final snapshots = progress.where((p) => p.phase == phase).toList();
        expect(snapshots.first.completed, 0);
        expect(snapshots.last.completed, snapshots.last.total);
        expect(
          snapshots.map((p) => p.completed),
          orderedEquals(List.generate(snapshots.last.total + 1, (i) => i)),
        );
        expect(snapshots.every((p) => p.failed == 0), isTrue);
      }
    },
  );

  test(
    'failed file blocks its folder and ancestors but not a sibling',
    () async {
      final root = server.addFolder();
      final a = server.addFolder(parentId: root.id);
      final b = server.addFolder(parentId: a.id);
      final c = server.addFolder(parentId: root.id);
      final file = server.addFile(folderId: b.id);
      server.failWhen(
        '/drive/files/delete',
        (r) => r.jsonBody!['fileId'] == file.id,
        ScriptedResponse.error(400, code: 'DENIED'),
      );
      final progress = <DriveRecursiveDeleteProgress>[];
      final result = await server.client.drive.deleteFolderRecursive(
        folderId: root.id,
        onProgress: progress.add,
      );
      expect(result.files.failures, hasLength(1));
      expect(result.folders.successes.single.input.id, c.id);
      expect(result.folders.skipped.map((i) => i.input.id), [
        b.id,
        a.id,
        root.id,
      ]);
      expect(
        result.folders.skipped.every(
          (i) => i.reason == MisskeyBatchSkipReason.dependencyFailed,
        ),
        isTrue,
      );
      expect(
        deletes()
            .where((r) => r.path == '/drive/folders/delete')
            .map((r) => r.jsonBody!['folderId']),
        [c.id],
      );
      expect(result.isComplete, isFalse);
      expect(
        progress
            .where((p) => p.phase == DriveRecursiveDeletePhase.deletingFiles)
            .last
            .failed,
        1,
      );
      expect(progress.last.completed, 4);
      expect(progress.last.failed, 0);
    },
  );

  test('already absent file and folder count as successes', () async {
    final root = server.addFolder();
    server.addFile(folderId: root.id);
    server.failWhen(
      '/drive/files/delete',
      (_) => true,
      ScriptedResponse.error(400, code: 'NO_SUCH_FILE'),
    );
    server.failWhen(
      '/drive/folders/delete',
      (_) => true,
      ScriptedResponse.error(400, code: 'NO_SUCH_FOLDER'),
    );
    final result = await server.client.drive.deleteFolderRecursive(
      folderId: root.id,
    );
    expect(result.isComplete, isTrue);
    expect(result.files.successes, hasLength(1));
    expect(result.folders.successes, hasLength(1));
  });

  test(
    'file rate limit stops remaining files and all folders with cause',
    () async {
      final root = server.addFolder();
      final empty = server.addFolder(parentId: root.id);
      for (var i = 0; i < 3; i++) {
        server.addFile(folderId: root.id);
      }
      server.failWhen(
        '/drive/files/delete',
        (_) => true,
        ScriptedResponse.error(
          429,
          code: 'RATE_LIMIT_EXCEEDED',
          retryAfter: '7',
        ),
      );
      final result = await server.client.drive.deleteFolderRecursive(
        folderId: root.id,
        concurrency: 1,
      );
      expect(result.files.failures, hasLength(1));
      expect(result.files.skipped, hasLength(2));
      for (final item in result.files.skipped) {
        expect(item.reason, MisskeyBatchSkipReason.rateLimited);
        expect(
          (item.cause! as MisskeyRateLimitException).retryAfter,
          const Duration(seconds: 7),
        );
      }
      final child = result.folders.skipped.first;
      expect(child.input.id, empty.id);
      expect(child.reason, MisskeyBatchSkipReason.rateLimited);
      expect(child.cause, same(result.files.failures.single.error));
      expect(
        result.folders.skipped.last.reason,
        MisskeyBatchSkipReason.dependencyFailed,
      );
      expect(deletes(), hasLength(1));
    },
  );

  test(
    'folder rate limit propagates across levels, ancestors are blocked',
    () async {
      final root = server.addFolder();
      final a = server.addFolder(parentId: root.id);
      server.addFolder(parentId: a.id);
      server.addFolder(parentId: root.id);
      server.failWhen(
        '/drive/folders/delete',
        (_) => true,
        ScriptedResponse.error(429, code: 'RATE_LIMIT_EXCEEDED'),
      );
      final result = await server.client.drive.deleteFolderRecursive(
        folderId: root.id,
        concurrency: 1,
      );
      expect(result.folders.failures, hasLength(1));
      expect(result.folders.skipped.map((i) => i.reason), [
        MisskeyBatchSkipReason.rateLimited,
        MisskeyBatchSkipReason.dependencyFailed,
        MisskeyBatchSkipReason.dependencyFailed,
      ]);
      expect(deletes(), hasLength(1));
    },
  );

  test('cancellation during files skips remaining work', () async {
    final root = server.addFolder();
    server.addFolder(parentId: root.id);
    for (var i = 0; i < 3; i++) {
      server.addFile(folderId: root.id);
    }
    final cancellation = MisskeyCancellationToken();
    final result = await server.client.drive.deleteFolderRecursive(
      folderId: root.id,
      concurrency: 1,
      cancellation: cancellation,
      onProgress: (p) {
        if (p.phase == DriveRecursiveDeletePhase.deletingFiles &&
            p.completed == 1) {
          cancellation.cancel();
        }
      },
    );
    expect(result.files.successes, hasLength(1));
    expect(result.files.skipped, hasLength(2));
    expect(
      result.files.skipped.every(
        (i) => i.reason == MisskeyBatchSkipReason.cancelled,
      ),
      isTrue,
    );
    expect(
      result.folders.skipped.first.reason,
      MisskeyBatchSkipReason.cancelled,
    );
    expect(
      result.folders.skipped.last.reason,
      MisskeyBatchSkipReason.dependencyFailed,
    );
    expect(deletes(), hasLength(1));
  });

  for (final path in ['/drive/folders', '/drive/files']) {
    test('planning failure at $path deletes nothing', () async {
      final root = server.addFolder();
      server.addFile(folderId: root.id);
      server.failWhen(
        path,
        (_) => true,
        ScriptedResponse.error(400, code: 'DENIED'),
      );
      await expectLater(
        server.client.drive.deleteFolderRecursive(folderId: root.id),
        throwsA(isA<MisskeyApiException>()),
      );
      expect(deletes(), isEmpty);
    });
  }

  for (final lag in [2, 20]) {
    test('bounded HAS_CHILD retry with deletion lag $lag', () async {
      final root = server.addFolder();
      server.addFile(folderId: root.id);
      server.fileDeletionLagRequests = lag;
      final delays = <Duration>[];
      final result = await deleteDriveFolderRecursive(
        files: server.client.drive.files,
        folders: server.client.drive.folders,
        folderId: root.id,
        delay: (duration) async {
          delays.add(duration);
        },
      );
      expect(result.files.isComplete, isTrue);
      expect(result.isComplete, lag == 2);
      expect(
        delays.map((d) => d.inMilliseconds),
        lag == 2 ? [200, 400] : [200, 400, 800, 1600],
      );
      expect(
        deletes().where((r) => r.path == '/drive/folders/delete'),
        hasLength(lag == 2 ? 3 : 5),
      );
      if (lag == 2) {
        expect(server.files, isEmpty);
        expect(server.folders, isEmpty);
      } else {
        expect(
          (result.folders.failures.single.error as MisskeyApiException).code,
          'HAS_CHILD_FILES_OR_FOLDERS',
        );
      }
    });
  }

  test('cancellation during backoff does not issue a retry', () async {
    final root = server.addFolder();
    server.addFile(folderId: root.id);
    server.fileDeletionLagRequests = 20;
    final cancellation = MisskeyCancellationToken();
    final result = await deleteDriveFolderRecursive(
      files: server.client.drive.files,
      folders: server.client.drive.folders,
      folderId: root.id,
      cancellation: cancellation,
      delay: (_) {
        cancellation.cancel();
        return Completer<void>().future;
      },
    );
    expect(
      (result.folders.failures.single.error as MisskeyApiException).code,
      'HAS_CHILD_FILES_OR_FOLDERS',
    );
    expect(deletes(), hasLength(2));
  });

  test(
    'bounded concurrent file requests drain before folder deletion',
    () async {
      final root = server.addFolder();
      for (var i = 0; i < 5; i++) {
        server.addFile(folderId: root.id);
      }
      final gate = Completer<void>();
      for (var i = 0; i < 2; i++) {
        server.adapter.enqueue(
          '/drive/files/delete',
          ScriptedResponse.gated(
            gate.future,
            ScriptedResponse.error(400, code: 'DENIED'),
          ),
        );
      }
      final future = server.client.drive.deleteFolderRecursive(
        folderId: root.id,
        concurrency: 2,
      );
      await waitUntil(() => deletes().length >= 2);
      expect(deletes(), hasLength(2));
      expect(server.adapter.inFlight, 2);
      gate.complete();
      final result = await future;
      expect(server.adapter.maxInFlight, 2);
      expect(result.files.failures, hasLength(2));
      expect(result.files.successes, hasLength(3));
      expect(
        result.folders.skipped.single.reason,
        MisskeyBatchSkipReason.dependencyFailed,
      );
    },
  );

  test('real deletion preserves root files and sibling subtrees', () async {
    final outsideFile = server.addFile();
    final sibling = server.addFolder();
    final siblingChild = server.addFolder(parentId: sibling.id);
    final siblingFile = server.addFile(folderId: siblingChild.id);
    final root = server.addFolder();
    final child = server.addFolder(parentId: root.id);
    server.addFile(folderId: root.id);
    server.addFile(folderId: child.id);
    final result = await server.client.drive.deleteFolderRecursive(
      folderId: root.id,
    );
    expect(result.isComplete, isTrue);
    expect(server.files.map((f) => f.id), [outsideFile.id, siblingFile.id]);
    expect(server.folders.map((f) => f.id), [sibling.id, siblingChild.id]);
  });

  test(
    'planning cancellation stops listings and skips every planned item',
    () async {
      final root = server.addFolder();
      server.addFolder(parentId: root.id);
      server.addFolder(parentId: root.id);
      server.addFile(folderId: root.id);
      final cancellation = MisskeyCancellationToken();
      final result = await server.client.drive.deleteFolderRecursive(
        folderId: root.id,
        concurrency: 1,
        cancellation: cancellation,
        onProgress: (p) {
          if (p.phase == DriveRecursiveDeletePhase.planning &&
              p.completed == 1) {
            cancellation.cancel();
          }
        },
      );
      expect(deletes(), isEmpty);
      expect(
        server.adapter.paths.where((p) => p == '/drive/files'),
        hasLength(1),
      );
      expect(result.plan.filesByFolder.keys, [root.id]);
      expect(result.files.skipped, hasLength(1));
      expect(result.folders.skipped, hasLength(3));
      expect(
        result.files.skipped.every(
          (i) => i.reason == MisskeyBatchSkipReason.cancelled,
        ),
        isTrue,
      );
      expect(
        result.folders.skipped.every(
          (i) => i.reason == MisskeyBatchSkipReason.cancelled,
        ),
        isTrue,
      );
    },
  );

  for (final phase in [
    DriveRecursiveDeletePhase.deletingFiles,
    DriveRecursiveDeletePhase.deletingFolders,
  ]) {
    test(
      'throwing progress in $phase drains workers and prevents later work',
      () async {
        final root = server.addFolder();
        final isFiles = phase == DriveRecursiveDeletePhase.deletingFiles;
        for (var i = 0; i < 3; i++) {
          if (isFiles) {
            server.addFile(folderId: root.id);
          } else {
            server.addFolder(parentId: root.id);
          }
        }
        final path = isFiles ? '/drive/files/delete' : '/drive/folders/delete';
        final gate = Completer<void>();
        server.adapter.enqueue(path, ScriptedResponse.noContent());
        server.adapter.enqueue(
          path,
          ScriptedResponse.gated(gate.future, ScriptedResponse.noContent()),
        );
        final error = StateError('progress');
        var threw = false;
        var settled = false;
        final future = server.client.drive.deleteFolderRecursive(
          folderId: root.id,
          concurrency: 2,
          onProgress: (p) {
            if (p.phase == phase && p.completed == 1) {
              threw = true;
              throw error;
            }
          },
        );
        final assertion = expectLater(future, throwsA(same(error))).then((_) {
          settled = true;
        });
        await waitUntil(() => threw);
        expect(settled, isFalse);
        expect(server.adapter.inFlight, 1);
        expect(deletes(), hasLength(2));
        gate.complete();
        await assertion;
        expect(server.adapter.inFlight, 0);
        expect(deletes(), hasLength(2));
        expect(deletes().every((r) => r.path == path), isTrue);
        if (!isFiles) {
          expect(
            deletes().every((r) => r.jsonBody!['folderId'] != root.id),
            isTrue,
          );
        }
      },
    );
  }

  test(
    'another worker rate limits during backoff and preserves attempted failure',
    () async {
      final root = server.addFolder();
      final rateLimited = server.addFolder(parentId: root.id);
      final retrying = server.addFolder(parentId: root.id);
      final releaseRateLimit = Completer<void>();
      server.failWhen(
        '/drive/folders/delete',
        (r) => r.jsonBody!['folderId'] == retrying.id,
        ScriptedResponse.error(400, code: 'HAS_CHILD_FILES_OR_FOLDERS'),
      );
      server.failWhen(
        '/drive/folders/delete',
        (r) => r.jsonBody!['folderId'] == rateLimited.id,
        ScriptedResponse.gated(
          releaseRateLimit.future,
          ScriptedResponse.error(429, code: 'RATE_LIMIT_EXCEEDED'),
        ),
      );
      final result = await deleteDriveFolderRecursive(
        files: server.client.drive.files,
        folders: server.client.drive.folders,
        folderId: root.id,
        concurrency: 2,
        delay: (_) {
          releaseRateLimit.complete();
          return Completer<void>().future;
        },
      );
      expect(deletes(), hasLength(2));
      expect(result.folders.failures, hasLength(2));
      expect(
        (result.folders.failures.first.error as MisskeyApiException).code,
        'HAS_CHILD_FILES_OR_FOLDERS',
      );
      expect(
        result.folders.failures.last.error,
        isA<MisskeyRateLimitException>(),
      );
      expect(
        result.folders.skipped.single.reason,
        MisskeyBatchSkipReason.dependencyFailed,
      );
    },
  );

  test('plan rejects file map keys outside the tree', () async {
    final root = server.addFolder();
    final tree = await server.client.drive.folders.getTree(
      rootFolderId: root.id,
    );
    expect(
      () =>
          DriveRecursiveDeletePlan(tree: tree, filesByFolder: {'outside': []}),
      throwsA(isA<AssertionError>()),
    );
  });

  test('invalid concurrency fails synchronously with zero requests', () {
    for (final concurrency in [0, -1]) {
      expect(
        () => server.client.drive.deleteFolderRecursive(
          folderId: 'root',
          concurrency: concurrency,
        ),
        throwsArgumentError,
      );
    }
    expect(server.adapter.requests, isEmpty);
  });
}

Future<void> waitUntil(bool Function() condition) async {
  for (var attempt = 0; attempt < 1000; attempt++) {
    if (condition()) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('Condition was not reached within 1000 event-loop turns');
}
