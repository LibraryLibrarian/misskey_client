---
sidebar_position: 8
title: "서버 및 연합"
---

# 서버 및 연합

이 페이지에서는 서버 메타데이터, 연합, 역할, 차트, ActivityPub을 조회하는 API를 다룹니다.

## MetaApi

`client.meta`는 서버 메타데이터 및 기능 감지를 제공합니다.

### 메타데이터 조회

```dart
final meta = await client.meta.getMeta();
print(meta.name);        // 서버 이름
print(meta.description); // 서버 설명
```

결과는 첫 번째 호출 후 메모리에 캐시됩니다. 캐시를 우회하려면 `refresh: true`를 사용합니다:

```dart
final fresh = await client.meta.getMeta(refresh: true);
```

경량 응답을 받으려면 `detail: false`를 전달합니다 (`MetaLite`에 해당):

```dart
final lite = await client.meta.getMeta(detail: false);
```

### 기능 감지

`supports()`를 사용하기 전에 `getMeta()`를 최소 한 번 호출해야 합니다. 점 표기법 경로를 사용하여 원시 응답의 키를 확인합니다:

```dart
await client.meta.getMeta();

if (client.meta.supports('features.miauth')) {
  // 이 서버에서 MiAuth를 사용할 수 있습니다
}

if (client.meta.supports('policies.canInvite')) {
  // 초대 기능이 활성화되어 있습니다
}
```

### 서버 정보, 통계 및 핑

```dart
// 머신 정보: CPU, 메모리, 디스크
final info = await client.meta.getServerInfo();
print(info.cpu.model);
print(info.mem.total);

// 인스턴스 통계: 사용자 수, 노트 수 등
final stats = await client.meta.getStats();
print(stats.usersCount);
print(stats.notesCount);

// 핑 — 서버 시간을 Unix 타임스탬프 (ms)로 반환
final timestamp = await client.meta.ping();
```

### 엔드포인트

```dart
// 모든 엔드포인트 이름
final endpoints = await client.meta.getEndpoints();

// 특정 엔드포인트의 파라미터
final info = await client.meta.getEndpoint(endpoint: 'notes/create');
if (info != null) {
  for (final param in info.params) {
    print('${param.name}: ${param.type}');
  }
}
```

### 커스텀 이모지

```dart
// 전체 이모지 목록 (카테고리 및 이름 기준 정렬)
final emojis = await client.meta.getEmojis();

// 단축코드로 단일 이모지 상세 정보
final emoji = await client.meta.getEmoji(name: 'blobcat');
print(emoji.url);
```

### 기타 서버 조회

```dart
// 관리자가 고정한 사용자들
final pinned = await client.meta.getPinnedUsers();

// 최근 몇 분간 활성 사용자 수 (60초 캐시)
final count = await client.meta.getOnlineUsersCount();

// 사용 가능한 아바타 장식
final decorations = await client.meta.getAvatarDecorations();

// 사용자 유지율 데이터 — 최대 30개의 일별 기록 (3600초 캐시)
final retention = await client.meta.getRetention();
for (final record in retention) {
  print('${record.createdAt}: ${record.users} registrations');
}
```

## FederationApi

`client.federation`은 서버가 연합하는 인스턴스에 대한 정보를 제공합니다.

### 인스턴스 목록

```dart
// 알려진 모든 연합 인스턴스
final instances = await client.federation.instances(limit: 30);

// 상태 플래그로 필터링
final blocked = await client.federation.instances(blocked: true, limit: 20);
final suspended = await client.federation.instances(suspended: true);
final active = await client.federation.instances(federating: true, limit: 50);

// 팔로워 수 기준 내림차순 정렬
final top = await client.federation.instances(
  sort: '-followers',
  limit: 10,
);
```

사용 가능한 `sort` 값: `+pubSub` / `-pubSub`, `+notes` / `-notes`,
`+users` / `-users`, `+following` / `-following`, `+followers` / `-followers`,
`+firstRetrievedAt` / `-firstRetrievedAt`, `+latestRequestReceivedAt` / `-latestRequestReceivedAt`.

### 인스턴스 상세 정보

```dart
final instance = await client.federation.showInstance(host: 'mastodon.social');
if (instance != null) {
  print(instance.usersCount);
  print(instance.notesCount);
}
```

### 호스트별 팔로워 및 팔로잉

```dart
// 원격 인스턴스에서 팔로우된 관계
final followers = await client.federation.followers(
  host: 'mastodon.social',
  limit: 20,
);

final following = await client.federation.following(
  host: 'mastodon.social',
  limit: 20,
);

// 원격 인스턴스에서 알려진 사용자
final users = await client.federation.users(
  host: 'mastodon.social',
  limit: 20,
);
```

### 연합 통계

```dart
// 팔로워/팔로잉 수 기준 상위 인스턴스
final stats = await client.federation.stats(limit: 10);
print(stats.topSubInstances.first.host);
```

### 원격 사용자 새로고침

```dart
// 원격 사용자의 ActivityPub 프로필 다시 가져오기 (인증 필요)
await client.federation.updateRemoteUser(userId: remoteUserId);
```

## RolesApi

`client.roles`는 공개 역할 정보를 제공합니다.

```dart
// 모든 공개, 탐색 가능한 역할 목록 (인증 필요)
final roles = await client.roles.list();

// 특정 역할 상세 정보 (인증 불필요)
final role = await client.roles.show(roleId: 'roleId123');
print(role.name);
print(role.color);

// 역할에 속한 사용자의 노트 (인증 필요)
final notes = await client.roles.notes(roleId: role.id, limit: 20);

// 역할에 속한 사용자 (인증 불필요)
final members = await client.roles.users(roleId: role.id, limit: 20);
```

모든 목록 메서드는 페이지네이션을 위해 `sinceId`, `untilId`, `sinceDate`, `untilDate`를 지원합니다.

## ChartsApi

`client.charts`는 시계열 데이터를 반환합니다. 모든 메서드는 `span` (`'day'` 또는 `'hour'`), `limit` (1-500, 기본값 30), `offset`을 지원합니다.

```dart
// 지난 30일간 활성 사용자
final activeUsers = await client.charts.getActiveUsers(span: 'day');

// 노트 수 (로컬 및 원격)
final notes = await client.charts.getNotes(span: 'day', limit: 14);

// 사용자 수 (로컬 및 원격)
final users = await client.charts.getUsers(span: 'hour', limit: 24);

// 연합 활동
final fed = await client.charts.getFederation(span: 'day');

// ActivityPub 요청 결과
final ap = await client.charts.getApRequest(span: 'hour', limit: 48);

// 인스턴스별 차트
final inst = await client.charts.getInstance(
  host: 'mastodon.social',
  span: 'day',
  limit: 7,
);

// 사용자별 차트
final userNotes = await client.charts.getUserNotes(
  userId: userId,
  span: 'day',
  limit: 30,
);
```

각 응답은 `Map<String, dynamic>`이며, 리프 값은 `List<num>` 시계열 배열입니다.

## ApApi

`client.ap`는 원격 서버에서 ActivityPub 객체를 가져옵니다 (인증 필요, 요청 한도: 시간당 30회).

```dart
// AP URI에서 사용자 또는 노트 가져오기
final result = await client.ap.show(
  uri: 'https://mastodon.social/users/alice',
);
if (result is ApShowUser) {
  print(result.user.username);
} else if (result is ApShowNote) {
  print(result.note.text);
}

// 원시 AP 객체 가져오기 (관리자 전용)
final raw = await client.ap.get(
  uri: 'https://mastodon.social/users/alice',
);
print(raw['type']); // 예: 'Person'
```
