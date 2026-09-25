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
          ['9', last],
        ]).toList(),
        ['9', '8', '9', last],
      );
      expect(requests, hasLength(2));
    }
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
