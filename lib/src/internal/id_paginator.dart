import 'dart:async';
import 'dart:math' as math;

import 'package:meta/meta.dart';

/// Validates pagination arguments synchronously.
@internal
void validatePageArgs(int pageSize, int? maxItems) {
  if (pageSize < 1 || pageSize > 100) {
    throw ArgumentError.value(
      pageSize,
      'pageSize',
      'must be between 1 and 100',
    );
  }
  if (maxItems != null && maxItems < 0) {
    throw ArgumentError.value(maxItems, 'maxItems', 'must be non-negative');
  }
}

/// Lazily fetches newest-first ID pages until exhausted or [maxItems] is reached.
///
/// Cancelling discards pending responses and errors without aborting requests.
@internal
Stream<T> paginateById<T>({
  required Future<List<T>> Function(int limit, String? untilId) fetchPage,
  required String Function(T) idOf,
  required int pageSize,
  int? maxItems,
}) {
  late final StreamController<T> controller;
  var cancelled = false;
  Completer<void>? resumed;

  void wake() {
    resumed?.complete();
    resumed = null;
  }

  Future<void> waitUntilReady() async {
    while (!cancelled && controller.isPaused) {
      resumed ??= Completer<void>();
      await resumed!.future;
    }
  }

  Future<void> run() async {
    try {
      validatePageArgs(pageSize, maxItems);
      String? untilId;
      var count = 0;
      while (maxItems == null || count < maxItems) {
        do {
          await waitUntilReady();
        } while (!cancelled && controller.isPaused);
        if (cancelled) return;
        final limit = maxItems == null
            ? pageSize
            : math.min(pageSize, maxItems - count);
        final page = await fetchPage(limit, untilId);
        if (cancelled) return;
        for (final item in page) {
          do {
            await waitUntilReady();
          } while (!cancelled && controller.isPaused);
          if (cancelled) return;
          if (untilId != null && idOf(item).compareTo(untilId) >= 0) return;
          controller.add(item);
          // 配信のマイクロタスクを待ち、購読側の pause/cancel を反映する。
          await Future<void>.value();
          if (cancelled) return;
          count++;
          if (maxItems != null && count >= maxItems) return;
        }
        if (page.length < limit) return;
        untilId = idOf(page.last);
      }
    } catch (error, stackTrace) {
      if (!cancelled) controller.addError(error, stackTrace);
    } finally {
      unawaited(controller.close());
    }
  }

  controller = StreamController<T>(
    onListen: () => unawaited(run()),
    onResume: wake,
    onCancel: () {
      cancelled = true;
      wake();
    },
  );
  return controller.stream;
}
