---
sidebar_position: 3
title: Pagination
---

# Pagination

Misskey uses cursor-based pagination. APIs that return lists accept pagination parameters directly and return `List<T>` — there is no wrapper type. Your code passes the parameters and inspects the result length to determine whether more pages exist.

## Pagination parameters

| Parameter   | Type   | Description                                      |
|-------------|--------|--------------------------------------------------|
| `sinceId`   | String | Return results **newer** than this note/object ID |
| `untilId`   | String | Return results **older** than this note/object ID |
| `sinceDate` | int    | Return results newer than this Unix timestamp (ms) |
| `untilDate` | int    | Return results older than this Unix timestamp (ms) |
| `limit`     | int    | Maximum number of items to return (typically 1–100) |
| `offset`    | int    | Skip this many items (offset-based APIs only)    |

Not every API accepts every parameter. Refer to the API reference for each endpoint.

## Cursor-based pagination (by ID)

Use `untilId` to load older pages and `sinceId` to load newer pages.

### Loading older pages

```dart
// First page — most recent notifications
List<MisskeyNotification> page = await client.notifications.list(limit: 20);

// Next page — older than the last item on the previous page
while (page.isNotEmpty) {
  final oldestId = page.last.id;
  final next = await client.notifications.list(
    limit: 20,
    untilId: oldestId,
  );
  if (next.isEmpty) break;
  page = next;
}
```

### Loading newer pages

```dart
// Remember the newest ID from the last fetch
String? latestId;

Future<List<MisskeyNote>> pollNewNotes() async {
  final notes = await client.notes.timelineHome(
    limit: 20,
    sinceId: latestId,
  );
  if (notes.isNotEmpty) {
    latestId = notes.first.id;
  }
  return notes;
}
```

## Timestamp-based pagination

Use `sinceDate` and `untilDate` when you need to page by time rather than by ID.

```dart
final now = DateTime.now().millisecondsSinceEpoch;
final oneDayAgo = now - const Duration(days: 1).inMilliseconds;

final notes = await client.notes.timelineLocal(
  limit: 30,
  sinceDate: oneDayAgo,
  untilDate: now,
);
```

## Offset-based pagination

Some APIs support `offset` instead of cursor parameters. Use this when fetching ordered lists where cursor navigation is not available.

```dart
const pageSize = 50;
var offset = 0;

while (true) {
  final users = await client.users.list(
    limit: pageSize,
    offset: offset,
  );
  // process users...
  if (users.length < pageSize) break; // last page
  offset += users.length;
}
```

## Detecting the last page

There is no `hasNext` flag. A page is the last page when the number of returned items is less than `limit`.

```dart
const limit = 20;
final page = await client.blocking.list(limit: limit);
final isLastPage = page.length < limit;
```

## Iterating through all pages

```dart
Future<List<MisskeyNote>> fetchAllFavorites() async {
  const limit = 100;
  final all = <MisskeyNote>[];
  String? untilId;

  while (true) {
    final page = await client.account.favorites(
      limit: limit,
      untilId: untilId,
    );
    all.addAll(page);
    if (page.length < limit) break;
    untilId = page.last.id;
  }

  return all;
}
```

## APIs that support pagination

Most list-returning APIs support `sinceId`/`untilId` and `limit`:

- `client.notes.timelineHome` / `timelineLocal` / `timelineGlobal`
- `client.notes.list`
- `client.notifications.list`
- `client.account.favorites`
- `client.blocking.list`
- `client.mute.list`
- `client.clips.list`
- `client.following.requests.list`
- `client.antennas.notes`
- `client.channels.timeline`
- `client.users.list` (offset-based)
- `client.notes.search` (offset-based)
