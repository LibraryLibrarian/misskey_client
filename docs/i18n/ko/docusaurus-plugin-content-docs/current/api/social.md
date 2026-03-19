---
sidebar_position: 5
title: "소셜"
---

# 소셜

소셜 API는 팔로우 관계, 팔로우 요청, 차단, 뮤트를 다룹니다. 모든 작업에 인증이 필요합니다.

## 팔로잉 (`client.following`)

### 사용자 팔로우

```dart
final user = await client.following.create(userId: userId);
```

대상 사용자가 팔로우 승인을 요구하면 즉시 팔로우 대신 요청이 전송됩니다. 메서드는 업데이트된 `MisskeyUser`를 반환합니다.

`withReplies: true`를 전달하면 팔로우한 사용자의 답글도 타임라인에 포함됩니다:

```dart
await client.following.create(userId: userId, withReplies: true);
```

### 언팔로우

```dart
await client.following.delete(userId: userId);
```

### 팔로우 설정 업데이트

개별 팔로우 관계에 대한 알림 및 답글 표시 설정을 변경합니다.

```dart
await client.following.update(
  userId: userId,
  notify: 'normal',   // 'normal' 또는 'none'
  withReplies: true,
);
```

### 모든 팔로우 일괄 업데이트

팔로우하는 모든 계정에 동일한 설정을 적용합니다. 요청 한도: 시간당 10회.

```dart
await client.following.updateAll(notify: 'none', withReplies: false);
```

### 팔로워 제거

자신을 팔로우하는 사람을 강제로 제거합니다.

```dart
await client.following.invalidate(userId: userId);
```

## 팔로우 요청 (`client.following.requests`)

### 수신 요청

```dart
// 나에게 온 대기 중인 요청 목록
final incoming = await client.following.requests.list(limit: 20);
for (final req in incoming) {
  print(req.follower.username);
}

// 요청 수락
await client.following.requests.accept(userId: userId);

// 요청 거절
await client.following.requests.reject(userId: userId);
```

### 발신 요청

```dart
// 내가 보낸 요청 목록
final sent = await client.following.requests.sent(limit: 20);

// 보낸 요청 취소
await client.following.requests.cancel(userId: userId);
```

모든 목록 메서드는 페이지네이션을 위해 `sinceId` / `untilId` 및 `sinceDate` / `untilDate`를 지원합니다.

## 차단 (`client.blocking`)

차단하면 나와 대상 사용자 사이의 상호 팔로우 관계가 해제됩니다. 차단된 사용자는 나를 팔로우할 수 없으며, 나는 그들의 콘텐츠를 볼 수 없게 됩니다.

### 사용자 차단

```dart
await client.blocking.create(userId: userId);
```

### 차단 해제

```dart
await client.blocking.delete(userId: userId);
```

### 차단한 사용자 목록

```dart
final blocked = await client.blocking.list(limit: 20);
for (final b in blocked) {
  print(b.blockee.username);
}
```

`sinceId` / `untilId` 또는 `sinceDate` / `untilDate`로 페이지네이션할 수 있습니다.

## 뮤트 (`client.mute`)

뮤트하면 타임라인에서 해당 사용자의 노트, 리노트, 리액션이 숨겨집니다. 차단과 달리, 대상 사용자는 뮤트된 사실을 알 수 없습니다.

### 사용자 뮤트

```dart
// 영구 뮤트
await client.mute.create(userId: userId);
```

### 시간 제한 뮤트

밀리초 단위 Unix 타임스탬프를 전달하면 뮤트가 자동으로 만료됩니다.

```dart
// 24시간 뮤트
final expiresAt = DateTime.now()
    .add(const Duration(hours: 24))
    .millisecondsSinceEpoch;

await client.mute.create(userId: userId, expiresAt: expiresAt);
```

### 뮤트 해제

```dart
await client.mute.delete(userId: userId);
```

### 뮤트한 사용자 목록

```dart
final muted = await client.mute.list(limit: 20);
for (final m in muted) {
  print(m.mutee.username);
}
```

## 리노트 뮤트 (`client.renoteMute`)

리노트 뮤트는 타임라인에서 해당 사용자의 리노트만 숨깁니다. 원본 노트는 계속 보입니다. 어떤 사람의 원본 콘텐츠는 팔로우하면서 리노트는 보고 싶지 않을 때 유용합니다.

### 리노트 뮤트

```dart
await client.renoteMute.create(userId: userId);
```

### 리노트 뮤트 해제

```dart
await client.renoteMute.delete(userId: userId);
```

### 리노트 뮤트한 사용자 목록

```dart
final renoteMuted = await client.renoteMute.list(limit: 20);
for (final rm in renoteMuted) {
  print(rm.mutee.username);
}
```

`sinceId` / `untilId` 또는 `sinceDate` / `untilDate`로 페이지네이션할 수 있습니다.

## 비교: 뮤트 vs 리노트 뮤트

| | 일반 뮤트 | 리노트 뮤트 |
|---|---|---|
| 원본 노트 숨김 | 예 | 아니오 |
| 리노트 숨김 | 예 | 예 |
| 대상 알림 여부 | 아니오 | 아니오 |
| 시간 제한 만료 | 예 | 아니오 |
