---
sidebar_position: 8
title: "服务器与联合"
---

# 服务器与联合

本页面介绍用于查询服务器元数据、联合、角色、图表和 ActivityPub 的 API。

## MetaApi

`client.meta` 提供服务器元数据和功能检测。

### 获取元数据

```dart
final meta = await client.meta.getMeta();
print(meta.name);        // 服务器名称
print(meta.description); // 服务器描述
```

首次调用后结果会缓存在内存中。使用 `refresh: true` 可绕过缓存：

```dart
final fresh = await client.meta.getMeta(refresh: true);
```

传入 `detail: false` 可获取轻量级响应（等同于 `MetaLite`）：

```dart
final lite = await client.meta.getMeta(detail: false);
```

### 功能检测

在使用 `supports()` 前至少需要调用一次 `getMeta()`。它通过点分隔路径检查原始响应中的键：

```dart
await client.meta.getMeta();

if (client.meta.supports('features.miauth')) {
  // 该服务器支持 MiAuth
}

if (client.meta.supports('policies.canInvite')) {
  // 邀请功能已启用
}
```

### 服务器信息、统计与 Ping

```dart
// 机器信息：CPU、内存、磁盘
final info = await client.meta.getServerInfo();
print(info.cpu.model);
print(info.mem.total);

// 实例统计：用户数、笔记数等
final stats = await client.meta.getStats();
print(stats.usersCount);
print(stats.notesCount);

// Ping——以 Unix 时间戳（毫秒）返回服务器时间
final timestamp = await client.meta.ping();
```

### 端点

```dart
// 所有端点名称
final endpoints = await client.meta.getEndpoints();

// 特定端点的参数
final info = await client.meta.getEndpoint(endpoint: 'notes/create');
if (info != null) {
  for (final param in info.params) {
    print('${param.name}: ${param.type}');
  }
}
```

### 自定义表情

```dart
// 完整表情列表（按分类和名称排序）
final emojis = await client.meta.getEmojis();

// 通过短代码获取单个表情的详细信息
final emoji = await client.meta.getEmoji(name: 'blobcat');
print(emoji.url);
```

### 其他服务器查询

```dart
// 管理员置顶的用户
final pinned = await client.meta.getPinnedUsers();

// 最近几分钟内活跃的用户数（缓存 60 秒）
final count = await client.meta.getOnlineUsersCount();

// 可用的头像装饰
final decorations = await client.meta.getAvatarDecorations();

// 用户留存数据——最多 30 条每日记录（缓存 3600 秒）
final retention = await client.meta.getRetention();
for (final record in retention) {
  print('${record.createdAt}: ${record.users} registrations');
}
```

## FederationApi

`client.federation` 提供关于服务器所联合的实例的信息。

### 列出实例

```dart
// 所有已知的联合实例
final instances = await client.federation.instances(limit: 30);

// 按状态标志过滤
final blocked = await client.federation.instances(blocked: true, limit: 20);
final suspended = await client.federation.instances(suspended: true);
final active = await client.federation.instances(federating: true, limit: 50);

// 按粉丝数降序排序
final top = await client.federation.instances(
  sort: '-followers',
  limit: 10,
);
```

可用的 `sort` 值：`+pubSub` / `-pubSub`、`+notes` / `-notes`、
`+users` / `-users`、`+following` / `-following`、`+followers` / `-followers`、
`+firstRetrievedAt` / `-firstRetrievedAt`、`+latestRequestReceivedAt` / `-latestRequestReceivedAt`。

### 实例详情

```dart
final instance = await client.federation.showInstance(host: 'mastodon.social');
if (instance != null) {
  print(instance.usersCount);
  print(instance.notesCount);
}
```

### 某主机的粉丝与关注

```dart
// 从远程实例关注的关系
final followers = await client.federation.followers(
  host: 'mastodon.social',
  limit: 20,
);

final following = await client.federation.following(
  host: 'mastodon.social',
  limit: 20,
);

// 来自远程实例的已知用户
final users = await client.federation.users(
  host: 'mastodon.social',
  limit: 20,
);
```

### 联合统计

```dart
// 按粉丝/关注数排名的顶级实例
final stats = await client.federation.stats(limit: 10);
print(stats.topSubInstances.first.host);
```

### 刷新远程用户

```dart
// 重新获取远程用户的 ActivityPub 个人资料（需要认证）
await client.federation.updateRemoteUser(userId: remoteUserId);
```

## RolesApi

`client.roles` 公开公开的角色信息。

```dart
// 列出所有公开的、可探索的角色（需要认证）
final roles = await client.roles.list();

// 特定角色的详情（无需认证）
final role = await client.roles.show(roleId: 'roleId123');
print(role.name);
print(role.color);

// 属于某角色的用户发布的笔记（需要认证）
final notes = await client.roles.notes(roleId: role.id, limit: 20);

// 属于某角色的用户（无需认证）
final members = await client.roles.users(roleId: role.id, limit: 20);
```

所有列表方法均支持 `sinceId`、`untilId`、`sinceDate` 和 `untilDate` 进行分页。

## ChartsApi

`client.charts` 返回时间序列数据。所有方法均接受 `span`（`'day'` 或 `'hour'`）、
`limit`（1-500，默认 30）和 `offset` 参数。

```dart
// 过去 30 天的活跃用户数
final activeUsers = await client.charts.getActiveUsers(span: 'day');

// 笔记数量（本地和远程）
final notes = await client.charts.getNotes(span: 'day', limit: 14);

// 用户数量（本地和远程）
final users = await client.charts.getUsers(span: 'hour', limit: 24);

// 联合活动
final fed = await client.charts.getFederation(span: 'day');

// ActivityPub 请求结果
final ap = await client.charts.getApRequest(span: 'hour', limit: 48);

// 按实例的图表
final inst = await client.charts.getInstance(
  host: 'mastodon.social',
  span: 'day',
  limit: 7,
);

// 按用户的图表
final userNotes = await client.charts.getUserNotes(
  userId: userId,
  span: 'day',
  limit: 30,
);
```

每个响应是一个 `Map<String, dynamic>`，其中叶值为 `List<num>` 时间序列数组。

## ApApi

`client.ap` 从远程服务器解析 ActivityPub 对象（需要认证，频率限制：每小时 30 次）。

```dart
// 从 AP URI 解析用户或笔记
final result = await client.ap.show(
  uri: 'https://mastodon.social/users/alice',
);
if (result is ApShowUser) {
  print(result.user.username);
} else if (result is ApShowNote) {
  print(result.note.text);
}

// 获取原始 AP 对象（仅限管理员）
final raw = await client.ap.get(
  uri: 'https://mastodon.social/users/alice',
);
print(raw['type']); // 如 'Person'
```
