---
sidebar_position: 6
title: "채널 및 안테나"
---

# 채널 및 안테나

채널은 노트가 해당 채널 내에서만 표시되는 주제별 공간입니다. 안테나는 설정한 조건에 맞는 노트를 자동으로 수집하는 커스텀 타임라인 필터입니다.

## 채널

`client.channels` API는 모든 채널 작업을 처리합니다. `client.channels.mute` 하위 API는 채널 뮤트를 관리합니다.

### 채널 생성 및 업데이트

```dart
final channel = await client.channels.create(
  name: 'Tech Talk',
  description: 'Discussions about software and technology.',
  color: '#3498db',
);

// 업데이트 — 지정된 필드만 변경됨
await client.channels.update(
  channelId: channel.id,
  name: 'Tech Talk (v2)',
  isArchived: false,
  pinnedNoteIds: [noteId1, noteId2],
);
```

`create`의 선택적 필드: `bannerId` (드라이브 파일 ID), `isSensitive`, `allowRenoteToExternal`.

### 채널 타임라인

```dart
final notes = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
);

// 이전 노트
final older = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
  untilId: notes.last.id,
);
```

모든 타임라인 메서드는 `sinceId`, `sinceDate`, `untilDate`도 지원합니다.

### 팔로우, 즐겨찾기 및 탐색

```dart
await client.channels.follow(channelId: channelId);
await client.channels.unfollow(channelId: channelId);

await client.channels.favorite(channelId: channelId);
await client.channels.unfavorite(channelId: channelId);

// 인증된 사용자가 즐겨찾기한 채널
final favorites = await client.channels.myFavorites();

// 탐색 목록
final featured = await client.channels.featured();
final followed = await client.channels.followed(limit: 20);
final owned    = await client.channels.owned(limit: 20);
```

### 검색

```dart
// 이름과 설명 검색 (기본값)
final results = await client.channels.search(query: 'gaming', limit: 20);

// 이름만 검색
final results = await client.channels.search(
  query: 'gaming',
  type: 'nameOnly',
);
```

## 채널 뮤트

```dart
// 무기한 뮤트
await client.channels.mute.create(channelId: channelId);

// 만료 시간 지정 뮤트 (밀리초 단위 Unix 타임스탬프)
await client.channels.mute.create(
  channelId: channelId,
  expiresAt: DateTime.now()
      .add(const Duration(days: 7))
      .millisecondsSinceEpoch,
);

await client.channels.mute.delete(channelId: channelId);

final muted = await client.channels.mute.list();
```

## 안테나

안테나는 키워드, 사용자, 목록을 기반으로 서버 전체에서 노트를 자동으로 수집합니다.

### 안테나 생성

`keywords`는 외부 OR / 내부 AND 매칭을 사용합니다: 각 내부 목록은 AND 그룹이며, 외부 목록끼리는 OR로 결합됩니다.

```dart
final antenna = await client.antennas.create(
  name: 'Dart news',
  src: 'all',             // 'home' | 'all' | 'users' | 'list' | 'users_blacklist'
  keywords: [
    ['dart', 'flutter'], // "dart" AND "flutter" 둘 다 포함된 노트
    ['misskey'],          // 또는 "misskey"가 포함된 노트
  ],
  excludeKeywords: [['spam']],
  users: [],
  caseSensitive: false,
  withReplies: false,
  withFile: false,
);
```

사용자 목록으로 제한하려면 `src: 'list'`로 설정하고 `userListId`를 전달합니다.

### 안테나 노트 조회

```dart
final notes = await client.antennas.notes(antennaId: antenna.id, limit: 20);

// 페이지네이션
final older = await client.antennas.notes(
  antennaId: antenna.id,
  limit: 20,
  untilId: notes.last.id,
);
```

### 목록 조회, 업데이트 및 삭제

```dart
final antennas = await client.antennas.list();
final detail   = await client.antennas.show(antennaId: antennaId);

// antennaId만 필수이며, 다른 필드는 선택적으로 업데이트됩니다
await client.antennas.update(
  antennaId: antennaId,
  name: 'Dart & Flutter news',
  excludeBots: true,
);

await client.antennas.delete(antennaId: antennaId);
```
