---
sidebar_position: 3
title: 分页
---

# 分页

Misskey 采用基于游标的分页机制。返回列表的 API 直接接收分页参数并返回 `List<T>`，没有包装类型。调用方负责传入参数，并通过检查返回列表的长度来判断是否还有更多页。

## 分页参数

| 参数        | 类型   | 说明                                              |
|-------------|--------|--------------------------------------------------|
| `sinceId`   | String | 返回**比此 ID 更新**的结果                          |
| `untilId`   | String | 返回**比此 ID 更旧**的结果                          |
| `sinceDate` | int    | 返回比此 Unix 时间戳（毫秒）更新的结果               |
| `untilDate` | int    | 返回比此 Unix 时间戳（毫秒）更旧的结果               |
| `limit`     | int    | 最大返回条数（通常为 1–100）                        |
| `offset`    | int    | 跳过指定条数（仅限支持偏移分页的 API）               |

并非所有 API 都支持所有参数，请参阅各端点的 API 参考文档。

## 基于游标的分页（按 ID）

使用 `untilId` 加载更旧的页，使用 `sinceId` 加载更新的页。

### 加载更旧的页

```dart
// 第一页 — 最新的通知
List<MisskeyNotification> page = await client.notifications.list(limit: 20);

// 下一页 — 比上一页最后一项更旧的内容
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

### 加载更新的页

```dart
// 记住上次获取到的最新 ID
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

## 基于时间戳的分页

当需要按时间而非 ID 分页时，使用 `sinceDate` 和 `untilDate`。

```dart
final now = DateTime.now().millisecondsSinceEpoch;
final oneDayAgo = now - const Duration(days: 1).inMilliseconds;

final notes = await client.notes.timelineLocal(
  limit: 30,
  sinceDate: oneDayAgo,
  untilDate: now,
);
```

## 基于偏移量的分页

部分 API 支持使用 `offset` 而非游标参数。当无法使用游标导航时可采用此方式。

```dart
const pageSize = 50;
var offset = 0;

while (true) {
  final users = await client.users.list(
    limit: pageSize,
    offset: offset,
  );
  // 处理 users...
  if (users.length < pageSize) break; // 最后一页
  offset += users.length;
}
```

## 判断最后一页

没有 `hasNext` 标志。当返回条数少于 `limit` 时，即为最后一页。

```dart
const limit = 20;
final page = await client.blocking.list(limit: limit);
final isLastPage = page.length < limit;
```

## 遍历所有页

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

## 支持分页的 API

大多数返回列表的 API 都支持 `sinceId`/`untilId` 和 `limit`：

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
- `client.users.list`（偏移量方式）
- `client.notes.search`（偏移量方式）
