import 'dart:async';

import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/internal/bounded_batch.dart';
import 'package:test/test.dart';

void main() {
  test('gated workers bound concurrency and preserve input order', () async {
    final gates = List.generate(5, (_) => Completer<int>());
    final started = <int>[];
    final notified = <int>[];
    var inFlight = 0;
    var maxInFlight = 0;
    final future = runBounded<int, int>(
      inputs: [0, 1, 2, 3, 4],
      concurrency: 2,
      task: (input, index) async {
        expect(input, index);
        started.add(index);
        inFlight++;
        if (inFlight > maxInFlight) maxInFlight = inFlight;
        final value = await gates[index].future;
        inFlight--;
        return value;
      },
      onResult: (item) => notified.add(item.index),
    );
    expect(started, [0, 1]);
    for (final index in [1, 2, 3, 4, 0]) {
      gates[index].complete(index * 10);
      await Future<void>.delayed(Duration.zero);
    }
    final result = await future;
    expect(maxInFlight, 2);
    expect(result.items.map((item) => item.input), [0, 1, 2, 3, 4]);
    expect(result.successes.map((item) => item.value), [0, 10, 20, 30, 40]);
    expect(notified, [1, 2, 3, 4, 0]);
    expect(result.isComplete, isTrue);
  });

  test('rate limit skips unstarted inputs with the original cause', () async {
    const error = MisskeyRateLimitException();
    final gate = Completer<int>();
    final started = <int>[];
    final future = runBounded<int, int>(
      inputs: [0, 1, 2, 3],
      concurrency: 2,
      stopReasonFor: stopOnRateLimit,
      task: (input, index) async {
        started.add(index);
        if (index == 0) throw error;
        return gate.future;
      },
    );
    await Future<void>.delayed(Duration.zero);
    expect(started, [0, 1]);
    gate.complete(1);
    final result = await future;
    expect(result.failures.single.error, same(error));
    expect(result.successes.single.index, 1);
    expect(result.skipped.map((item) => item.index), [2, 3]);
    for (final item in result.skipped) {
      expect(item.reason, MisskeyBatchSkipReason.rateLimited);
      expect(item.cause, same(error));
    }
    expect(result.isComplete, isFalse);
    expect(stopOnRateLimit(StateError('other')), isNull);
  });

  test(
    'cancellation before an in-flight 429 keeps cancelled as the reason',
    () async {
      final token = MisskeyCancellationToken();
      final gate = Completer<int>();
      final future = runBounded<int, int>(
        inputs: [0, 1, 2],
        concurrency: 1,
        cancellation: token,
        stopReasonFor: stopOnRateLimit,
        task: (_, _) => gate.future,
      );
      token.cancel();
      gate.completeError(const MisskeyRateLimitException());
      final result = await future;
      expect(result.failures.single.error, isA<MisskeyRateLimitException>());
      expect(result.skipped, hasLength(2));
      for (final item in result.skipped) {
        expect(item.reason, MisskeyBatchSkipReason.cancelled);
        expect(item.cause, isNull);
      }
    },
  );

  test('later cancellation does not override a rate-limit stop', () async {
    final token = MisskeyCancellationToken();
    final gate = Completer<int>();
    const error = MisskeyRateLimitException();
    final future = runBounded<int, int>(
      inputs: [0, 1, 2],
      concurrency: 2,
      cancellation: token,
      stopReasonFor: stopOnRateLimit,
      task: (_, index) async {
        if (index == 0) throw error;
        return gate.future;
      },
    );
    await Future<void>.delayed(Duration.zero);
    token.cancel();
    gate.complete(1);
    final result = await future;
    expect(result.skipped.single.reason, MisskeyBatchSkipReason.rateLimited);
    expect(result.skipped.single.cause, same(error));
  });

  test(
    'stopReasonFor errors stop work and rethrow after workers finish',
    () async {
      final taskError = StateError('task');
      final callbackError = StateError('classifier');
      final stack = StackTrace.current;
      final gate = Completer<int>();
      final notified = <MisskeyBatchItemResult<int, int>>[];
      final future = runBounded<int, int>(
        inputs: [0, 1, 2],
        concurrency: 2,
        task: (_, index) async {
          if (index == 0) throw taskError;
          return gate.future;
        },
        stopReasonFor: (_) => Error.throwWithStackTrace(callbackError, stack),
        onResult: (item) {
          notified.add(item);
          throw StateError('later callback');
        },
      );
      var completed = false;
      final checked = future.then<void>(
        (_) => fail('must throw'),
        onError: (Object error, StackTrace trace) {
          completed = true;
          expect(error, same(callbackError));
          expect(trace.toString(), stack.toString());
        },
      );
      await Future<void>.delayed(Duration.zero);
      expect(completed, isFalse);
      expect(
        (notified.single as MisskeyBatchFailure<int, int>).error,
        same(taskError),
      );
      gate.complete(1);
      await checked;
      expect(notified.map((item) => item.index), [0, 1, 2]);
      final skipped = notified.last as MisskeyBatchSkipped<int, int>;
      expect(skipped.reason, MisskeyBatchSkipReason.stoppedAfterError);
      expect(skipped.cause, same(callbackError));
    },
  );

  test('concurrency validation throws synchronously', () {
    for (final concurrency in [0, -1]) {
      expect(() => validateConcurrency(concurrency), throwsArgumentError);
    }
    validateConcurrency(1);
    validateConcurrency(100);
  });

  test('ordinary failures do not stop other tasks', () async {
    final error = StateError('failure');
    final result = await runBounded<int, Null>(
      inputs: [0, 1],
      concurrency: 1,
      stopReasonFor: stopOnRateLimit,
      task: (input, index) async {
        if (index == 0) throw error;
        return null;
      },
    );
    expect(result.failures.single.error, same(error));
    expect(result.failures.single.stackTrace, isA<StackTrace>());
    expect(result.successes.single.value, isNull);
  });

  test('cancellation waits for in-flight tasks and skips the rest', () async {
    final token = MisskeyCancellationToken();
    final gate = Completer<int>();
    final future = runBounded<int, int>(
      inputs: [0, 1, 2],
      concurrency: 1,
      cancellation: token,
      task: (_, _) => gate.future,
    );
    var completed = false;
    future.then((_) => completed = true);
    token.cancel();
    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);
    gate.complete(10);
    final result = await future;
    expect(result.successes.single.value, 10);
    expect(result.skipped, hasLength(2));
    expect(
      result.skipped.every(
        (item) =>
            item.reason == MisskeyBatchSkipReason.cancelled &&
            item.cause == null,
      ),
      isTrue,
    );
  });

  test('pre-cancelled token starts no tasks', () async {
    final token = MisskeyCancellationToken()..cancel();
    final result = await runBounded<int, int>(
      inputs: [0, 1],
      concurrency: 4,
      cancellation: token,
      task: (_, _) async => fail('must not start'),
    );
    expect(result.skipped, hasLength(2));
  });

  test(
    'onResult errors stop work and rethrow first error after workers finish',
    () async {
      final first = StateError('first callback');
      final second = StateError('later callback');
      final stack = StackTrace.current;
      final gate = Completer<int>();
      final notified = <MisskeyBatchItemResult<int, int>>[];
      final future = runBounded<int, int>(
        inputs: [0, 1, 2, 3],
        concurrency: 2,
        task: (input, index) async => index == 0 ? 0 : await gate.future,
        onResult: (item) {
          notified.add(item);
          Error.throwWithStackTrace(
            notified.length == 1 ? first : second,
            stack,
          );
        },
      );
      var completed = false;
      final checked = future.then<void>(
        (_) => fail('must throw'),
        onError: (Object error, StackTrace trace) {
          completed = true;
          expect(error, same(first));
          expect(trace.toString(), stack.toString());
        },
      );
      await Future<void>.delayed(Duration.zero);
      expect(completed, isFalse);
      gate.complete(1);
      await checked;
      expect(notified.map((item) => item.index), [0, 1, 2, 3]);
      final skipped = notified.whereType<MisskeyBatchSkipped<int, int>>();
      expect(skipped, hasLength(2));
      expect(
        skipped.every(
          (item) =>
              item.reason == MisskeyBatchSkipReason.stoppedAfterError &&
              identical(item.cause, first),
        ),
        isTrue,
      );
    },
  );

  test('empty input succeeds without calling task', () async {
    final result = await runBounded<int, int>(
      inputs: [],
      concurrency: 2,
      task: (_, _) async => fail('must not start'),
    );
    expect(result.items, isEmpty);
    expect(result.isComplete, isTrue);
  });

  test('zero concurrency throws even for empty input', () async {
    await expectLater(
      runBounded<int, int>(inputs: [], concurrency: 0, task: (_, _) async => 0),
      throwsArgumentError,
    );
  });

  test('batch getters filter outcomes and items are an immutable copy', () {
    const success = MisskeyBatchSuccess<int, Null>(
      input: 10,
      index: 0,
      value: null,
    );
    final failure = MisskeyBatchFailure<int, Null>(
      input: 20,
      index: 1,
      error: StateError('failed'),
      stackTrace: StackTrace.current,
    );
    const skipped = MisskeyBatchSkipped<int, Null>(
      input: 30,
      index: 2,
      reason: MisskeyBatchSkipReason.dependencyFailed,
    );
    final items = <MisskeyBatchItemResult<int, Null>>[
      success,
      failure,
      skipped,
    ];
    final result = MisskeyBatchResult(items: items);
    items.clear();
    expect(result.items, [success, failure, skipped]);
    expect(() => result.items.clear(), throwsUnsupportedError);
    expect(result.successes, [success]);
    expect(result.failures, [failure]);
    expect(result.skipped, [skipped]);
    expect(result.items.map((item) => item.isSuccess), [true, false, false]);
    expect(result.isComplete, isFalse);
    expect(success.toString(), 'MisskeyBatchSuccess(index: 0, value: null)');
    expect(
      failure.toString(),
      'MisskeyBatchFailure(index: 1, error: Bad state: failed)',
    );
    expect(
      skipped.toString(),
      'MisskeyBatchSkipped(index: 2, reason: MisskeyBatchSkipReason.dependencyFailed, cause: null)',
    );
    expect(
      result.toString(),
      'MisskeyBatchResult(items: 3, successes: 1, failures: 1, skipped: 1)',
    );
    const empty = MisskeyBatchResult<int, Null>.empty();
    expect(empty.isComplete, isTrue);
    expect(
      empty.toString(),
      'MisskeyBatchResult(items: 0, successes: 0, failures: 0, skipped: 0)',
    );
    expect(empty.successes, isEmpty);
    expect(empty.failures, isEmpty);
    expect(empty.skipped, isEmpty);
  });

  test('token cancel is idempotent and completes whenCancelled', () async {
    final token = MisskeyCancellationToken();
    var notified = false;
    token.whenCancelled.then((_) => notified = true);
    expect(token.isCancelled, isFalse);
    await Future<void>.delayed(Duration.zero);
    expect(notified, isFalse);
    token.cancel();
    token.cancel();
    expect(token.isCancelled, isTrue);
    await token.whenCancelled;
    expect(notified, isTrue);
    await token.whenCancelled;
  });
}
