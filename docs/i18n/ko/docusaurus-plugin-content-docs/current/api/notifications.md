---
sidebar_position: 3
title: 알림
---

# 알림

`client.notifications` API는 알림 조회, 일괄 읽음 처리, 커스텀 알림 생성 기능을 제공합니다.

## 알림 조회

### 목록

```dart
final notifications = await client.notifications.list(limit: 20);

for (final n in notifications) {
  print('${n.type}: ${n.userId}');
}
```

기본적으로 알림을 가져오면 읽음으로 표시됩니다. 이를 억제하려면 `markAsRead: false`를 전달합니다:

```dart
final notifications = await client.notifications.list(
  limit: 20,
  markAsRead: false,
);
```

### 그룹화된 알림

같은 노트에 대한 리액션과 리노트가 단일 항목으로 합쳐집니다:

```dart
final grouped = await client.notifications.listGrouped(limit: 20);
```

### 유형별 필터링

```dart
// 멘션과 반응만
final notifications = await client.notifications.list(
  includeTypes: ['mention', 'reaction'],
);

// 팔로우를 제외한 모두
final notifications = await client.notifications.list(
  excludeTypes: ['follow'],
);
```

주요 알림 유형: `follow`, `mention`, `reply`, `renote`, `quote`, `reaction`, `pollEnded`, `achievementEarned`, `app`.

### 페이지네이션

```dart
// 이전 알림
final older = await client.notifications.list(
  limit: 20,
  untilId: notifications.last.id,
);

// 마지막 조회 이후 새 알림
final newer = await client.notifications.list(
  limit: 20,
  sinceId: notifications.first.id,
);
```

`sinceDate`와 `untilDate`는 ID 기반 페이지네이션 대신 밀리초 단위 Unix 타임스탬프를 받습니다.

## 읽음 처리

### 모두 읽음으로 표시

```dart
await client.notifications.markAllAsRead();
```

### 모든 알림 삭제

모든 알림을 영구적으로 삭제합니다:

```dart
await client.notifications.flush();
```

## 알림 생성

### 앱 알림

인증된 사용자에게 앱에서 커스텀 알림을 보냅니다. `write:notifications` 권한이 필요합니다.

```dart
await client.notifications.create(
  body: '내보내기가 완료되어 다운로드 준비가 되었습니다.',
  header: '내보내기 완료',
  icon: 'https://example.com/icon.png',
);
```

생략하면 `header`는 액세스 토큰 이름이, `icon`은 토큰의 아이콘 URL이 기본값으로 사용됩니다.

### 테스트 알림

인증된 사용자에게 테스트 알림 (`type: test`)을 보냅니다. 알림 처리가 올바르게 작동하는지 확인할 때 유용합니다.

```dart
await client.notifications.testNotification();
```

`create`와 `testNotification` 모두 분당 10회의 요청 한도가 있습니다.
