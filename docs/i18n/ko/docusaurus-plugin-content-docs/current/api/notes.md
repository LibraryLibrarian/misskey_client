---
sidebar_position: 1
title: 노트
---

# 노트

`client.notes` API는 노트(게시물)를 조회, 작성, 상호작용하는 기능을 제공합니다.

## 노트 조회

### 단일 노트

```dart
final note = await client.notes.show(noteId: '9xyz');
print(note.text);      // 노트 본문
print(note.user.name); // 작성자 표시 이름
```

### 공개 노트 목록

```dart
final notes = await client.notes.list(limit: 20);
```

`local`, `reply`, `renote`, `withFiles`, `poll` 필터를 사용할 수 있습니다.

### 답글 및 하위 노트

```dart
// 노트에 대한 직접 답글
final replies = await client.notes.replies(noteId: '9xyz', limit: 10);

// 모든 하위 노트 (답글과 인용 리노트)
final children = await client.notes.children(noteId: '9xyz', limit: 10);

// 상위 체인 (조상 노트들)
final ancestors = await client.notes.conversation(noteId: '9xyz', limit: 10);
```

## 타임라인

모든 타임라인 메서드는 페이지네이션을 위해 `limit`, `sinceId`, `untilId`, `sinceDate`, `untilDate`를 지원합니다.

### 홈 타임라인 (인증 필요)

```dart
final notes = await client.notes.timelineHome(limit: 20);
```

### 로컬 타임라인

```dart
final notes = await client.notes.timelineLocal(limit: 20);
```

### 글로벌 타임라인

```dart
final notes = await client.notes.timelineGlobal(limit: 20);
```

### 하이브리드 타임라인 (인증 필요)

```dart
final notes = await client.notes.timelineHybrid(limit: 20);
```

### 커서 기반 페이지네이션

```dart
// 이미 로드된 가장 오래된 노트의 ID를 사용하여 다음 페이지 가져오기
final older = await client.notes.timelineHome(
  limit: 20,
  untilId: notes.last.id,
);

// 마지막으로 로드된 노트 이후의 새로운 노트 가져오기
final newer = await client.notes.timelineHome(
  limit: 20,
  sinceId: notes.first.id,
);
```

## 노트 작성

`text`, `renoteId`, `fileIds`, `pollChoices` 중 적어도 하나는 제공해야 합니다.

### 일반 텍스트

```dart
final note = await client.notes.create(
  text: 'Hello, Misskey!',
  visibility: 'public',
);
print(note.id);
```

### 콘텐츠 경고 포함

```dart
final note = await client.notes.create(
  text: '스포일러가 포함되어 있습니다.',
  cw: '스포일러 주의',
);
```

### 드라이브 파일 첨부

```dart
// 먼저 드라이브에 파일 업로드
final file = await client.drive.files.create(
  bytes: imageBytes,
  filename: 'photo.jpg',
);

// 드라이브 파일 ID를 노트에 첨부
final note = await client.notes.create(
  text: '확인해 보세요!',
  fileIds: [file.id],
);
```

### 투표 포함

```dart
final note = await client.notes.create(
  text: '무엇을 더 좋아하시나요?',
  pollChoices: ['Option A', 'Option B', 'Option C'],
  pollMultiple: false,
  pollExpiredAfter: 86400000, // 밀리초 단위 24시간
);
```

### 답글 및 리노트

```dart
// 답글
final reply = await client.notes.create(
  text: '좋은 지적이에요!',
  replyId: originalNoteId,
);

// 순수 리노트 (텍스트 없음)
final renote = await client.notes.create(renoteId: originalNoteId);

// 인용 리노트
final quote = await client.notes.create(
  text: '이에 대한 제 생각은:',
  renoteId: originalNoteId,
);
```

### 공개 범위 옵션

```dart
// 'public', 'home', 'followers', 'specified'
final note = await client.notes.create(
  text: '팔로워만',
  visibility: 'followers',
);

// 특정 사용자에게 다이렉트 메시지
final dm = await client.notes.create(
  text: '안녕하세요!',
  visibility: 'specified',
  visibleUserIds: [targetUserId],
);
```

## 노트 상호작용

### 리액션

```dart
// 리액션 추가 (유니코드 이모지 또는 커스텀 이모지 단축코드)
await client.notes.reactionsCreate(noteId: noteId, reaction: '👍');
await client.notes.reactionsCreate(noteId: noteId, reaction: ':awesome:');

// 리액션 제거
await client.notes.reactionsDelete(noteId: noteId);

// 노트의 리액션 목록 가져오기
final reactions = await client.notes.reactions(noteId: noteId, limit: 20);
for (final r in reactions) {
  print('${r.reaction}: ${r.user.username}');
}
```

### 리노트

```dart
// 리노트 (텍스트 없음)
await client.notes.create(renoteId: noteId);

// 해당 노트에 대한 자신의 리노트 모두 취소
await client.notes.unrenote(noteId: noteId);

// 리노트한 사용자 목록
final renotes = await client.notes.renotes(noteId: noteId, limit: 20);
```

### 투표

```dart
// choice는 0부터 시작하는 인덱스
await client.notes.pollsVote(noteId: noteId, choice: 0);
```

### 노트 삭제

```dart
await client.notes.delete(noteId: noteId);
```

## 검색

### 전문 검색

```dart
final results = await client.notes.search(
  query: 'Misskey',
  limit: 20,
);
```

사용자나 채널로 필터링:

```dart
final results = await client.notes.search(
  query: 'hello',
  userId: someUserId,
  channelId: someChannelId,
);
```

### 해시태그로 검색

```dart
// 단순 태그 검색
final results = await client.notes.searchByTag(tag: 'misskey');

// 복합 쿼리: (tagA AND tagB) OR tagC
final results = await client.notes.searchByTag(
  queryTags: [
    ['tagA', 'tagB'],
    ['tagC'],
  ],
);
```

## 즐겨찾기 및 임시저장

```dart
// 즐겨찾기 추가 / 제거
await client.notes.favoritesCreate(noteId: noteId);
await client.notes.favoritesDelete(noteId: noteId);

// 즐겨찾기한 노트 가져오기
final favs = await client.account.favorites(limit: 20);

// 임시저장 목록
final drafts = await client.notes.draftsList(limit: 20);

// 임시저장 개수
final count = await client.notes.draftsCount();
```

## 번역

```dart
final translation = await client.notes.translate(
  noteId: noteId,
  targetLang: 'en',
);
print(translation.text);
```
