---
sidebar_position: 7
title: "콘텐츠"
---

# 콘텐츠

이 페이지에서는 네 가지 콘텐츠 관련 API를 다룹니다: 노트를 북마크하는 클립, AiScript 미니앱인 Play (Flash), 사진 컬렉션을 위한 갤러리, 리치 텍스트 문서를 위한 페이지입니다.

## 클립

클립은 북마크한 노트의 이름이 붙은 컬렉션입니다.

```dart
final clip = await client.clips.create(
  name: 'Interesting reads',
  isPublic: true,
  description: '다시 보고 싶은 노트들.',
);

// 노트 추가 / 제거
await client.clips.addNote(clipId: clip.id, noteId: noteId);
await client.clips.removeNote(clipId: clip.id, noteId: noteId);

// 클립 내 노트 (검색 및 페이지네이션 지원)
final notes = await client.clips.notes(clipId: clip.id, limit: 20);
final found = await client.clips.notes(clipId: clip.id, search: 'Misskey');

// 내 클립 목록
final clips = await client.clips.list(limit: 20);

// 클립 즐겨찾기
await client.clips.favorite(clipId: clip.id);
await client.clips.unfavorite(clipId: clip.id);
final favorites = await client.clips.myFavorites();

// 업데이트 및 삭제
await client.clips.update(clipId: clip.id, name: 'Must-reads');
await client.clips.delete(clipId: clip.id);
```

## Flash

Play (Flash라고도 함)는 사용자가 AiScript로 구동되는 작은 미니앱을 만들고 실행할 수 있게 해줍니다.

### Flash 생성

```dart
final flash = await client.flash.create(
  title: 'Hello World',
  summary: '간단한 인사 앱입니다.',
  script: 'Mk:dialog("Hello", "Hello, World!", "info")',
  permissions: [],
  visibility: 'public', // 'public' 또는 'private'
);
```

### 조회 및 검색

```dart
// ID로 단일 Flash 조회 (인증 불필요)
final flash = await client.flash.show(flashId: flashId);

// 내 Flash 목록
final myFlashes = await client.flash.my(limit: 20);

// 추천 (오프셋 기반 페이지네이션)
final featured = await client.flash.featured(limit: 10, offset: 0);

// 검색
final results = await client.flash.search(query: 'game', limit: 10);
```

### 좋아요, 업데이트 및 삭제

```dart
await client.flash.like(flashId: flashId);
await client.flash.unlike(flashId: flashId);
final liked = await client.flash.myLikes(limit: 20);

await client.flash.update(flashId: flash.id, title: 'Hello World v2');
await client.flash.delete(flashId: flash.id);
```

## 갤러리

갤러리 게시물은 드라이브 파일(이미지, 동영상)의 큐레이션된 컬렉션입니다.

### 게시물 탐색

```dart
// 추천 (순위 캐시, TTL 30분)
final featured = await client.gallery.featured(limit: 10);

// 인기순 (좋아요 수 기준)
final popular = await client.gallery.popular();

// 모든 게시물, 최신순 — untilId로 페이지네이션
final posts = await client.gallery.posts(limit: 20);
final older = await client.gallery.posts(limit: 20, untilId: posts.last.id);

// 단일 게시물
final post = await client.gallery.postsShow(postId: postId);
```

### 게시물 작성 및 관리

`fileIds`는 1개에서 32개의 고유한 드라이브 파일 ID를 받습니다.

```dart
final post = await client.gallery.postsCreate(
  title: '여름 사진',
  fileIds: [fileId1, fileId2, fileId3],
  description: '여행에서 찍은 몇 장의 사진.',
);

await client.gallery.postsUpdate(
  postId: post.id,
  title: '2025 여름 사진',
);

await client.gallery.postsDelete(postId: post.id);

await client.gallery.postsLike(postId: postId);
await client.gallery.postsUnlike(postId: postId);
```

## 페이지

페이지는 콘텐츠 블록과 AiScript 변수로 구성된 리치 문서입니다.

### 페이지 조회

```dart
// ID로 조회 (인증 불필요)
final page = await client.pages.showById(pageId: pageId);

// 사용자명과 URL 경로명으로 조회 (인증 불필요)
final page = await client.pages.showByName(
  name: 'my-first-page',
  username: 'alice',
);

// 추천 페이지 (좋아요 수 기준)
final featured = await client.pages.featured();
```

### 페이지 생성

`content`는 블록 객체의 목록이며, `variables`는 변수 정의의 목록이고, `script`는 페이지 로드 시 실행되는 AiScript입니다.

```dart
final page = await client.pages.create(
  title: 'My First Page',
  name: 'my-first-page', // URL 경로명 — 사용자당 고유해야 함
  content: [
    {'type': 'text', 'text': 'Welcome to my page!'},
  ],
  variables: [],
  script: '',
  summary: '소개글입니다.',
);
```

### 업데이트, 삭제 및 좋아요

```dart
await client.pages.update(
  pageId: page.id,
  title: 'Updated Title',
  content: [{'type': 'text', 'text': 'New content.'}],
);

await client.pages.delete(pageId: page.id);

await client.pages.like(pageId: pageId);
await client.pages.unlike(pageId: pageId);
```
