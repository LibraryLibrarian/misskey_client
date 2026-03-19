---
sidebar_position: 7
title: "コンテンツ"
---

# コンテンツ

このページではコンテンツ系の4つの API を説明します。ノートのブックマークを管理するクリップ、AiScript 製ミニアプリの Play（Flash）、写真コレクションのギャラリー、リッチテキスト文書のページを扱います。

## クリップ

クリップはノートのブックマークを名前付きでまとめる機能です。

```dart
final clip = await client.clips.create(
  name: 'Interesting reads',
  isPublic: true,
  description: 'Notes I want to revisit.',
);

// ノートの追加・削除
await client.clips.addNote(clipId: clip.id, noteId: noteId);
await client.clips.removeNote(clipId: clip.id, noteId: noteId);

// クリップ内のノート一覧（検索・ページネーション対応）
final notes = await client.clips.notes(clipId: clip.id, limit: 20);
final found = await client.clips.notes(clipId: clip.id, search: 'Misskey');

// 自分のクリップ一覧
final clips = await client.clips.list(limit: 20);

// クリップのお気に入り
await client.clips.favorite(clipId: clip.id);
await client.clips.unfavorite(clipId: clip.id);
final favorites = await client.clips.myFavorites();

// 更新・削除
await client.clips.update(clipId: clip.id, name: 'Must-reads');
await client.clips.delete(clipId: clip.id);
```

## Play

Play（旧 API 名 Flash）は AiScript 製のミニアプリを作成・実行する機能です。

### Play の作成

```dart
final flash = await client.flash.create(
  title: 'Hello World',
  summary: 'A simple greeting app.',
  script: 'Mk:dialog("Hello", "Hello, World!", "info")',
  permissions: [],
  visibility: 'public', // 'public' または 'private'
);
```

### 取得と検索

```dart
// IDで取得（認証不要）
final flash = await client.flash.show(flashId: flashId);

// 自分の Flash 一覧
final myFlashes = await client.flash.my(limit: 20);

// 注目の Flash（オフセットページング）
final featured = await client.flash.featured(limit: 10, offset: 0);

// 検索
final results = await client.flash.search(query: 'game', limit: 10);
```

### いいね・更新・削除

```dart
await client.flash.like(flashId: flashId);
await client.flash.unlike(flashId: flashId);
final liked = await client.flash.myLikes(limit: 20);

await client.flash.update(flashId: flash.id, title: 'Hello World v2');
await client.flash.delete(flashId: flash.id);
```

## ギャラリー

ギャラリー投稿は Drive ファイル（画像・動画）のキュレーションコレクションです。

### 投稿の閲覧

```dart
// 注目の投稿（ランキングキャッシュ、TTL 30分）
final featured = await client.gallery.featured(limit: 10);

// 人気の投稿（いいね数順）
final popular = await client.gallery.popular();

// 全投稿（新しい順）— untilId でページネーション
final posts = await client.gallery.posts(limit: 20);
final older = await client.gallery.posts(limit: 20, untilId: posts.last.id);

// 投稿の詳細
final post = await client.gallery.postsShow(postId: postId);
```

### 投稿の作成と管理

`fileIds` には Drive ファイル ID を 1〜32 個指定できます。

```dart
final post = await client.gallery.postsCreate(
  title: 'Summer photos',
  fileIds: [fileId1, fileId2, fileId3],
  description: 'A few shots from the trip.',
);

await client.gallery.postsUpdate(
  postId: post.id,
  title: 'Summer 2025 photos',
);

await client.gallery.postsDelete(postId: post.id);

await client.gallery.postsLike(postId: postId);
await client.gallery.postsUnlike(postId: postId);
```

## ページ

ページはコンテンツブロックと AiScript 変数で構成されるリッチドキュメントです。

### ページの取得

```dart
// ID で取得（認証不要）
final page = await client.pages.showById(pageId: pageId);

// ユーザー名と URL パス名で取得（認証不要）
final page = await client.pages.showByName(
  name: 'my-first-page',
  username: 'alice',
);

// 注目のページ（いいね数順）
final featured = await client.pages.featured();
```

### ページの作成

`content` はブロックオブジェクトのリスト、`variables` は変数定義のリスト、`script` はページ読み込み時に実行される AiScript です。

```dart
final page = await client.pages.create(
  title: 'My First Page',
  name: 'my-first-page', // URL パス名 — ユーザーごとに一意
  content: [
    {'type': 'text', 'text': 'Welcome to my page!'},
  ],
  variables: [],
  script: '',
  summary: 'An introduction.',
);
```

### 更新・削除・いいね

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
