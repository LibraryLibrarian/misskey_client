import 'dart:math' as math;

import 'package:meta/meta.dart';

import '../client/misskey_cancellation_token.dart';
import '../exception/misskey_client_exception.dart';
import '../models/batch/misskey_batch_result.dart';

/// Stops a batch when the server responds with HTTP 429.
@internal
MisskeyBatchSkipReason? stopOnRateLimit(Object e) =>
    e is MisskeyApiException && e.statusCode == 429
    ? MisskeyBatchSkipReason.rateLimited
    : null;

/// Runs at most [concurrency] tasks concurrently, returning input-order results.
///
/// Cancellation is cooperative: no Dio `CancelToken` is passed to requests,
/// and in-flight tasks finish before this future completes. The first observed
/// stop reason determines the reason and cause for unstarted inputs.
/// [onResult] receives each outcome, including skipped inputs. If it throws,
/// unstarted work is stopped and its first error is rethrown with its original
/// stack trace after all workers finish.
@internal
Future<MisskeyBatchResult<I, T>> runBounded<I, T>({
  required List<I> inputs,
  required Future<T> Function(I input, int index) task,
  required int concurrency,
  MisskeyCancellationToken? cancellation,
  MisskeyBatchSkipReason? Function(Object error)? stopReasonFor,
  void Function(MisskeyBatchItemResult<I, T>)? onResult,
}) async {
  if (concurrency < 1) {
    throw ArgumentError.value(concurrency, 'concurrency', 'must be positive');
  }
  final pending = List<I>.of(inputs);
  final results = List<MisskeyBatchItemResult<I, T>?>.filled(
    pending.length,
    null,
  );
  var next = 0;
  MisskeyBatchSkipReason? stopReason;
  Object? stopCause;
  Object? callbackError;
  StackTrace? callbackStack;

  void stop(MisskeyBatchSkipReason reason, [Object? cause]) {
    if (stopReason != null) return;
    stopReason = reason;
    stopCause = cause;
  }

  void notify(MisskeyBatchItemResult<I, T> result) {
    try {
      onResult?.call(result);
    } catch (error, stackTrace) {
      callbackError ??= error;
      callbackStack ??= stackTrace;
      stop(MisskeyBatchSkipReason.stoppedAfterError, error);
    }
  }

  Future<void> worker() async {
    while (true) {
      // 停止確認と次の項目の取得の間に await を挟まない。
      if (cancellation?.isCancelled ?? false) {
        stop(MisskeyBatchSkipReason.cancelled);
      }
      if (stopReason != null || next >= pending.length) return;
      final index = next++;
      final input = pending[index];
      MisskeyBatchItemResult<I, T> result;
      try {
        final value = await task(input, index);
        result = MisskeyBatchSuccess(input: input, index: index, value: value);
      } catch (error, stackTrace) {
        result = MisskeyBatchFailure(
          input: input,
          index: index,
          error: error,
          stackTrace: stackTrace,
        );
        final reason = stopReasonFor?.call(error);
        if (reason != null) stop(reason, error);
      }
      results[index] = result;
      notify(result);
    }
  }

  await Future.wait([
    for (var i = 0; i < math.min(concurrency, pending.length); i++) worker(),
  ]);
  for (var index = next; index < pending.length; index++) {
    final result = MisskeyBatchSkipped<I, T>(
      input: pending[index],
      index: index,
      reason: stopReason!,
      cause: stopCause,
    );
    results[index] = result;
    notify(result);
  }
  if (callbackError != null) {
    Error.throwWithStackTrace(callbackError!, callbackStack!);
  }
  return MisskeyBatchResult(
    items: results.cast<MisskeyBatchItemResult<I, T>>(),
  );
}
