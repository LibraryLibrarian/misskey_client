import 'dart:async';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../../support/drive_fixtures.dart';
import '../../support/fake_drive_server.dart';
import '../../support/scripted_http_adapter.dart';

void main() {
  late FakeDriveServer server;

  setUp(() => server = FakeDriveServer());
  tearDown(() => server.client.dispose());

  test(
    'builds a three-level tree from the Drive root in server order',
    () async {
      final first = server.addFolder(name: 'first');
      final second = server.addFolder(name: 'second');
      final firstChild = server.addFolder(
        parentId: first.id,
        name: 'first-child',
      );
      final newerFirstChild = server.addFolder(
        parentId: first.id,
        name: 'newer-first-child',
      );
      final grandchild = server.addFolder(
        parentId: newerFirstChild.id,
        name: 'grandchild',
      );

      final tree = await server.client.drive.folders.getTree();

      expect(tree.rootNode, isNull);
      expect(tree.children.map((node) => node.folder.id), [
        second.id,
        first.id,
      ]);
      expect(tree.children.map((node) => node.depth), [1, 1]);
      final firstNode = tree.children.last;
      expect(firstNode.children.map((node) => node.folder.id), [
        newerFirstChild.id,
        firstChild.id,
      ]);
      expect(firstNode.children.map((node) => node.depth), [2, 2]);
      expect(firstNode.children.first.children.single.folder.id, grandchild.id);
      expect(firstNode.children.first.children.single.depth, 3);
      expect(tree.isTruncated, isFalse);
      expect(tree.nodes.map((node) => node.folder.id), [
        second.id,
        first.id,
        newerFirstChild.id,
        grandchild.id,
        firstChild.id,
      ]);
      expect(tree.folderCount, 5);
      expect(
        () => tree.children.add(tree.children.first),
        throwsUnsupportedError,
      );
    },
  );

  test('uses show before listing when rooted at a folder', () async {
    final root = server.addFolder();
    final child = server.addFolder(parentId: root.id);

    final tree = await server.client.drive.folders.getTree(
      rootFolderId: root.id,
    );

    expect(server.adapter.paths.first, '/drive/folders/show');
    expect(
      server.adapter.paths.where((path) => path == '/drive/folders/show'),
      hasLength(1),
    );
    expect(tree.rootNode!.folder.id, root.id);
    expect(tree.rootNode!.depth, 0);
    expect(tree.children.map((node) => node.folder.id), [child.id]);
    expect(tree.children.single.depth, 1);
  });

  test('maxDepth one marks included children as not loaded', () async {
    final root = server.addFolder();
    final child = server.addFolder(parentId: root.id);
    server.addFolder(parentId: child.id);

    final tree = await server.client.drive.folders.getTree(
      rootFolderId: root.id,
      maxDepth: 1,
    );

    expect(tree.rootNode!.childrenLoaded, isTrue);
    expect(tree.children.single.childrenLoaded, isFalse);
    expect(tree.isTruncated, isTrue);
    expect(
      server.adapter.requests.where(
        (request) => request.path == '/drive/folders',
      ),
      hasLength(1),
    );
  });

  test('maxDepth zero does not list the requested root', () async {
    final root = server.addFolder();
    server.addFolder(parentId: root.id);

    final tree = await server.client.drive.folders.getTree(
      rootFolderId: root.id,
      maxDepth: 0,
    );

    expect(tree.rootNode!.children, isEmpty);
    expect(tree.rootNode!.childrenLoaded, isFalse);
    expect(tree.isTruncated, isTrue);
    expect(server.adapter.paths, ['/drive/folders/show']);
  });

  test(
    'maxDepth zero at the Drive root is truncated without requests',
    () async {
      final tree = await server.client.drive.folders.getTree(maxDepth: 0);

      expect(tree.children, isEmpty);
      expect(tree.isTruncated, isTrue);
      expect(server.adapter.requests, isEmpty);
    },
  );

  test('paginates a folder with 101 child folders', () async {
    final root = server.addFolder();
    for (var i = 0; i < 101; i++) {
      server.addFolder(parentId: root.id);
    }

    final tree = await server.client.drive.folders.getTree(
      rootFolderId: root.id,
    );

    final rootRequests = server.adapter.requests
        .where(
          (request) =>
              request.path == '/drive/folders' &&
              request.jsonBody?['folderId'] == root.id,
        )
        .toList();
    expect(rootRequests, hasLength(2));
    expect(rootRequests.map((request) => request.jsonBody?['limit']), [
      100,
      100,
    ]);
    expect(tree.rootNode!.children, hasLength(101));
    expect(tree.folderCount, 102);
  });

  test('limits concurrent folder-list requests', () async {
    final gate = Completer<void>();
    server.addFolder();
    server.addFolder();
    server.addFolder();
    server.failWhen(
      '/drive/folders',
      (request) => request.jsonBody?['folderId'] != null,
      ScriptedResponse.gated(gate.future, ScriptedResponse.json([])),
      times: -1,
    );

    final future = server.client.drive.folders.getTree(concurrency: 2);
    await _waitFor(
      () =>
          server.adapter.requests
              .where((request) => request.jsonBody?['folderId'] != null)
              .length ==
          2,
    );
    expect(server.adapter.maxInFlight, lessThanOrEqualTo(2));
    gate.complete();
    await future;
    expect(server.adapter.maxInFlight, 2);
  });

  test('rethrows a list error', () async {
    final root = server.addFolder();
    server.addFolder();
    server.failWhen(
      '/drive/folders',
      (request) => request.jsonBody?['folderId'] == root.id,
      ScriptedResponse.error(400, code: 'TEST_ERROR'),
    );

    await expectLater(
      server.client.drive.folders.getTree(),
      throwsA(isA<MisskeyApiException>()),
    );
  });

  test('rethrows a missing requested root without listing', () async {
    await expectLater(
      server.client.drive.folders.getTree(rootFolderId: 'missing'),
      throwsA(isA<MisskeyApiException>()),
    );

    expect(server.adapter.paths, ['/drive/folders/show']);
  });

  test('terminates when a child points back to the requested root', () async {
    final adapter = ScriptedHttpClientAdapter();
    final client = testClient(adapter);
    const rootId = 'root';
    adapter.on(
      '/drive/folders/show',
      (_) => ScriptedResponse.json(driveFolderJson(id: rootId)),
    );
    adapter.on(
      '/drive/folders',
      (_) => ScriptedResponse.json([
        driveFolderJson(id: rootId, parentId: rootId),
      ]),
    );
    addTearDown(client.dispose);

    final tree = await client.drive.folders.getTree(rootFolderId: rootId);

    expect(tree.rootNode!.children, isEmpty);
    expect(tree.folderCount, 1);
    expect(adapter.paths, ['/drive/folders/show', '/drive/folders']);
  });

  test('validates arguments before sending requests', () {
    expect(
      () => server.client.drive.folders.getTree(maxDepth: -1),
      throwsArgumentError,
    );
    expect(
      () => server.client.drive.folders.getTree(concurrency: 0),
      throwsArgumentError,
    );
    expect(server.adapter.requests, isEmpty);
  });
}

Future<void> _waitFor(bool Function() condition) async {
  while (!condition()) {
    await Future<void>.delayed(Duration.zero);
  }
}
