---
sidebar_position: 2
title: 用户
---

# 用户

`client.users` API 提供查找用户、管理关注关系以及处理屏蔽和静音的操作。已认证用户的个人资料管理在 `client.account` 下。

## 获取用户

### 通过用户 ID

```dart
final user = await client.users.showOneByUserId('9abc');
print(user.name);     // 显示名称
print(user.username); // 用户名（不含 @）
print(user.host);     // 本地用户为 null，远程用户为主机名
```

### 通过用户名

```dart
// 本地用户
final user = await client.users.showOneByUsername('alice');

// 远程用户
final user = await client.users.showOneByUsername('alice', host: 'other.example.com');
```

### 批量获取多个用户

```dart
final users = await client.users.showMany(
  userIds: ['9abc', '9def', '9ghi'],
);
```

### 列出用户（目录）

```dart
// 按粉丝数排序的本地用户
final users = await client.users.list(
  limit: 20,
  sort: '+follower',
  origin: 'local',
);
```

`sort` 可用值：`+follower`、`-follower`、`+createdAt`、`-createdAt`、`+updatedAt`、`-updatedAt`。
`origin` 可用值：`local`、`remote`、`combined`。

## 粉丝与关注

```dart
// 某用户的粉丝（通过 ID）
final followers = await client.users.followersByUserId(userId, limit: 20);

// 某用户的粉丝（通过用户名）
final followers = await client.users.followersByUsername('alice', limit: 20);

// 某用户关注的账户
final following = await client.users.followingByUserId(userId, limit: 20);
```

使用 `sinceId` / `untilId` / `sinceDate` / `untilDate` 进行分页。

## 某用户的笔记

```dart
final notes = await client.users.notes(
  userId: userId,
  limit: 20,
  withReplies: false,
  withRenotes: true,
);
```

`withReplies` 和 `withFiles` 不能同时为 `true`（服务器限制）。

## 关注操作

### 关注用户

```dart
final user = await client.following.create(userId: userId);
```

如果目标用户需要关注审批，则发送申请而非立即关注。

### 取消关注

```dart
await client.following.delete(userId: userId);
```

### 更新关注设置

```dart
// 更改特定关注的通知级别
await client.following.update(
  userId: userId,
  notify: 'normal', // 'normal' 或 'none'
  withReplies: true,
);
```

### 移除粉丝

```dart
// 强制移除关注你的人
await client.following.invalidate(userId: userId);
```

### 关注申请

```dart
// 列出待处理的收到的申请
final requests = await client.following.requests.listReceived();

// 接受或拒绝
await client.following.requests.accept(userId: userId);
await client.following.requests.reject(userId: userId);

// 取消你发出的申请
await client.following.requests.cancel(userId: userId);
```

## 屏蔽

```dart
// 屏蔽用户（解除双方的关注关系）
await client.blocking.create(userId: userId);

// 取消屏蔽
await client.blocking.delete(userId: userId);

// 列出你屏蔽的用户
final blocked = await client.blocking.list(limit: 20);
```

## 静音

```dart
// 静音用户
await client.mute.create(userId: userId);

// 设置到期时间的静音（Unix 时间戳，毫秒）
await client.mute.create(userId: userId, expiresAt: expiresAt);

// 取消静音
await client.mute.delete(userId: userId);

// 列出你静音的用户
final muted = await client.mute.list(limit: 20);
```

## 账户管理

已认证用户的个人资料操作在 `client.account` 下。

### 获取自己的个人资料

```dart
final me = await client.account.i();
print(me.name);
print(me.description);
```

### 更新个人资料

```dart
final updated = await client.account.update(
  name: 'Alice',
  description: 'Hello from Misskey!',
  lang: 'en',
);
```

只有指定的字段会被更改，未指定的字段保持不变。

## 用户搜索

```dart
final results = await client.users.search(
  query: 'alice',
  limit: 20,
  origin: 'combined',
);
```

## 用户列表

用户列表可通过 `client.users.lists` 访问：

```dart
// 创建列表
final list = await client.users.lists.create(name: 'Friends');

// 将用户添加到列表
await client.users.lists.push(listId: list.id, userId: userId);

// 从列表中移除用户
await client.users.lists.pull(listId: list.id, userId: userId);

// 获取你的列表
final lists = await client.users.lists.list();

// 获取列表成员
final members = await client.users.lists.getMemberships(listId: list.id);
```
