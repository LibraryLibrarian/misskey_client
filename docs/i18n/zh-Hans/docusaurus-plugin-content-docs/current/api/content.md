---
sidebar_position: 7
title: "内容"
---

# 内容

本页面介绍四个内容相关的 API：用于收藏笔记的便签、用于 AiScript 小程序的 Play（Flash）、用于照片集合的图库，以及用于富文本文档的页面。

## 便签

便签是收藏笔记的命名集合。

```dart
final clip = await client.clips.create(
  name: 'Interesting reads',
  isPublic: true,
  description: 'Notes I want to revisit.',
);

// 添加 / 移除笔记
await client.clips.addNote(clipId: clip.id, noteId: noteId);
await client.clips.removeNote(clipId: clip.id, noteId: noteId);

// 便签中的笔记（支持搜索和分页）
final notes = await client.clips.notes(clipId: clip.id, limit: 20);
final found = await client.clips.notes(clipId: clip.id, search: 'Misskey');

// 列出你的便签
final clips = await client.clips.list(limit: 20);

// 收藏便签
await client.clips.favorite(clipId: clip.id);
await client.clips.unfavorite(clipId: clip.id);
final favorites = await client.clips.myFavorites();

// 更新和删除
await client.clips.update(clipId: clip.id, name: 'Must-reads');
await client.clips.delete(clipId: clip.id);
```

## Play（Flash）

Play（Flash）允许用户创建和运行由 AiScript 驱动的小程序。

### 创建 Flash

```dart
final flash = await client.flash.create(
  title: 'Hello World',
  summary: 'A simple greeting app.',
  script: 'Mk:dialog("Hello", "Hello, World!", "info")',
  permissions: [],
  visibility: 'public', // 'public' 或 'private'
);
```

### 获取与搜索

```dart
// 通过 ID 获取单个 Flash（无需认证）
final flash = await client.flash.show(flashId: flashId);

// 你的 Flash
final myFlashes = await client.flash.my(limit: 20);

// 精选（基于偏移量的分页）
final featured = await client.flash.featured(limit: 10, offset: 0);

// 搜索
final results = await client.flash.search(query: 'game', limit: 10);
```

### 点赞、更新与删除

```dart
await client.flash.like(flashId: flashId);
await client.flash.unlike(flashId: flashId);
final liked = await client.flash.myLikes(limit: 20);

await client.flash.update(flashId: flash.id, title: 'Hello World v2');
await client.flash.delete(flashId: flash.id);
```

## 图库

图库帖子是精心策划的网盘文件（图片、视频）集合。

### 浏览帖子

```dart
// 精选（排名缓存，TTL 30 分钟）
final featured = await client.gallery.featured(limit: 10);

// 热门（按点赞数排序）
final popular = await client.gallery.popular();

// 所有帖子，最新在前——使用 untilId 分页
final posts = await client.gallery.posts(limit: 20);
final older = await client.gallery.posts(limit: 20, untilId: posts.last.id);

// 单个帖子
final post = await client.gallery.postsShow(postId: postId);
```

### 创建和管理帖子

`fileIds` 接受 1 到 32 个唯一的网盘文件 ID。

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

## 页面

页面是由内容块和 AiScript 变量组成的富文档。

### 获取页面

```dart
// 通过 ID（无需认证）
final page = await client.pages.showById(pageId: pageId);

// 通过用户名和 URL 路径名（无需认证）
final page = await client.pages.showByName(
  name: 'my-first-page',
  username: 'alice',
);

// 精选页面（按点赞数排序）
final featured = await client.pages.featured();
```

### 创建页面

`content` 是块对象的列表；`variables` 是变量定义的列表；`script` 是页面加载时运行的 AiScript。

```dart
final page = await client.pages.create(
  title: 'My First Page',
  name: 'my-first-page', // URL 路径名——每个用户必须唯一
  content: [
    {'type': 'text', 'text': 'Welcome to my page!'},
  ],
  variables: [],
  script: '',
  summary: 'An introduction.',
);
```

### 更新、删除与点赞

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
