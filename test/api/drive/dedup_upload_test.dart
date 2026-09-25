import 'package:crypto/crypto.dart' as crypto;
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../../support/drive_fixtures.dart';
import '../../support/fake_drive_server.dart';
import '../../support/scripted_http_adapter.dart';

const _hello = <int>[104, 101, 108, 108, 111];
const _helloMd5 = '5d41402abc4b2a76b9719d911017c592';

void main() {
  group('DriveFilesApi.createDeduplicated', () {
    test('sends the MD5 hash to find-by-hash before uploading', () async {
      final server = _server();
      addTearDown(server.client.dispose);

      await server.client.drive.files.createDeduplicated(
        bytes: _hello,
        filename: 'hello.txt',
      );

      expect(server.adapter.paths, [
        '/drive/files/find-by-hash',
        '/drive/files/create',
      ]);
      expect(
        server.adapter.requests.first.jsonBody,
        containsPair('md5', _helloMd5),
      );
      expect(server.adapter.requests.last.formFields['force'], 'false');
    });

    test('reuses a match in the requested folder without a mutation', () async {
      final server = _server();
      final folder = server.addFolder();
      final existing = server.addFile(folderId: folder.id, md5: _helloMd5);
      addTearDown(server.client.dispose);

      final result = await server.client.drive.files.createDeduplicated(
        bytes: _hello,
        filename: 'hello.txt',
        folderId: folder.id,
      );

      expect(result.file.id, existing.id);
      expect(result.outcome, DriveUploadOutcome.reusedExisting);
      expect(server.adapter.paths, ['/drive/files/find-by-hash']);
    });

    test('does not move a match elsewhere when reusing it', () async {
      final server = _server();
      final source = server.addFolder();
      final target = server.addFolder();
      final existing = server.addFile(folderId: source.id, md5: _helloMd5);
      addTearDown(server.client.dispose);

      final result = await server.client.drive.files.createDeduplicated(
        bytes: _hello,
        filename: 'hello.txt',
        folderId: target.id,
      );

      expect(result.file.id, existing.id);
      expect(result.outcome, DriveUploadOutcome.reusedExisting);
      expect(server.adapter.paths, ['/drive/files/find-by-hash']);
      expect(existing.folderId, source.id);
    });

    test('moves a matching file to the requested folder', () async {
      final server = _server();
      final source = server.addFolder();
      final target = server.addFolder();
      final existing = server.addFile(folderId: source.id, md5: _helloMd5);
      addTearDown(server.client.dispose);

      final result = await server.client.drive.files.createDeduplicated(
        bytes: _hello,
        filename: 'hello.txt',
        folderId: target.id,
        onDuplicate: DriveDuplicatePolicy.moveExisting,
      );

      expect(result.file.id, existing.id);
      expect(result.outcome, DriveUploadOutcome.movedExisting);
      expect(
        server.adapter.requests.last.jsonBody,
        allOf(
          containsPair('fileId', existing.id),
          containsPair('folderId', target.id),
        ),
      );
    });

    test(
      'moves a matching file to root with an explicit null folder ID',
      () async {
        final server = _server();
        final source = server.addFolder();
        final existing = server.addFile(folderId: source.id, md5: _helloMd5);
        addTearDown(server.client.dispose);

        await server.client.drive.files.createDeduplicated(
          bytes: _hello,
          filename: 'hello.txt',
          onDuplicate: DriveDuplicatePolicy.moveExisting,
        );

        expect(
          server.adapter.requests.last.jsonBody,
          allOf(
            containsPair('fileId', existing.id),
            containsPair('folderId', isNull),
          ),
        );
      },
    );

    test('uploads anyway without a hash lookup', () async {
      final server = _server();
      server.addFile(md5: _helloMd5);
      addTearDown(server.client.dispose);

      final result = await server.client.drive.files.createDeduplicated(
        bytes: _hello,
        filename: 'hello.txt',
        onDuplicate: DriveDuplicatePolicy.uploadAnyway,
      );

      expect(result.outcome, DriveUploadOutcome.uploaded);
      expect(result.existingMatches, isEmpty);
      expect(server.adapter.paths, ['/drive/files/create']);
      expect(server.adapter.requests.single.formFields['force'], 'true');
    });

    test(
      'prefers a match in the requested folder, then the oldest match',
      () async {
        final server = _server();
        final source = server.addFolder();
        final requested = server.addFolder();
        final other = server.addFolder();
        final oldest = server.addFile(folderId: source.id, md5: _helloMd5);
        final inRequested = server.addFile(
          folderId: requested.id,
          md5: _helloMd5,
        );
        server.addFile(folderId: other.id, md5: _helloMd5);
        addTearDown(server.client.dispose);

        final requestedResult = await server.client.drive.files
            .createDeduplicated(
              bytes: _hello,
              filename: 'hello.txt',
              folderId: requested.id,
            );
        final unmatchedResult = await server.client.drive.files
            .createDeduplicated(
              bytes: _hello,
              filename: 'hello.txt',
              folderId: 'another-folder',
            );

        expect(requestedResult.file.id, inRequested.id);
        expect(unmatchedResult.file.id, oldest.id);
        expect(requestedResult.existingMatches, hasLength(3));
        expect(
          () => requestedResult.existingMatches.add(
            requestedResult.existingMatches.first,
          ),
          throwsUnsupportedError,
        );
      },
    );

    test('upgrades an existing file to sensitive when requested', () async {
      final server = _server();
      final existing = server.addFile(md5: _helloMd5);
      addTearDown(server.client.dispose);

      final result = await server.client.drive.files.createDeduplicated(
        bytes: _hello,
        filename: 'hello.txt',
        isSensitive: true,
      );

      expect(result.file.isSensitive, isTrue);
      expect(result.outcome, DriveUploadOutcome.reusedExisting);
      expect(
        server.adapter.requests.last.jsonBody,
        allOf(
          containsPair('fileId', existing.id),
          containsPair('isSensitive', true),
        ),
      );
    });

    test('normalizes and uses a supplied MD5', () async {
      final server = _server();
      addTearDown(server.client.dispose);

      final result = await server.client.drive.files.createDeduplicated(
        bytes: const [0],
        filename: 'ignored.bin',
        md5: _helloMd5.toUpperCase(),
      );

      expect(result.md5, _helloMd5);
      expect(
        server.adapter.requests.first.jsonBody,
        containsPair('md5', _helloMd5),
      );
    });

    test('rejects an invalid supplied MD5 before sending requests', () async {
      final server = _server();
      addTearDown(server.client.dispose);

      await expectLater(
        server.client.drive.files.createDeduplicated(
          bytes: _hello,
          filename: 'hello.txt',
          md5: 'not-an-md5',
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect(server.adapter.requests, isEmpty);
    });

    test('reports a raced duplicate returned by create as reused', () async {
      final adapter = ScriptedHttpClientAdapter();
      final client = testClient(adapter);
      addTearDown(client.dispose);
      adapter.on('/drive/files/find-by-hash', (_) => ScriptedResponse.json([]));
      adapter.on(
        '/drive/files/create',
        (_) => ScriptedResponse.json(
          driveFileJson(
            id: 'existing-file',
            folderId: 'other-folder',
            md5: _helloMd5,
            createdAt: DateTime.now().subtract(const Duration(seconds: 1)),
          ),
        ),
      );

      final result = await client.drive.files.createDeduplicated(
        bytes: _hello,
        filename: 'hello.txt',
        folderId: 'requested-folder',
      );

      expect(result.outcome, DriveUploadOutcome.reusedExisting);
      expect(result.existingMatches, isEmpty);
    });
  });
}

FakeDriveServer _server() =>
    FakeDriveServer(md5Of: (bytes) => crypto.md5.convert(bytes).toString());
