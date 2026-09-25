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
@internal
Stream<T> paginateById<T>({
  required Future<List<T>> Function(int limit, String? untilId) fetchPage,
  required String Function(T) idOf,
  required int pageSize,
  int? maxItems,
}) async* {
  validatePageArgs(pageSize, maxItems);
  String? untilId;
  var count = 0;
  while (maxItems == null || count < maxItems) {
    final limit = maxItems == null
        ? pageSize
        : math.min(pageSize, maxItems - count);
    final page = await fetchPage(limit, untilId);
    for (final item in page) {
      yield item;
      count++;
      if (maxItems != null && count >= maxItems) return;
    }
    if (page.length < limit) return;
    final nextId = idOf(page.last);
    if (untilId != null && nextId.compareTo(untilId) >= 0) return;
    untilId = nextId;
  }
}
