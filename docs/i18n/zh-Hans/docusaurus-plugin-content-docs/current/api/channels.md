---
sidebar_position: 6
title: "频道与天线"
---

# 频道与天线

频道是话题性空间，笔记仅在该频道内可见。天线是自定义的时间线过滤器，可自动收集符合你设定条件的笔记。

## 频道

`client.channels` API 处理所有频道操作。`client.channels.mute` 子 API 管理频道静音。

### 创建和更新频道

```dart
final channel = await client.channels.create(
  name: 'Tech Talk',
  description: 'Discussions about software and technology.',
  color: '#3498db',
);

// 更新——只有指定的字段会变更
await client.channels.update(
  channelId: channel.id,
  name: 'Tech Talk (v2)',
  isArchived: false,
  pinnedNoteIds: [noteId1, noteId2],
);
```

`create` 的可选字段：`bannerId`（网盘文件 ID）、`isSensitive`、`allowRenoteToExternal`。

### 频道时间线

```dart
final notes = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
);

// 更早的笔记
final older = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
  untilId: notes.last.id,
);
```

所有时间线方法同样支持 `sinceId`、`sinceDate` 和 `untilDate`。

### 关注、收藏与发现

```dart
await client.channels.follow(channelId: channelId);
await client.channels.unfollow(channelId: channelId);

await client.channels.favorite(channelId: channelId);
await client.channels.unfavorite(channelId: channelId);

// 已认证用户收藏的频道
final favorites = await client.channels.myFavorites();

// 发现列表
final featured = await client.channels.featured();
final followed = await client.channels.followed(limit: 20);
final owned    = await client.channels.owned(limit: 20);
```

### 搜索

```dart
// 搜索名称和描述（默认）
final results = await client.channels.search(query: 'gaming', limit: 20);

// 仅搜索名称
final results = await client.channels.search(
  query: 'gaming',
  type: 'nameOnly',
);
```

## 频道静音

```dart
// 永久静音
await client.channels.mute.create(channelId: channelId);

// 设置到期时间的静音（Unix 时间戳，毫秒）
await client.channels.mute.create(
  channelId: channelId,
  expiresAt: DateTime.now()
      .add(const Duration(days: 7))
      .millisecondsSinceEpoch,
);

await client.channels.mute.delete(channelId: channelId);

final muted = await client.channels.mute.list();
```

## 天线

天线根据关键词、用户或列表自动从整个服务器收集笔记。

### 创建天线

`keywords` 使用外层 OR / 内层 AND 匹配：每个内层列表是一个 AND 组，外层列表之间用 OR 连接。

```dart
final antenna = await client.antennas.create(
  name: 'Dart news',
  src: 'all',             // 'home' | 'all' | 'users' | 'list' | 'users_blacklist'
  keywords: [
    ['dart', 'flutter'], // 匹配同时包含 "dart" 和 "flutter" 的笔记
    ['misskey'],          // 或包含 "misskey" 的笔记
  ],
  excludeKeywords: [['spam']],
  users: [],
  caseSensitive: false,
  withReplies: false,
  withFile: false,
);
```

如需限制到某个用户列表，设置 `src: 'list'` 并传入 `userListId`。

### 获取天线笔记

```dart
final notes = await client.antennas.notes(antennaId: antenna.id, limit: 20);

// 分页
final older = await client.antennas.notes(
  antennaId: antenna.id,
  limit: 20,
  untilId: notes.last.id,
);
```

### 列出、更新与删除

```dart
final antennas = await client.antennas.list();
final detail   = await client.antennas.show(antennaId: antennaId);

// 只有 antennaId 是必填的；其他字段按需更新
await client.antennas.update(
  antennaId: antennaId,
  name: 'Dart & Flutter news',
  excludeBots: true,
);

await client.antennas.delete(antennaId: antennaId);
```
