import 'dart:async';

import 'package:misskey_client/src/internal/id_paginator.dart';
import 'package:test/test.dart';

void main() {
  late List<(int, String?)> requests;

  Stream<String> paginate(List<List<String>> pages, {int? maxItems}) {
    return paginateById(
      fetchPage: (limit, untilId) async {
        requests.add((limit, untilId));
        return pages[requests.length - 1];
      },
      idOf: (item) => item,
      pageSize: 2,
      maxItems: maxItems,
    );
  }

  setUp(() => requests = []);

  test('short page ends after one request', () async {
    expect(
      await paginate([
        ['9'],
      ]).toList(),
      ['9'],
    );
    expect(requests, [(2, null)]);
  });

  test('two full pages and a short page advance the cursor', () async {
    expect(
      await paginate([
        ['9', '8'],
        ['7', '6'],
        ['5'],
      ]).toList(),
      ['9', '8', '7', '6', '5'],
    );
    expect(requests, [(2, null), (2, '8'), (2, '6')]);
  });

  test('exact multiple requires a final empty request', () async {
    expect(
      await paginate([
        ['9', '8'],
        [],
      ]).toList(),
      ['9', '8'],
    );
    expect(requests, [(2, null), (2, '8')]);
  });

  test('maxItems trims the final request limit', () async {
    expect(
      await paginate([
        ['9', '8'],
        ['7'],
      ], maxItems: 3).toList(),
      ['9', '8', '7'],
    );
    expect(requests, [(2, null), (1, '8')]);
  });

  test('maxItems trims an over-long response page', () async {
    final gate = Completer<List<String>>();
    final started = Completer<void>();
    final result = paginateById<String>(
      fetchPage: (limit, untilId) {
        requests.add((limit, untilId));
        started.complete();
        return gate.future;
      },
      idOf: (item) => item,
      pageSize: 2,
      maxItems: 1,
    ).toList();
    await started.future;
    gate.complete(['9', '8', '7']);
    expect(await result, ['9']);
    expect(requests, [(1, null)]);
  });

  for (final fails in [false, true]) {
    for (final discardCancel in [false, true]) {
      test(
        'pending fetch cancellation (fails: $fails, discarded: $discardCancel)',
        () async {
          final unhandled = <Object>[];
          final cancellationErrors = <Object>[];
          final events = <Object>[];
          var cancellationCompleted = false;
          await runZonedGuarded<Future<void>>(() async {
            final gate = Completer<List<String>>();
            final started = Completer<void>();
            final subscription = paginateById<String>(
              fetchPage: (limit, untilId) {
                requests.add((limit, untilId));
                started.complete();
                return gate.future;
              },
              idOf: (item) => item,
              pageSize: 2,
            ).listen(events.add, onError: (Object error) => events.add(error));
            await started.future;
            final cancelled = subscription.cancel();
            Future<void>? checked;
            if (!discardCancel) {
              checked = cancelled.then<void>(
                (_) => cancellationCompleted = true,
                onError: (Object error) => cancellationErrors.add(error),
              );
            }
            if (fails) {
              gate.completeError(StateError('fetch failed'));
            } else {
              gate.complete(['9', '8']);
            }
            await checked;
            await Future<void>.delayed(Duration.zero);
          }, (error, _) => unhandled.add(error));
          expect(unhandled, isEmpty);
          expect(cancellationErrors, isEmpty);
          if (!discardCancel) expect(cancellationCompleted, isTrue);
          expect(requests, [(2, null)]);
          expect(events, isEmpty);
        },
      );
    }
  }

  test('pause immediately after listen prevents the first request', () async {
    final events = <String>[];
    final done = Completer<void>();
    final subscription = paginate([
      ['9', '8'],
      ['7'],
    ]).listen(events.add, onDone: done.complete);
    subscription.pause();
    await Future<void>.delayed(Duration.zero);
    expect(requests, isEmpty);
    expect(events, isEmpty);
    subscription.resume();
    await done.future;
    expect(events, ['9', '8', '7']);
    expect(requests, [(2, null), (2, '8')]);
  });

  test(
    'pause during the readiness gap between pages prevents fetching',
    () async {
      final paused = Completer<void>();
      final done = Completer<void>();
      final events = <String>[];
      late StreamSubscription<String> subscription;
      subscription = paginateById<String>(
        fetchPage: (limit, untilId) async {
          requests.add((limit, untilId));
          return untilId == null ? ['9', '8'] : ['7'];
        },
        idOf: (item) {
          if (item == '8') {
            // 次のページの準備待ちとその継続の間に pause する。
            scheduleMicrotask(() {
              subscription.pause();
              paused.complete();
            });
          }
          return item;
        },
        pageSize: 2,
      ).listen(events.add, onDone: done.complete);
      await paused.future;
      await Future<void>.delayed(Duration.zero);
      expect(requests, [(2, null)]);
      expect(events, ['9', '8']);
      subscription.resume();
      await done.future;
      expect(requests, [(2, null), (2, '8')]);
      expect(events, ['9', '8', '7']);
    },
  );

  test(
    'pause after a delivered page prevents the next fetch until resume',
    () async {
      final paused = Completer<void>();
      final done = Completer<void>();
      final events = <String>[];
      late StreamSubscription<String> subscription;
      subscription =
          paginate([
            ['9', '8'],
            ['7'],
          ]).listen((item) {
            events.add(item);
            if (item == '8') {
              subscription.pause();
              paused.complete();
            }
          }, onDone: done.complete);
      await paused.future;
      await Future<void>.delayed(Duration.zero);
      expect(events, ['9', '8']);
      expect(requests, [(2, null)]);
      subscription.resume();
      await done.future;
      expect(events, ['9', '8', '7']);
      expect(requests, [(2, null), (2, '8')]);
    },
  );

  test(
    'pause within a page holds remaining items and cancellation releases it',
    () async {
      final paused = Completer<void>();
      final events = <String>[];
      late StreamSubscription<String> subscription;
      subscription =
          paginate([
            ['9', '8'],
          ]).listen((item) {
            events.add(item);
            subscription.pause();
            paused.complete();
          });
      await paused.future;
      await Future<void>.delayed(Duration.zero);
      expect(events, ['9']);
      await subscription.cancel();
      await Future<void>.delayed(Duration.zero);
      expect(events, ['9']);
      expect(requests, [(2, null)]);
    },
  );

  test('await-for backpressure prevents fetching before consumption', () async {
    final consumed = Completer<void>();
    final resume = Completer<void>();
    final events = <String>[];
    final processing = () async {
      await for (final item in paginate([
        ['9', '8'],
        ['7'],
      ])) {
        events.add(item);
        if (item == '8') {
          consumed.complete();
          await resume.future;
        }
      }
    }();
    await consumed.future;
    await Future<void>.delayed(Duration.zero);
    expect(requests, [(2, null)]);
    resume.complete();
    await processing;
    expect(events, ['9', '8', '7']);
    expect(requests, [(2, null), (2, '8')]);
  });

  test('zero maxItems does not request a page', () async {
    expect(await paginate([], maxItems: 0).toList(), isEmpty);
    expect(requests, isEmpty);
  });

  test('argument validation throws synchronously', () {
    for (final size in [0, -1, 101]) {
      expect(() => validatePageArgs(size, null), throwsArgumentError);
    }
    expect(() => validatePageArgs(100, -1), throwsArgumentError);
    validatePageArgs(1, 0);
    validatePageArgs(100, null);
  });

  test('stalled or backwards cursors stop', () async {
    for (final last in ['8', '9']) {
      requests.clear();
      expect(
        await paginate([
          ['9', '8'],
          ['7', last],
        ]).toList(),
        ['9', '8', '7'],
      );
      expect(requests, hasLength(2));
    }
  });

  test('a repeated page yields no duplicate items', () async {
    expect(
      await paginate([
        ['9', '8'],
        ['9', '8'],
      ]).toList(),
      ['9', '8'],
    );
    expect(requests, hasLength(2));
  });

  test('cancelling after the first item sends no second request', () async {
    expect(
      await paginate([
        ['9', '8'],
      ]).take(1).toList(),
      ['9'],
    );
    expect(requests, hasLength(1));
  });

  test('page two error follows page one items', () async {
    final error = StateError('page two');
    final stream = paginateById<String>(
      fetchPage: (limit, untilId) async {
        if (untilId != null) throw error;
        return ['9', '8'];
      },
      idOf: (item) => item,
      pageSize: 2,
    );
    await expectLater(
      stream,
      emitsInOrder(['9', '8', emitsError(same(error)), emitsDone]),
    );
  });
}
