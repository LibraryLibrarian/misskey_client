import 'dart:async';

import 'package:crypto/crypto.dart' as crypto;
import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

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
      expect(progress.any((event) => event.total > 0), isTrue);
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

Future<void> _until(bool Function() condition) async {
  while (!condition()) {
    await Future<void>.delayed(Duration.zero);
  }
}
