---
sidebar_position: 5
title: "社交"
---

# 社交

社交 API 涵盖关注关系、关注申请、屏蔽和静音。所有操作均需要认证。

## 关注（`client.following`）

### 关注用户

```dart
final user = await client.following.create(userId: userId);
```

如果目标用户需要关注审批，则发送申请而非立即关注。该方法返回更新后的 `MisskeyUser`。

传入 `withReplies: true` 可在你的时间线中包含被关注用户的回复：

```dart
await client.following.create(userId: userId, withReplies: true);
```

### 取消关注

```dart
await client.following.delete(userId: userId);
```

### 更新关注设置

更改单个关注关系的通知和回复显示设置。

```dart
await client.following.update(
  userId: userId,
  notify: 'normal',   // 'normal' 或 'none'
  withReplies: true,
);
```

### 批量更新所有关注

将相同的设置应用于你关注的所有账户。频率限制：每小时 10 次请求。

```dart
await client.following.updateAll(notify: 'none', withReplies: false);
```

### 移除粉丝

强制移除关注你的人。

```dart
await client.following.invalidate(userId: userId);
```

## 关注申请（`client.following.requests`）

### 收到的申请

```dart
// 列出发给你的待处理申请
final incoming = await client.following.requests.list(limit: 20);
for (final req in incoming) {
  print(req.follower.username);
}

// 接受申请
await client.following.requests.accept(userId: userId);

// 拒绝申请
await client.following.requests.reject(userId: userId);
```

### 发出的申请

```dart
// 列出你发出的申请
final sent = await client.following.requests.sent(limit: 20);

// 取消你发出的申请
await client.following.requests.cancel(userId: userId);
```

所有列表方法均支持 `sinceId` / `untilId` 和 `sinceDate` / `untilDate` 进行分页。

## 屏蔽（`client.blocking`）

屏蔽会解除你与目标用户之间的双向关注关系。被屏蔽的用户无法关注你，你也不会看到他们的内容。

### 屏蔽用户

```dart
await client.blocking.create(userId: userId);
```

### 取消屏蔽

```dart
await client.blocking.delete(userId: userId);
```

### 列出被屏蔽的用户

```dart
final blocked = await client.blocking.list(limit: 20);
for (final b in blocked) {
  print(b.blockee.username);
}
```

使用 `sinceId` / `untilId` 或 `sinceDate` / `untilDate` 进行分页。

## 静音（`client.mute`）

静音会从你的时间线中隐藏某用户的笔记、转发和回应。与屏蔽不同，被静音的用户不会知道自己被静音了。

### 静音用户

```dart
// 永久静音
await client.mute.create(userId: userId);
```

### 定时静音

传入 Unix 时间戳（毫秒）可让静音自动到期。

```dart
// 静音 24 小时
final expiresAt = DateTime.now()
    .add(const Duration(hours: 24))
    .millisecondsSinceEpoch;

await client.mute.create(userId: userId, expiresAt: expiresAt);
```

### 取消静音

```dart
await client.mute.delete(userId: userId);
```

### 列出被静音的用户

```dart
final muted = await client.mute.list(limit: 20);
for (final m in muted) {
  print(m.mutee.username);
}
```

## 转发静音（`client.renoteMute`）

转发静音仅屏蔽某用户在你时间线中的转发，其原创笔记仍可见。当你希望关注某人的原创内容但不希望看到其转发内容时，这非常有用。

### 对用户开启转发静音

```dart
await client.renoteMute.create(userId: userId);
```

### 取消转发静音

```dart
await client.renoteMute.delete(userId: userId);
```

### 列出开启了转发静音的用户

```dart
final renoteMuted = await client.renoteMute.list(limit: 20);
for (final rm in renoteMuted) {
  print(rm.mutee.username);
}
```

使用 `sinceId` / `untilId` 或 `sinceDate` / `untilDate` 进行分页。

## 对比：普通静音 vs 转发静音

| | 普通静音 | 转发静音 |
|---|---|---|
| 隐藏原创笔记 | 是 | 否 |
| 隐藏转发 | 是 | 是 |
| 通知目标用户 | 否 | 否 |
| 定时到期 | 是 | 否 |
