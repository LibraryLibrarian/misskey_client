import 'dart:async';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../../support/drive_fixtures.dart';
import '../../support/scripted_http_adapter.dart';

void main() {
  group('DriveFoldersApi path helpers', () {
    test('resolves three segments with chained parent IDs', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..enqueue(
          '/drive/folders/find',
          ScriptedResponse.json([driveFolderJson(id: 'first', name: 'one')]),
        )
        ..enqueue(
          '/drive/folders/find',
          ScriptedResponse.json([
            driveFolderJson(id: 'second', parentId: 'first', name: 'two'),
          ]),
        )
        ..enqueue(
          '/drive/folders/find',
          ScriptedResponse.json([
            driveFolderJson(id: 'third', parentId: 'second', name: 'three'),
          ]),
        );
      final client = testClient(adapter);
      addTearDown(client.dispose);

      final folder = await client.drive.folders.resolvePath([
        'one',
        'two',
        'three',
      ]);

      expect(folder?.id, 'third');
      expect(adapter.paths, [
        '/drive/folders/find',
        '/drive/folders/find',
        '/drive/folders/find',
      ]);
      expect(adapter.requests[0].jsonBody, isNot(contains('parentId')));
      expect(adapter.requests[1].jsonBody?['parentId'], 'first');
      expect(adapter.requests[2].jsonBody?['parentId'], 'second');
    });

    test('uses a path snapshot when the caller mutates segments', () async {
      final firstRequest = Completer<void>();
      final gate = Completer<void>();
      var requestCount = 0;
      final adapter = ScriptedHttpClientAdapter()
        ..on('/drive/folders/find', (_) {
          requestCount++;
          if (requestCount == 1) {
            firstRequest.complete();
            return ScriptedResponse.gated(
              gate.future,
              ScriptedResponse.json([
                driveFolderJson(id: 'first', name: 'one'),
              ]),
            );
          }
          return ScriptedResponse.json([
            driveFolderJson(id: 'second', parentId: 'first', name: 'two'),
          ]);
        });
      final client = testClient(adapter);
      addTearDown(client.dispose);
      final segments = ['one', 'two'];

      final resolution = client.drive.folders.resolvePath(segments);
      await firstRequest.future;
      segments
        ..clear()
        ..add('changed');
      gate.complete();

      final folder = await resolution;

      expect(folder?.id, 'second');
      expect(adapter.requests.map((request) => request.jsonBody?['name']), [
        'one',
        'two',
      ]);
      expect(adapter.requests[1].jsonBody?['parentId'], 'first');
    });

    test('sends a supplied parent ID in the initial find request', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..enqueue(
          '/drive/folders/find',
          ScriptedResponse.json([
            driveFolderJson(id: 'child', parentId: 'p', name: 'child'),
          ]),
        );
      final client = testClient(adapter);
      addTearDown(client.dispose);

      await client.drive.folders.resolvePath(['child'], parentId: 'p');

      expect(adapter.requests.single.jsonBody?['parentId'], 'p');
    });

    test('stops when a middle path segment is missing', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..enqueue(
          '/drive/folders/find',
          ScriptedResponse.json([driveFolderJson(id: 'first', name: 'one')]),
        )
        ..enqueue('/drive/folders/find', ScriptedResponse.json([]));
      final client = testClient(adapter);
      addTearDown(client.dispose);

      final folder = await client.drive.folders.resolvePath([
        'one',
        'missing',
        'three',
      ]);

      expect(folder, isNull);
      expect(adapter.paths, ['/drive/folders/find', '/drive/folders/find']);
    });

    test(
      'reports an ambiguous segment with its candidates and index',
      () async {
        final candidates = [
          driveFolderJson(id: 'first', parentId: 'parent', name: 'duplicate'),
          driveFolderJson(id: 'second', parentId: 'parent', name: 'duplicate'),
        ];
        final adapter = ScriptedHttpClientAdapter()
          ..enqueue(
            '/drive/folders/find',
            ScriptedResponse.json([
              driveFolderJson(id: 'parent', name: 'root'),
            ]),
          )
          ..enqueue('/drive/folders/find', ScriptedResponse.json(candidates));
        final client = testClient(adapter);
        addTearDown(client.dispose);

        try {
          await client.drive.folders.resolvePath(['root', 'duplicate']);
          fail('Expected DriveFolderAmbiguousException');
        } on DriveFolderAmbiguousException catch (error) {
          expect(error.name, 'duplicate');
          expect(error.parentId, 'parent');
          expect(error.segmentIndex, 1);
          expect(error.candidates.map((folder) => folder.id), [
            'first',
            'second',
          ]);
          expect(
            () => error.candidates.add(error.candidates.first),
            throwsUnsupportedError,
          );
        }
      },
    );

    test(
      'uses creation time and ID to select oldest and newest duplicates',
      () async {
        final candidates = [
          driveFolderJson(
            id: 'old-z',
            name: 'duplicate',
            createdAt: DateTime.utc(2025),
          ),
          driveFolderJson(
            id: 'old-a',
            name: 'duplicate',
            createdAt: DateTime.utc(2025),
          ),
          driveFolderJson(
            id: 'new-a',
            name: 'duplicate',
            createdAt: DateTime.utc(2027),
          ),
          driveFolderJson(
            id: 'new-z',
            name: 'duplicate',
            createdAt: DateTime.utc(2027),
          ),
        ];
        final adapter = ScriptedHttpClientAdapter()
          ..enqueue('/drive/folders/find', ScriptedResponse.json(candidates))
          ..enqueue('/drive/folders/find', ScriptedResponse.json(candidates));
        final client = testClient(adapter);
        addTearDown(client.dispose);

        final oldest = await client.drive.folders.resolvePath([
          'duplicate',
        ], onAmbiguous: DriveFolderAmbiguityPolicy.oldest);
        final newest = await client.drive.folders.resolvePath([
          'duplicate',
        ], onAmbiguous: DriveFolderAmbiguityPolicy.newest);

        expect(oldest?.id, 'old-a');
        expect(newest?.id, 'new-z');
      },
    );

    test('omits parentId when resolving from root', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..enqueue(
          '/drive/folders/find',
          ScriptedResponse.json([driveFolderJson(id: 'root', name: 'root')]),
        );
      final client = testClient(adapter);
      addTearDown(client.dispose);

      await client.drive.folders.resolvePath(['root']);

      expect(adapter.requests.single.jsonBody, isNot(contains('parentId')));
    });

    test(
      'getOrCreate returns an existing folder without creating one',
      () async {
        final adapter = ScriptedHttpClientAdapter()
          ..enqueue(
            '/drive/folders/find',
            ScriptedResponse.json([
              driveFolderJson(id: 'existing', name: 'folder'),
            ]),
          );
        final client = testClient(adapter);
        addTearDown(client.dispose);

        final result = await client.drive.folders.getOrCreate(name: 'folder');

        expect(result.folder.id, 'existing');
        expect(result.created, isFalse);
        expect(adapter.paths, ['/drive/folders/find']);
      },
    );

    test(
      'getOrCreate rejects or selects duplicate folders without creating',
      () async {
        final candidates = [
          driveFolderJson(
            id: 'oldest',
            name: 'folder',
            createdAt: DateTime.utc(2025),
          ),
          driveFolderJson(
            id: 'newest',
            name: 'folder',
            createdAt: DateTime.utc(2027),
          ),
        ];
        final adapter = ScriptedHttpClientAdapter()
          ..enqueue('/drive/folders/find', ScriptedResponse.json(candidates))
          ..enqueue('/drive/folders/find', ScriptedResponse.json(candidates));
        final client = testClient(adapter);
        addTearDown(client.dispose);

        await expectLater(
          client.drive.folders.getOrCreate(name: 'folder'),
          throwsA(
            isA<DriveFolderAmbiguousException>().having(
              (error) => error.segmentIndex,
              'segmentIndex',
              0,
            ),
          ),
        );
        final result = await client.drive.folders.getOrCreate(
          name: 'folder',
          onAmbiguous: DriveFolderAmbiguityPolicy.oldest,
        );

        expect(result.folder.id, 'oldest');
        expect(result.created, isFalse);
        expect(adapter.paths, ['/drive/folders/find', '/drive/folders/find']);
        expect(adapter.paths, isNot(contains('/drive/folders/create')));
      },
    );

    test(
      'getOrCreate creates a missing folder under the requested parent',
      () async {
        final adapter = ScriptedHttpClientAdapter()
          ..enqueue('/drive/folders/find', ScriptedResponse.json([]))
          ..enqueue(
            '/drive/folders/create',
            ScriptedResponse.json(
              driveFolderJson(
                id: 'created',
                parentId: 'parent',
                name: 'folder',
              ),
            ),
          );
        final client = testClient(adapter);
        addTearDown(client.dispose);

        final result = await client.drive.folders.getOrCreate(
          name: 'folder',
          parentId: 'parent',
        );

        expect(result.folder.id, 'created');
        expect(result.created, isTrue);
        expect(adapter.paths, ['/drive/folders/find', '/drive/folders/create']);
        expect(adapter.requests[1].jsonBody?['name'], 'folder');
        expect(adapter.requests[1].jsonBody?['parentId'], 'parent');
      },
    );

    test('getOrCreate propagates a create rate limit response', () async {
      final adapter = ScriptedHttpClientAdapter()
        ..enqueue('/drive/folders/find', ScriptedResponse.json([]))
        ..enqueue(
          '/drive/folders/create',
          ScriptedResponse.error(429, code: 'RATE_LIMITED'),
        );
      final client = testClient(adapter);
      addTearDown(client.dispose);

      await expectLater(
        client.drive.folders.getOrCreate(name: 'folder'),
        throwsA(isA<MisskeyRateLimitException>()),
      );
    });

    test('rejects invalid paths and names without sending requests', () async {
      final adapter = ScriptedHttpClientAdapter();
      final client = testClient(adapter);
      addTearDown(client.dispose);
      final tooLong = List.filled(201, '😀').join();

      await expectLater(
        client.drive.folders.resolvePath([]),
        throwsArgumentError,
      );
      await expectLater(
        client.drive.folders.resolvePath(['folder', '']),
        throwsArgumentError,
      );
      await expectLater(
        client.drive.folders.resolvePath([tooLong]),
        throwsArgumentError,
      );
      await expectLater(
        client.drive.folders.getOrCreate(name: ''),
        throwsArgumentError,
      );
      await expectLater(
        client.drive.folders.getOrCreate(name: tooLong),
        throwsArgumentError,
      );

      expect(adapter.requests, isEmpty);
    });
  });
}
