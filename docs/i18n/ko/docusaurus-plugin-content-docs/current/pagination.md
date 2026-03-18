---
sidebar_position: 3
title: 페이지네이션
---

# 페이지네이션

Misskey는 커서 기반 페이지네이션을 사용합니다. 목록을 반환하는 API는 페이지네이션 파라미터를 직접 받아 `List<T>`를 반환합니다. 래퍼 타입은 존재하지 않습니다. 호출자가 파라미터를 전달하고 반환된 목록의 길이를 확인하여 추가 페이지 존재 여부를 판단합니다.

## 페이지네이션 파라미터

| 파라미터     | 타입   | 설명                                               |
|-------------|--------|---------------------------------------------------|
| `sinceId`   | String | 이 ID보다 **새로운** 결과를 반환                     |
| `untilId`   | String | 이 ID보다 **오래된** 결과를 반환                     |
| `sinceDate` | int    | 이 Unix 타임스탬프(ms)보다 새로운 결과를 반환         |
| `untilDate` | int    | 이 Unix 타임스탬프(ms)보다 오래된 결과를 반환         |
| `limit`     | int    | 반환할 최대 항목 수 (일반적으로 1–100)               |
| `offset`    | int    | 지정한 수만큼 건너뜀 (오프셋 기반 API 전용)           |

모든 API가 모든 파라미터를 지원하는 것은 아닙니다. 각 엔드포인트의 API 레퍼런스를 참조하세요.

## 커서 기반 페이지네이션 (ID 기준)

오래된 페이지를 불러오려면 `untilId`를, 새로운 페이지를 불러오려면 `sinceId`를 사용합니다.

### 오래된 페이지 불러오기

```dart
// 첫 번째 페이지 — 가장 최근 알림
List<MisskeyNotification> page = await client.notifications.list(limit: 20);

// 다음 페이지 — 이전 페이지 마지막 항목보다 오래된 것
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

### 새로운 페이지 불러오기

```dart
// 마지막으로 가져온 최신 ID를 기억해 둠
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

## 타임스탬프 기반 페이지네이션

ID 대신 시간 기준으로 페이지를 나눠야 할 때는 `sinceDate`와 `untilDate`를 사용합니다.

```dart
final now = DateTime.now().millisecondsSinceEpoch;
final oneDayAgo = now - const Duration(days: 1).inMilliseconds;

final notes = await client.notes.timelineLocal(
  limit: 30,
  sinceDate: oneDayAgo,
  untilDate: now,
);
```

## 오프셋 기반 페이지네이션

일부 API는 커서 파라미터 대신 `offset`을 지원합니다. 커서 탐색을 사용할 수 없는 경우에 활용합니다.

```dart
const pageSize = 50;
var offset = 0;

while (true) {
  final users = await client.users.list(
    limit: pageSize,
    offset: offset,
  );
  // users 처리...
  if (users.length < pageSize) break; // 마지막 페이지
  offset += users.length;
}
```

## 마지막 페이지 감지

`hasNext` 플래그는 없습니다. 반환된 항목 수가 `limit`보다 적으면 마지막 페이지입니다.

```dart
const limit = 20;
final page = await client.blocking.list(limit: limit);
final isLastPage = page.length < limit;
```

## 모든 페이지 순회

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

## 페이지네이션을 지원하는 API

목록을 반환하는 대부분의 API는 `sinceId`/`untilId`와 `limit`을 지원합니다:

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
- `client.users.list` (오프셋 방식)
- `client.notes.search` (오프셋 방식)
