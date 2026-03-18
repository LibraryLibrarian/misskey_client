---
sidebar_position: 2
title: 사용자
---

# 사용자

`client.users` API는 사용자 조회, 팔로우 관계 관리, 차단 및 뮤트 처리 기능을 제공합니다. 인증된 사용자의 프로필 관리는 `client.account`에서 처리합니다.

## 사용자 조회

### 사용자 ID로 조회

```dart
final user = await client.users.showOneByUserId('9abc');
print(user.name);     // 표시 이름
print(user.username); // 사용자명 (@ 없이)
print(user.host);     // 로컬 사용자는 null, 원격 사용자는 호스트명
```

### 사용자명으로 조회

```dart
// 로컬 사용자
final user = await client.users.showOneByUsername('alice');

// 원격 사용자
final user = await client.users.showOneByUsername('alice', host: 'other.example.com');
```

### 여러 사용자 한 번에 조회

```dart
final users = await client.users.showMany(
  userIds: ['9abc', '9def', '9ghi'],
);
```

### 사용자 목록 (디렉토리)

```dart
// 팔로워 수 기준으로 정렬된 로컬 사용자
final users = await client.users.list(
  limit: 20,
  sort: '+follower',
  origin: 'local',
);
```

사용 가능한 `sort` 값: `+follower`, `-follower`, `+createdAt`, `-createdAt`, `+updatedAt`, `-updatedAt`.
사용 가능한 `origin` 값: `local`, `remote`, `combined`.

## 팔로워 및 팔로잉

```dart
// 사용자의 팔로워 (ID 기준)
final followers = await client.users.followersByUserId(userId, limit: 20);

// 사용자의 팔로워 (사용자명 기준)
final followers = await client.users.followersByUsername('alice', limit: 20);

// 사용자가 팔로우하는 계정
final following = await client.users.followingByUserId(userId, limit: 20);
```

`sinceId` / `untilId` / `sinceDate` / `untilDate`로 페이지네이션할 수 있습니다.

## 사용자의 노트

```dart
final notes = await client.users.notes(
  userId: userId,
  limit: 20,
  withReplies: false,
  withRenotes: true,
);
```

`withReplies`와 `withFiles`는 동시에 `true`일 수 없습니다 (서버 제약).

## 팔로우 작업

### 팔로우

```dart
final user = await client.following.create(userId: userId);
```

대상 사용자가 팔로우 승인을 요구하면 즉시 팔로우 대신 요청이 전송됩니다.

### 언팔로우

```dart
await client.following.delete(userId: userId);
```

### 팔로우 설정 업데이트

```dart
// 특정 팔로우의 알림 수준 변경
await client.following.update(
  userId: userId,
  notify: 'normal', // 'normal' 또는 'none'
  withReplies: true,
);
```

### 팔로워 제거

```dart
// 자신을 팔로우하는 사람을 강제로 제거
await client.following.invalidate(userId: userId);
```

### 팔로우 요청

```dart
// 대기 중인 수신 요청 목록
final requests = await client.following.requests.listReceived();

// 수락 또는 거절
await client.following.requests.accept(userId: userId);
await client.following.requests.reject(userId: userId);

// 보낸 요청 취소
await client.following.requests.cancel(userId: userId);
```

## 차단

```dart
// 사용자 차단 (상호 팔로우 관계가 해제됨)
await client.blocking.create(userId: userId);

// 차단 해제
await client.blocking.delete(userId: userId);

// 차단한 사용자 목록
final blocked = await client.blocking.list(limit: 20);
```

## 뮤트

```dart
// 사용자 뮤트
await client.mute.create(userId: userId);

// 만료 시간 지정 뮤트 (밀리초 단위 Unix 타임스탬프)
await client.mute.create(userId: userId, expiresAt: expiresAt);

// 뮤트 해제
await client.mute.delete(userId: userId);

// 뮤트한 사용자 목록
final muted = await client.mute.list(limit: 20);
```

## 계정 관리

인증된 사용자의 프로필 관련 작업은 `client.account`에 있습니다.

### 자신의 프로필 조회

```dart
final me = await client.account.i();
print(me.name);
print(me.description);
```

### 프로필 업데이트

```dart
final updated = await client.account.update(
  name: 'Alice',
  description: 'Hello from Misskey!',
  lang: 'en',
);
```

지정된 필드만 변경되며, 생략된 필드는 그대로 유지됩니다.

## 사용자 검색

```dart
final results = await client.users.search(
  query: 'alice',
  limit: 20,
  origin: 'combined',
);
```

## 사용자 목록

사용자 목록은 `client.users.lists`를 통해 접근합니다:

```dart
// 목록 생성
final list = await client.users.lists.create(name: 'Friends');

// 목록에 사용자 추가
await client.users.lists.push(listId: list.id, userId: userId);

// 목록에서 사용자 제거
await client.users.lists.pull(listId: list.id, userId: userId);

// 자신의 목록 가져오기
final lists = await client.users.lists.list();

// 목록 멤버 가져오기
final members = await client.users.lists.getMemberships(listId: list.id);
```
