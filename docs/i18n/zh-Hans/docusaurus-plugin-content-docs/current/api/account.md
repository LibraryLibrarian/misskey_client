---
sidebar_position: 4
title: "账户与个人资料"
---

# 账户与个人资料

`client.account` API 提供当前已认证用户的相关操作——获取和更新个人资料信息、管理凭证、导出/导入数据，以及访问注册表、双因素认证和 Webhook 的子 API。

## 获取你的个人资料

```dart
final me = await client.account.i();
print(me.name);        // 显示名称
print(me.username);    // 用户名（不含 @）
print(me.description); // 简介文字
```

## 更新你的个人资料

`update` 接受任意字段组合。只有你传入的字段会发送给服务器；未指定的字段保持不变，并返回更新后的 `MisskeyUser`。

```dart
final updated = await client.account.update(
  name: Optional('Alice'),
  description: Optional('Hello from Misskey!'),
  lang: Optional('en'),
  isLocked: false,
);
```

### Optional 类型

服务器可以接受 `null`（用于清除值）的字段使用 `Optional<T>` 包装类型。这让库能够区分三种状态：

- 参数省略——字段不包含在请求中；服务器值不变。
- `Optional('value')`——字段设置为给定值。
- `Optional.null_()`——字段被明确清除。

```dart
// 将头像设置为网盘文件并清除生日
await client.account.update(
  avatarId: Optional('driveFileId123'),
  birthday: Optional.null_(),
);
```

### 隐私与可见性

```dart
await client.account.update(
  followingVisibility: 'followers', // 'public', 'followers', 或 'private'
  followersVisibility: 'public',
  publicReactions: true,
  isLocked: true,                   // 需要关注审批
  hideOnlineStatus: true,
  noCrawle: true,
  preventAiLearning: true,
);
```

## 置顶与取消置顶笔记

```dart
// 将笔记置顶到你的个人资料
final updated = await client.account.pin(noteId: noteId);

// 取消置顶
final updated = await client.account.unpin(noteId: noteId);
```

两个方法均返回更新后的 `MisskeyUser`。

## 收藏

```dart
final favs = await client.account.favorites(limit: 20);
for (final fav in favs) {
  print(fav.note.text);
}
```

使用 `sinceId` / `untilId` 或 `sinceDate` / `untilDate`（Unix 时间戳，毫秒）进行分页。

```dart
final older = await client.account.favorites(
  limit: 20,
  untilId: favs.last.id,
);
```

## 密码、邮箱与令牌管理

### 修改密码

```dart
await client.account.changePassword(
  currentPassword: 'hunter2',
  newPassword: 'correct-horse-battery-staple',
);
```

如果启用了双因素认证，需要将当前 TOTP 码作为 `token` 传入。

### 更新邮箱地址

```dart
final updated = await client.account.updateEmail(
  password: 'mypassword',
  email: Optional('newemail@example.com'),
);

// 移除邮箱地址
await client.account.updateEmail(
  password: 'mypassword',
  email: Optional.null_(),
);
```

### 重新生成 API 令牌

调用完成后，当前令牌立即失效。

```dart
await client.account.regenerateToken(password: 'mypassword');
```

### 撤销令牌

```dart
await client.account.revokeTokenById(tokenId);
await client.account.revokeTokenByToken(tokenString);
```

## 导出与导入

所有导出操作均以异步任务队列的方式执行。完成时会发送通知。

### 导出数据

```dart
await client.account.exportNotes();
await client.account.exportFollowing(excludeMuting: true, excludeInactive: true);
await client.account.exportBlocking();
await client.account.exportMute();
await client.account.exportFavorites();
await client.account.exportAntennas();
await client.account.exportClips();
await client.account.exportUserLists();
```

### 导入数据

传入之前导出文件的网盘文件 ID。

```dart
// 先将文件上传到网盘，然后传入其 ID
await client.account.importFollowing(fileId: driveFileId, withReplies: true);
await client.account.importBlocking(fileId: driveFileId);
await client.account.importMuting(fileId: driveFileId);
await client.account.importAntennas(fileId: driveFileId);
await client.account.importUserLists(fileId: driveFileId);
```

## 登录历史

```dart
final history = await client.account.signinHistory(limit: 20);
for (final entry in history) {
  print('${entry.createdAt} — ${entry.ip}');
}
```

## 子 API

`AccountApi` 通过属性暴露三个子 API。

### 注册表

注册表为客户端应用存储任意键值数据（相当于浏览器的 localStorage，但可跨设备同步）。

```dart
// 读取值
final value = await client.account.registry.get(
  key: 'theme',
  scope: ['my-app'],
);

// 写入值
await client.account.registry.set(
  key: 'theme',
  value: 'dark',
  scope: ['my-app'],
);
```

### 双因素认证

```dart
// 开始 TOTP 注册
final reg = await client.account.twoFactor.registerTotp(password: 'mypassword');
print(reg.qr); // 在 UI 中显示的 QR 码数据 URL

// 使用认证器应用中的第一个验证码确认并激活 TOTP
await client.account.twoFactor.done(token: '123456');
```

### Webhook

```dart
// 创建 Webhook
final webhook = await client.account.webhooks.create(
  name: 'My webhook',
  url: 'https://example.com/hook',
  on: ['note', 'follow'],
  secret: 'supersecret',
);

// 列出 Webhook
final webhooks = await client.account.webhooks.list();
```
