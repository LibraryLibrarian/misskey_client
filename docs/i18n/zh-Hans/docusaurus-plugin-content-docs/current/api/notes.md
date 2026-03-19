---
sidebar_position: 1
title: 笔记
---

# 笔记

`client.notes` API 提供获取、创建笔记（帖子）以及与笔记交互的操作。

## 获取笔记

### 单条笔记

```dart
final note = await client.notes.show(noteId: '9xyz');
print(note.text);      // 笔记正文
print(note.user.name); // 作者显示名称
```

### 公开笔记列表

```dart
final notes = await client.notes.list(limit: 20);
```

支持 `local`、`reply`、`renote`、`withFiles` 和 `poll` 过滤器。

### 回复与子笔记

```dart
// 对某条笔记的直接回复
final replies = await client.notes.replies(noteId: '9xyz', limit: 10);

// 所有子笔记（回复和引用转发）
final children = await client.notes.children(noteId: '9xyz', limit: 10);

// 父链（祖先笔记）
final ancestors = await client.notes.conversation(noteId: '9xyz', limit: 10);
```

## 时间线

所有时间线方法均支持 `limit`、`sinceId`、`untilId`、`sinceDate` 和 `untilDate` 参数用于分页。

### 主页时间线（需要认证）

```dart
final notes = await client.notes.timelineHome(limit: 20);
```

### 本地时间线

```dart
final notes = await client.notes.timelineLocal(limit: 20);
```

### 全局时间线

```dart
final notes = await client.notes.timelineGlobal(limit: 20);
```

### 混合时间线（需要认证）

```dart
final notes = await client.notes.timelineHybrid(limit: 20);
```

### 基于游标的分页

```dart
// 使用已加载笔记中最旧的 ID 获取下一页
final older = await client.notes.timelineHome(
  limit: 20,
  untilId: notes.last.id,
);

// 获取自上次加载笔记以来的新笔记
final newer = await client.notes.timelineHome(
  limit: 20,
  sinceId: notes.first.id,
);
```

## 创建笔记

`text`、`renoteId`、`fileIds` 或 `pollChoices` 中至少需要提供一个。

### 纯文本

```dart
final note = await client.notes.create(
  text: 'Hello, Misskey!',
  visibility: 'public',
);
print(note.id);
```

### 带内容警告

```dart
final note = await client.notes.create(
  text: 'This contains spoilers.',
  cw: 'Spoiler warning',
);
```

### 附带网盘文件

```dart
// 先上传文件到网盘
final file = await client.drive.files.create(
  bytes: imageBytes,
  filename: 'photo.jpg',
);

// 将网盘文件 ID 附加到笔记
final note = await client.notes.create(
  text: 'Check this out!',
  fileIds: [file.id],
);
```

### 带投票

```dart
final note = await client.notes.create(
  text: 'What do you prefer?',
  pollChoices: ['Option A', 'Option B', 'Option C'],
  pollMultiple: false,
  pollExpiredAfter: 86400000, // 24 小时（毫秒）
);
```

### 回复和转发

```dart
// 回复
final reply = await client.notes.create(
  text: 'Great point!',
  replyId: originalNoteId,
);

// 纯转发（无文字）
final renote = await client.notes.create(renoteId: originalNoteId);

// 引用转发
final quote = await client.notes.create(
  text: 'My thoughts on this:',
  renoteId: originalNoteId,
);
```

### 可见性选项

```dart
// 'public', 'home', 'followers', 'specified'
final note = await client.notes.create(
  text: 'Followers only',
  visibility: 'followers',
);

// 私信给指定用户
final dm = await client.notes.create(
  text: 'Hey!',
  visibility: 'specified',
  visibleUserIds: [targetUserId],
);
```

## 笔记互动

### 回应

```dart
// 添加回应（Unicode 表情或自定义表情短代码）
await client.notes.reactionsCreate(noteId: noteId, reaction: '👍');
await client.notes.reactionsCreate(noteId: noteId, reaction: ':awesome:');

// 取消你的回应
await client.notes.reactionsDelete(noteId: noteId);

// 获取某条笔记上的回应
final reactions = await client.notes.reactions(noteId: noteId, limit: 20);
for (final r in reactions) {
  print('${r.reaction}: ${r.user.username}');
}
```

### 转发

```dart
// 转发（无文字）
await client.notes.create(renoteId: noteId);

// 取消你对某条笔记的所有转发
await client.notes.unrenote(noteId: noteId);

// 列出转发该笔记的用户
final renotes = await client.notes.renotes(noteId: noteId, limit: 20);
```

### 投票

```dart
// choice 是从零开始的索引
await client.notes.pollsVote(noteId: noteId, choice: 0);
```

### 删除笔记

```dart
await client.notes.delete(noteId: noteId);
```

## 搜索

### 全文搜索

```dart
final results = await client.notes.search(
  query: 'Misskey',
  limit: 20,
);
```

按用户或频道过滤：

```dart
final results = await client.notes.search(
  query: 'hello',
  userId: someUserId,
  channelId: someChannelId,
);
```

### 按话题标签搜索

```dart
// 简单标签搜索
final results = await client.notes.searchByTag(tag: 'misskey');

// 复杂查询：(tagA AND tagB) OR tagC
final results = await client.notes.searchByTag(
  queryTags: [
    ['tagA', 'tagB'],
    ['tagC'],
  ],
);
```

## 收藏与草稿

```dart
// 添加 / 取消收藏
await client.notes.favoritesCreate(noteId: noteId);
await client.notes.favoritesDelete(noteId: noteId);

// 获取你收藏的笔记
final favs = await client.account.favorites(limit: 20);

// 列出草稿
final drafts = await client.notes.draftsList(limit: 20);

// 草稿数量
final count = await client.notes.draftsCount();
```

## 翻译

```dart
final translation = await client.notes.translate(
  noteId: noteId,
  targetLang: 'en',
);
print(translation.text);
```
