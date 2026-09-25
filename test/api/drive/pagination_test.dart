import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../../support/drive_fixtures.dart';
import '../../support/fake_drive_server.dart';
import '../../support/scripted_http_adapter.dart';

void main() {
  late FakeDriveServer server;
  setUp(() => server = FakeDriveServer());
  tearDown(() => server.client.dispose());

  test('files listAll filters root versus folder and forwards type', () async {
    final folder = server.addFolder();
    final rootImage = server.addFile();
    server.addFile(type: 'text/plain');
    final childImage = server.addFile(folderId: folder.id);
    server.addFile(folderId: folder.id, type: 'text/plain');
    expect(
      (await server.client.drive.files.listAll(type: 'image/*').toList()).map(
        (file) => file.id,
      ),
      [rootImage.id],
    );
    expect(
      (await server.client.drive.files
              .listAll(folderId: folder.id, type: 'image/*')
              .toList())
          .map((file) => file.id),
      [childImage.id],
    );
    expect(server.adapter.requests.first.jsonBody, {
      'i': 'test-token',
      'limit': 100,
      'type': 'image/*',
    });
    expect(server.adapter.requests.last.jsonBody?['folderId'], folder.id);
    expect(server.adapter.requests.last.jsonBody?['type'], 'image/*');
  });

  test('folders listAll filters root versus parent folder', () async {
    final root = server.addFolder();
    final child = server.addFolder(parentId: root.id);
    expect(
      (await server.client.drive.folders.listAll().toList()).map(
        (folder) => folder.id,
      ),
      [root.id],
    );
    expect(
      (await server.client.drive.folders.listAll(folderId: root.id).toList())
          .map((folder) => folder.id),
      [child.id],
    );
    expect(server.adapter.requests.last.jsonBody?['folderId'], root.id);
  });

  test('streamAll includes all folders and forwards type', () async {
    final folder = server.addFolder();
    final root = server.addFile();
    final child = server.addFile(folderId: folder.id);
    server.addFile(type: 'text/plain');
    expect(
      (await server.client.drive.streamAll(type: 'image/*').toList()).map(
        (file) => file.id,
      ),
      [child.id, root.id],
    );
    expect(server.adapter.requests.single.jsonBody?['type'], 'image/*');
    expect(
      server.adapter.requests.single.jsonBody!.containsKey('folderId'),
      isFalse,
    );
  });

  for (final kind in ['files', 'folders', 'stream']) {
    Stream<String> list({int pageSize = 100, int? maxItems}) => switch (kind) {
      'files' =>
        server.client.drive.files
            .listAll(pageSize: pageSize, maxItems: maxItems)
            .map((item) => item.id),
      'folders' =>
        server.client.drive.folders
            .listAll(pageSize: pageSize, maxItems: maxItems)
            .map((item) => item.id),
      _ =>
        server.client.drive
            .streamAll(pageSize: pageSize, maxItems: maxItems)
            .map((item) => item.id),
    };

    test('$kind retrieves 250 items in three newest-first pages', () async {
      for (var i = 0; i < 250; i++) {
        if (kind == 'folders') {
          server.addFolder();
        } else {
          server.addFile();
        }
      }
      expect(await list().toList(), [for (var i = 250; i > 0; i--) idAt(i)]);
      expect(server.adapter.requests, hasLength(3));
      expect(
        server.adapter.requests.map((request) => request.jsonBody?['limit']),
        [100, 100, 100],
      );
      expect(
        server.adapter.requests.map((request) => request.jsonBody?['untilId']),
        [null, idAt(151), idAt(51)],
      );
    });

    test(
      '$kind validates synchronously and maxItems zero sends nothing',
      () async {
        for (final size in [0, -1, 101]) {
          expect(() => list(pageSize: size), throwsArgumentError);
        }
        expect(() => list(maxItems: -1), throwsArgumentError);
        expect(await list(maxItems: 0).toList(), isEmpty);
        expect(server.adapter.requests, isEmpty);
      },
    );

    test(
      '$kind is cold and single-subscription with independent calls',
      () async {
        final stream = list();
        expect(server.adapter.requests, isEmpty);
        await stream.toList();
        expect(() => stream.listen((_) {}), throwsStateError);
        await list().toList();
        expect(server.adapter.requests, hasLength(2));
      },
    );
  }

  test('API errors arrive after already-yielded items', () async {
    server.addFile();
    server.addFile();
    server.failWhen(
      '/drive/files',
      (request) => request.jsonBody?['untilId'] != null,
      ScriptedResponse.error(400, code: 'TEST_ERROR'),
    );
    await expectLater(
      server.client.drive.files.listAll(pageSize: 2).map((file) => file.id),
      emitsInOrder([
        idAt(2),
        idAt(1),
        emitsError(isA<MisskeyApiException>()),
        emitsDone,
      ]),
    );
    expect(server.adapter.requests, hasLength(2));
  });
}
