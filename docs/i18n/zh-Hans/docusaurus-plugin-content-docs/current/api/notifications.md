---
sidebar_position: 3
title: 通知
---

# 通知

`client.notifications` API 管理通知的获取、批量标记已读以及创建自定义通知。

## 获取通知

### 列表

```dart
final notifications = await client.notifications.list(limit: 20);

for (final n in notifications) {
  print('${n.type}: ${n.userId}');
}
```

默认情况下，获取通知时会将其标记为已读。传入 `markAsRead: false` 可禁止此行为：

```dart
final notifications = await client.notifications.list(
  limit: 20,
  markAsRead: false,
);
```

### 分组通知

同一条笔记上的反应和转发会合并为单个条目：

```dart
final grouped = await client.notifications.listGrouped(limit: 20);
```

### 按类型过滤

```dart
// 仅获取提及和反应
final notifications = await client.notifications.list(
  includeTypes: ['mention', 'reaction'],
);

// 除关注外的所有类型
final notifications = await client.notifications.list(
  excludeTypes: ['follow'],
);
```

常见通知类型：`follow`（关注）、`mention`（提及）、`reply`（回复）、`renote`（转发）、`quote`（引用）、`reaction`（反应）、`pollEnded`（投票结束）、`achievementEarned`（获得成就）、`app`（应用）。

### 分页

```dart
// 更早的通知
final older = await client.notifications.list(
  limit: 20,
  untilId: notifications.last.id,
);

// 自上次获取以来的新通知
final newer = await client.notifications.list(
  limit: 20,
  sinceId: notifications.first.id,
);
```

`sinceDate` 和 `untilDate` 接受 Unix 时间戳（毫秒），可作为基于 ID 分页的替代方式。

## 标记已读

### 全部标记为已读

```dart
await client.notifications.markAllAsRead();
```

### 清空所有通知

永久删除所有通知：

```dart
await client.notifications.flush();
```

## 创建通知

### 应用通知

向已认证用户发送来自你的应用的自定义通知。需要 `write:notifications` 权限。

```dart
await client.notifications.create(
  body: 'Your export is ready to download.',
  header: 'Export complete',
  icon: 'https://example.com/icon.png',
);
```

如果省略 `header`，默认使用访问令牌的名称；如果省略 `icon`，默认使用令牌的图标 URL。

### 测试通知

向已认证用户发送测试通知（`type: test`）。适用于验证你的通知处理逻辑是否正常工作。

```dart
await client.notifications.testNotification();
```

`create` 和 `testNotification` 的频率限制均为每分钟 10 次请求。
