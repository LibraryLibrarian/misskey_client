---
sidebar_position: 9
title: "其他 API"
---

# 其他 API

本页面介绍聊天、公告、话题标签、邀请码和 Service Worker 推送通知。

## ChatApi

`client.chat` 提供私信和群组房间消息功能。所有聊天端点均需要认证。

### 历史记录与已读状态

```dart
// 最近的私信对话历史
final dmHistory = await client.chat.history(limit: 10);

// 最近的房间消息历史
final roomHistory = await client.chat.history(limit: 10, room: true);

// 将所有消息标记为已读
await client.chat.readAll();
```

### 私信

```dart
// 向用户发送消息
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: 'Hello!',
);

// 附加网盘文件
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: 'Here is the file.',
  fileId: driveFileId,
);

// 删除消息
await client.chat.messages.delete(messageId: msg.id);

// 对消息添加回应
await client.chat.messages.react(messageId: msg.id, reaction: ':heart:');

// 取消回应
await client.chat.messages.unreact(messageId: msg.id, reaction: ':heart:');
```

### 消息时间线

```dart
// 与某用户的私信历史（基于游标的分页）
final messages = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
);

// 获取更早的消息
final older = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
  untilId: messages.last.id,
);

// 房间消息时间线
final roomMessages = await client.chat.messages.roomTimeline(
  roomId: roomId,
  limit: 20,
);
```

### 消息搜索

```dart
final results = await client.chat.messages.search(
  query: 'meeting',
  limit: 20,
  userId: targetUserId, // 可选：限制到某个对话
);
```

### 聊天房间

```dart
// 创建房间
final room = await client.chat.rooms.create(
  name: 'Project Alpha',
  description: 'Coordination channel',
);

// 更新房间详情
await client.chat.rooms.update(
  roomId: room.id,
  name: 'Project Alpha — Active',
);

// 删除房间
await client.chat.rooms.delete(roomId: room.id);

// 加入和离开
await client.chat.rooms.join(roomId: room.id);
await client.chat.rooms.leave(roomId: room.id);

// 静音/取消静音房间
await client.chat.rooms.setMute(roomId: room.id, mute: true);

// 成员列表
final members = await client.chat.rooms.members(roomId: room.id, limit: 30);

// 你拥有的房间
final owned = await client.chat.rooms.owned(limit: 20);

// 你已加入的房间
final joined = await client.chat.rooms.joining(limit: 20);
```

### 房间邀请

```dart
// 邀请用户加入房间
await client.chat.rooms.invitationsCreate(
  roomId: room.id,
  userId: targetUserId,
);

// 列出收到的邀请
final inbox = await client.chat.rooms.invitationsInbox(limit: 20);

// 列出某房间发出的邀请
final outbox = await client.chat.rooms.invitationsOutbox(
  roomId: room.id,
  limit: 20,
);

// 忽略收到的邀请
await client.chat.rooms.invitationsIgnore(roomId: room.id);
```

## AnnouncementsApi

`client.announcements` 获取服务器公告。认证为可选；已认证时，每个条目会包含 `isRead` 标志。

```dart
// 活跃中的公告（默认）
final active = await client.announcements.list(limit: 10);

// 包含已停用的公告
final all = await client.announcements.list(isActive: false, limit: 20);

// 单条公告的详情
final ann = await client.announcements.show(announcementId: ann.id);
print(ann.title);
print(ann.text);
```

使用 `sinceId`、`untilId`、`sinceDate` 和 `untilDate` 进行分页。

### 标记为已读

通过 `client.account` 将公告标记为已读：

```dart
await client.account.readAnnouncement(announcementId: ann.id);
```

## HashtagsApi

`client.hashtags` 提供话题标签查询和趋势数据。无需认证。

### 列出与搜索

```dart
// 按发布该话题标签的用户数排序
final tags = await client.hashtags.list(
  sort: '+mentionedUsers',
  limit: 20,
);

// 前缀搜索——返回标签名称字符串列表
final suggestions = await client.hashtags.search(
  query: 'miss',
  limit: 10,
);
```

可用的 `sort` 值：`+mentionedUsers` / `-mentionedUsers`、
`+mentionedLocalUsers` / `-mentionedLocalUsers`、
`+mentionedRemoteUsers` / `-mentionedRemoteUsers`、
`+attachedUsers` / `-attachedUsers`、
`+attachedLocalUsers` / `-attachedLocalUsers`、
`+attachedRemoteUsers` / `-attachedRemoteUsers`。

### 标签详情与趋势

```dart
// 单个标签的详细统计
final tag = await client.hashtags.show(tag: 'misskey');
print(tag.mentionedUsersCount);

// 趋势标签（最多 10 个，缓存 60 秒）
final trending = await client.hashtags.trend();
for (final t in trending) {
  print('${t.tag}: ${t.chart}');
}
```

### 某标签的用户

```dart
final users = await client.hashtags.users(
  tag: 'misskey',
  sort: '+follower',
  limit: 20,
  origin: 'local', // 'local', 'remote', 或 'combined'
  state: 'alive',  // 'all' 或 'alive'
);
```

## InviteApi

`client.invite` 管理仅限邀请的服务器上的邀请码。所有端点均需要认证和 `canInvite` 角色策略。

```dart
// 创建邀请码
final code = await client.invite.create();
print(code.code);

// 查看剩余配额（null 表示无限制）
final remaining = await client.invite.limit();
if (remaining != null) {
  print('$remaining invite(s) remaining');
}

// 列出你发出的邀请码
final codes = await client.invite.list(limit: 20);

// 删除邀请码
await client.invite.delete(inviteId: code.id);
```

## SwApi

`client.sw` 管理 Service Worker 推送通知订阅。所有端点均需要认证。

### 注册

```dart
final registration = await client.sw.register(
  endpoint: 'https://push.example.com/subscribe/abc123',
  auth: 'auth-secret',
  publickey: 'vapid-public-key',
);
print(registration.state); // 'subscribed' 或 'already-subscribed'
```

传入 `sendReadMessage: true` 可同时接收已读消息通知。

### 查看注册状态

```dart
final sub = await client.sw.showRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
if (sub != null) {
  print(sub.sendReadMessage);
}
```

### 更新设置

```dart
await client.sw.updateRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
  sendReadMessage: false,
);
```

### 取消注册

```dart
await client.sw.unregister(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
```
