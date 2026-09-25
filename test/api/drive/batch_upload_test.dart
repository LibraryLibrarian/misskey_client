import 'dart:async';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../../support/drive_fixtures.dart';
import '../../support/fake_drive_server.dart';
import '../../support/scripted_http_adapter.dart';

void main() {
  group('DriveFilesApi.createMany', () {
    test('preserves input order and bounds concurrent requests', () async {
      final server = _server();
      addTearDown(server.client.dispose);
      final first = Completer<void>();
      final second = Completer<void>();
      final third = Completer<void>();
      server.adapter.enqueue(
        '/drive/files/create',
        ScriptedResponse.gated(
          first.future,
          ScriptedResponse.json(_file('one')),
        ),
      );
      server.adapter.enqueue(
        '/drive/files/create',
        ScriptedResponse.gated(
          second.future,
          ScriptedResponse.json(_file('two')),
        ),
      );
      server.adapter.enqueue(
        '/drive/files/create',
        ScriptedResponse.gated(
          third.future,
          ScriptedResponse.json(_file('three')),
        ),
      );

      final future = server.client.drive.files.createMany(
        _inputs(3),
        concurrency: 2,
      );
      await _until(() => server.adapter.inFlight == 2);
      expect(server.adapter.maxInFlight, lessThanOrEqualTo(2));
      first.complete();
      await _until(() => server.adapter.requests.length == 3);
      second.complete();
      third.complete();

      final result = await future;
      expect(result.items.map((item) => item.input.filename), [
        'file-0.txt',
        'file-1.txt',
        'file-2.txt',
      ]);
      expect(server.adapter.maxInFlight, lessThanOrEqualTo(2));
    });

    test('continues after an item failure by default', () async {
      final server = _server();
      addTearDown(server.client.dispose);
      server.failWhen(
        '/drive/files/create',
        (request) => request.formFileNames.single == 'file-1.txt',
        ScriptedResponse.error(400, code: 'INVALID_PARAM'),
      );

      final result = await server.client.drive.files.createMany(_inputs(3));

      expect(result.items[0], isA<MisskeyBatchSuccess>());
      expect(result.items[1], isA<MisskeyBatchFailure>());
      expect(result.items[2], isA<MisskeyBatchSuccess>());
    });

    test('stops remaining inputs after an error when requested', () async {
      final server = _server();
      addTearDown(server.client.dispose);
      server.failWhen(
        '/drive/files/create',
        (request) => request.formFileNames.single == 'file-0.txt',
        ScriptedResponse.error(400, code: 'INVALID_PARAM'),
      );

      final result = await server.client.drive.files.createMany(
        _inputs(3),
        concurrency: 1,
        stopOnError: true,
      );

      expect(result.items[0], isA<MisskeyBatchFailure>());
      expect(
        _skipReason(result.items[1]),
        MisskeyBatchSkipReason.stoppedAfterError,
      );
      expect(
        _skipReason(result.items[2]),
        MisskeyBatchSkipReason.stoppedAfterError,
      );
      expect(
        server.adapter.paths.where((path) => path == '/drive/files/create'),
        hasLength(1),
      );
    });

    test(
      'rate limiting skips pending items while in-flight uploads complete',
      () async {
        final server = _server();
        addTearDown(server.client.dispose);
        final limited = Completer<void>();
        final inFlight = Completer<void>();
        server.adapter.enqueue(
          '/drive/files/create',
          ScriptedResponse.gated(
            limited.future,
            ScriptedResponse.error(429, code: 'RATE_LIMITED'),
          ),
        );
        server.adapter.enqueue(
          '/drive/files/create',
          ScriptedResponse.gated(
            inFlight.future,
            ScriptedResponse.json(_file('in-flight')),
          ),
        );

        final future = server.client.drive.files.createMany(
          _inputs(4),
          concurrency: 2,
        );
        await _until(() => server.adapter.inFlight == 2);
        limited.complete();
        await _until(() => server.adapter.requests.length == 2);
        inFlight.complete();
        final result = await future;

        expect(result.items[0], isA<MisskeyBatchFailure>());
        expect(result.items[1], isA<MisskeyBatchSuccess>());
        expect(
          _skipReason(result.items[2]),
          MisskeyBatchSkipReason.rateLimited,
        );
        expect(
          _skipReason(result.items[3]),
          MisskeyBatchSkipReason.rateLimited,
        );
        expect((result.items[2] as MisskeyBatchSkipped).cause, isNotNull);
      },
    );

    test(
      'cancellation lets in-flight work finish and skips the rest',
      () async {
        final server = _server();
        addTearDown(server.client.dispose);
        final gate = Completer<void>();
        final cancellation = MisskeyCancellationToken();
        server.adapter.enqueue(
          '/drive/files/create',
          ScriptedResponse.gated(
            gate.future,
            ScriptedResponse.json(_file('one')),
          ),
        );

        final future = server.client.drive.files.createMany(
          _inputs(3),
          concurrency: 1,
          cancellation: cancellation,
        );
        await _until(() => server.adapter.inFlight == 1);
        cancellation.cancel();
        gate.complete();
        final result = await future;

        expect(result.items[0], isA<MisskeyBatchSuccess>());
        expect(_skipReason(result.items[1]), MisskeyBatchSkipReason.cancelled);
        expect(_skipReason(result.items[2]), MisskeyBatchSkipReason.cancelled);
      },
    );

    test('reports monotonic progress with Dio per-item values', () async {
      final server = _server();
      addTearDown(server.client.dispose);
      final progress = <DriveBatchUploadProgress>[];

      final result = await server.client.drive.files.createMany(
        _inputs(2),
        onProgress: progress.add,
      );

      expect(result.items, hasLength(2));
      expect(progress, isNotEmpty);
      for (var index = 1; index < progress.length; index++) {
        expect(
          progress[index].completedItems,
          greaterThanOrEqualTo(progress[index - 1].completedItems),
        );
        expect(
          progress[index].succeededItems,
          greaterThanOrEqualTo(progress[index - 1].succeededItems),
        );
        expect(
          progress[index].failedItems,
          greaterThanOrEqualTo(progress[index - 1].failedItems),
        );
      }
      expect(progress.last.completedItems, 2);
      expect(progress.last.totalItems, 2);
      expect(progress.last.sent, progress.last.total);
      for (var itemIndex = 0; itemIndex < 2; itemIndex++) {
        final itemProgress = progress
            .where((event) => event.itemIndex == itemIndex)
            .toList();
        final multipartTotal = itemProgress
            .map((event) => event.total)
            .reduce((previous, value) => previous > value ? previous : value);
        final completion = itemProgress.lastWhere(
          (event) => event.sent == event.total,
        );
        expect(multipartTotal, greaterThan(_inputs(2)[itemIndex].bytes.length));
        expect(completion.total, multipartTotal);
      }
    });

    test('does not retry a rate-limited batch hash lookup', () async {
      final server = _server();
      addTearDown(server.client.dispose);
      server.adapter.enqueue(
        '/drive/files/find-by-hash',
        ScriptedResponse.error(429, code: 'RATE_LIMITED'),
      );
      server.adapter.enqueue(
        '/drive/files/find-by-hash',
        ScriptedResponse.json(const []),
      );

      final result = await server.client.drive.files.createMany(
        _inputs(2),
        concurrency: 1,
        deduplicate: DriveDuplicatePolicy.reuseExisting,
      );

      expect(
        server.adapter.paths.where(
          (path) => path == '/drive/files/find-by-hash',
        ),
        hasLength(1),
      );
      expect(server.adapter.paths, isNot(contains('/drive/files/create')));
      expect(result.items[0], isA<MisskeyBatchFailure>());
      expect(_skipReason(result.items[1]), MisskeyBatchSkipReason.rateLimited);
    });

    test('replays partial transfer progress when an upload fails', () async {
      final adapter = _PartialFailureAdapter();
      final client = testClient(adapter);
      addTearDown(client.dispose);
      final progress = <DriveBatchUploadProgress>[];

      final result = await client.drive.files.createMany([
        const DriveUploadInput(bytes: [1, 2, 3], filename: 'partial.bin'),
      ], onProgress: progress.add);

      expect(result.items.single, isA<MisskeyBatchFailure>());
      expect(progress, hasLength(2));
      expect(progress[0].sent, 7);
      expect(progress[0].total, 19);
      expect(progress[1].completedItems, 1);
      expect(progress[1].sent, 7);
      expect(progress[1].total, 19);
    });

    test(
      'deduplication looks up hashes and reuses identical batch inputs',
      () async {
        final server = _server();
        addTearDown(server.client.dispose);
        final inputs = [
          const DriveUploadInput(bytes: [1, 2, 3], filename: 'first.bin'),
          const DriveUploadInput(bytes: [1, 2, 3], filename: 'second.bin'),
        ];

        final result = await server.client.drive.files.createMany(
          inputs,
          deduplicate: DriveDuplicatePolicy.reuseExisting,
        );

        expect(
          server.adapter.paths.where(
            (path) => path == '/drive/files/find-by-hash',
          ),
          hasLength(1),
        );
        expect(
          server.adapter.paths.where((path) => path == '/drive/files/create'),
          hasLength(1),
        );
        final first = (result.items[0] as MisskeyBatchSuccess).value;
        final second = (result.items[1] as MisskeyBatchSuccess).value;
        expect(second.outcome, DriveUploadOutcome.reusedExisting);
        expect(second.file.id, first.file.id);
      },
    );

    test('moves an identical follower to its requested folder', () async {
      final server = _server();
      final folder = server.addFolder();
      addTearDown(server.client.dispose);
      final inputs = [
        const DriveUploadInput(bytes: [1, 2, 3], filename: 'first.bin'),
        DriveUploadInput(
          bytes: const [1, 2, 3],
          filename: 'second.bin',
          folderId: folder.id,
        ),
      ];

      final result = await server.client.drive.files.createMany(
        inputs,
        deduplicate: DriveDuplicatePolicy.moveExisting,
      );

      final second = (result.items[1] as MisskeyBatchSuccess).value;
      expect(second.outcome, DriveUploadOutcome.movedExisting);
      expect(server.adapter.paths.last, '/drive/files/update');
    });

    test('uploadAnyway uploads every identical input', () async {
      final server = _server();
      addTearDown(server.client.dispose);
      final inputs = [
        const DriveUploadInput(bytes: [1, 2, 3], filename: 'first.bin'),
        const DriveUploadInput(bytes: [1, 2, 3], filename: 'second.bin'),
      ];

      await server.client.drive.files.createMany(
        inputs,
        deduplicate: DriveDuplicatePolicy.uploadAnyway,
      );

      expect(
        server.adapter.paths.where((path) => path == '/drive/files/create'),
        hasLength(2),
      );
      expect(
        server.adapter.paths,
        isNot(contains('/drive/files/find-by-hash')),
      );
    });

    test('skips an identical follower when its leader fails', () async {
      final server = _server();
      addTearDown(server.client.dispose);
      server.failWhen(
        '/drive/files/create',
        (_) => true,
        ScriptedResponse.error(400, code: 'INVALID_PARAM'),
      );
      final inputs = [
        const DriveUploadInput(bytes: [1, 2, 3], filename: 'first.bin'),
        const DriveUploadInput(bytes: [1, 2, 3], filename: 'second.bin'),
      ];

      final result = await server.client.drive.files.createMany(
        inputs,
        deduplicate: DriveDuplicatePolicy.reuseExisting,
      );

      expect(result.items[0], isA<MisskeyBatchFailure>());
      expect(
        _skipReason(result.items[1]),
        MisskeyBatchSkipReason.dependencyFailed,
      );
      expect((result.items[1] as MisskeyBatchSkipped).cause, isNotNull);
    });

    test(
      'chains moveExisting followers through the latest folder state',
      () async {
        final server = _server();
        final folder = server.addFolder();
        addTearDown(server.client.dispose);
        final inputs = [
          const DriveUploadInput(bytes: [1, 2, 3], filename: 'root-one.bin'),
          DriveUploadInput(
            bytes: const [1, 2, 3],
            filename: 'folder.bin',
            folderId: folder.id,
          ),
          const DriveUploadInput(bytes: [1, 2, 3], filename: 'root-two.bin'),
        ];

        final result = await server.client.drive.files.createMany(
          inputs,
          concurrency: 3,
          deduplicate: DriveDuplicatePolicy.moveExisting,
        );

        final first = (result.items[0] as MisskeyBatchSuccess).value;
        final second = (result.items[1] as MisskeyBatchSuccess).value;
        final third = (result.items[2] as MisskeyBatchSuccess).value;
        expect(first.file.folderId, isNull);
        expect(second.file.folderId, folder.id);
        expect(third.file.folderId, isNull);
        expect(server.files.single.folderId, isNull);
        expect(
          server.adapter.paths.where((path) => path == '/drive/files/update'),
          hasLength(2),
        );
      },
    );

    test(
      'does not update a follower after another item stops the batch',
      () async {
        final server = _server();
        final folder = server.addFolder();
        addTearDown(server.client.dispose);
        final failureGate = Completer<void>();
        final leaderGate = Completer<void>();
        server.failWhen(
          '/drive/files/create',
          (request) => request.formFileNames.single == 'failure.bin',
          ScriptedResponse.gated(
            failureGate.future,
            ScriptedResponse.error(400, code: 'INVALID_PARAM'),
          ),
        );
        server.failWhen(
          '/drive/files/create',
          (request) => request.formFileNames.single == 'leader.bin',
          ScriptedResponse.gated(
            leaderGate.future,
            ScriptedResponse.json(_file('leader')),
          ),
        );
        final inputs = [
          const DriveUploadInput(bytes: [9], filename: 'failure.bin'),
          const DriveUploadInput(bytes: [1, 2, 3], filename: 'leader.bin'),
          DriveUploadInput(
            bytes: const [1, 2, 3],
            filename: 'follower.bin',
            folderId: folder.id,
          ),
        ];

        final future = server.client.drive.files.createMany(
          inputs,
          concurrency: 3,
          deduplicate: DriveDuplicatePolicy.moveExisting,
          stopOnError: true,
        );
        await _until(() => server.adapter.inFlight == 2);
        failureGate.complete();
        await _until(() => server.adapter.inFlight == 1);
        leaderGate.complete();
        final result = await future;

        expect(result.items[1], isA<MisskeyBatchSuccess>());
        expect(
          _skipReason(result.items[2]),
          MisskeyBatchSkipReason.stoppedAfterError,
        );
        expect(server.adapter.paths, isNot(contains('/drive/files/update')));
      },
    );

    test(
      'reports a running follower as dependencyFailed after failure',
      () async {
        final server = _server();
        addTearDown(server.client.dispose);
        final gate = Completer<void>();
        server.failWhen(
          '/drive/files/create',
          (_) => true,
          ScriptedResponse.gated(
            gate.future,
            ScriptedResponse.error(400, code: 'INVALID_PARAM'),
          ),
        );
        final inputs = [
          const DriveUploadInput(bytes: [1, 2, 3], filename: 'leader.bin'),
          const DriveUploadInput(bytes: [1, 2, 3], filename: 'follower.bin'),
        ];

        final future = server.client.drive.files.createMany(
          inputs,
          concurrency: 2,
          deduplicate: DriveDuplicatePolicy.reuseExisting,
          stopOnError: true,
        );
        await _until(() => server.adapter.inFlight == 1);
        gate.complete();
        final result = await future;

        expect(result.items[0], isA<MisskeyBatchFailure>());
        expect(
          _skipReason(result.items[1]),
          MisskeyBatchSkipReason.dependencyFailed,
        );
      },
    );

    test(
      'reports a running follower as dependencyFailed after a rate limit',
      () async {
        final server = _server();
        addTearDown(server.client.dispose);
        final gate = Completer<void>();
        server.failWhen(
          '/drive/files/create',
          (_) => true,
          ScriptedResponse.gated(
            gate.future,
            ScriptedResponse.error(429, code: 'RATE_LIMITED'),
          ),
        );
        final inputs = [
          const DriveUploadInput(bytes: [1, 2, 3], filename: 'leader.bin'),
          const DriveUploadInput(bytes: [1, 2, 3], filename: 'follower.bin'),
        ];

        final future = server.client.drive.files.createMany(
          inputs,
          concurrency: 2,
          deduplicate: DriveDuplicatePolicy.reuseExisting,
        );
        await _until(() => server.adapter.inFlight == 1);
        gate.complete();
        final result = await future;

        expect(result.items[0], isA<MisskeyBatchFailure>());
        expect(
          _skipReason(result.items[1]),
          MisskeyBatchSkipReason.dependencyFailed,
        );
      },
    );

    test('keeps cancellation for unstarted group members', () async {
      final server = _server();
      addTearDown(server.client.dispose);
      final gate = Completer<void>();
      final cancellation = MisskeyCancellationToken();
      server.failWhen(
        '/drive/files/create',
        (request) => request.formFileNames.single == 'blocking.bin',
        ScriptedResponse.gated(
          gate.future,
          ScriptedResponse.json(_file('one')),
        ),
      );
      final inputs = [
        const DriveUploadInput(bytes: [9], filename: 'blocking.bin'),
        const DriveUploadInput(bytes: [1, 2, 3], filename: 'leader.bin'),
        const DriveUploadInput(bytes: [1, 2, 3], filename: 'follower.bin'),
      ];

      final future = server.client.drive.files.createMany(
        inputs,
        concurrency: 1,
        deduplicate: DriveDuplicatePolicy.reuseExisting,
        cancellation: cancellation,
      );
      await _until(() => server.adapter.inFlight == 1);
      cancellation.cancel();
      gate.complete();
      final result = await future;

      expect(_skipReason(result.items[1]), MisskeyBatchSkipReason.cancelled);
      expect(_skipReason(result.items[2]), MisskeyBatchSkipReason.cancelled);
    });

    test('upgrades sensitivity for a reused follower', () async {
      final server = _server();
      addTearDown(server.client.dispose);
      final inputs = [
        const DriveUploadInput(bytes: [1, 2, 3], filename: 'leader.bin'),
        const DriveUploadInput(
          bytes: [1, 2, 3],
          filename: 'follower.bin',
          isSensitive: true,
        ),
      ];

      final result = await server.client.drive.files.createMany(
        inputs,
        deduplicate: DriveDuplicatePolicy.reuseExisting,
      );

      final follower = (result.items[1] as MisskeyBatchSuccess).value;
      expect(follower.file.isSensitive, isTrue);
      expect(server.adapter.paths.last, '/drive/files/update');
      expect(
        server.adapter.requests.last.jsonBody,
        containsPair('isSensitive', true),
      );
    });

    test('returns an empty result without requests for empty input', () async {
      final server = _server();
      addTearDown(server.client.dispose);

      final result = await server.client.drive.files.createMany(const []);

      expect(result.items, isEmpty);
      expect(server.adapter.requests, isEmpty);
    });

    test('rejects invalid concurrency before sending requests', () async {
      final server = _server();
      addTearDown(server.client.dispose);

      expect(
        () => server.client.drive.files.createMany(_inputs(1), concurrency: 0),
        throwsArgumentError,
      );
      expect(server.adapter.requests, isEmpty);
    });
  });
}

FakeDriveServer _server() =>
    FakeDriveServer(md5Of: (bytes) => crypto.md5.convert(bytes).toString());

List<DriveUploadInput> _inputs(int count) => List.generate(
  count,
  (index) => DriveUploadInput(
    bytes: [index + 1, index + 2, index + 3],
    filename: 'file-$index.txt',
  ),
);

MisskeyBatchSkipReason _skipReason(
  MisskeyBatchItemResult<DriveUploadInput, DriveUploadResult> item,
) => (item as MisskeyBatchSkipped).reason;

Map<String, dynamic> _file(String id) => {
  'id': id,
  'createdAt': '2026-01-01T00:00:00.000Z',
  'name': '$id.txt',
  'type': 'text/plain',
  'md5': 'd41d8cd98f00b204e9800998ecf8427e',
  'size': 1,
  'isSensitive': false,
  'isLink': false,
  'url': 'https://example.com/$id',
  'thumbnailUrl': null,
  'comment': null,
  'folderId': null,
  'userId': 'user',
  'user': null,
};

final class _PartialFailureAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    options.onSendProgress?.call(7, 19);
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<void> _until(bool Function() condition) async {
  for (var attempts = 0; attempts < 1000; attempts++) {
    if (condition()) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('Timed out waiting for the expected test state.');
}
