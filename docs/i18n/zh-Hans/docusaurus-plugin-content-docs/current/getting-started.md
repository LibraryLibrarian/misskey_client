---
sidebar_position: 1
slug: /
title: 快速入门
---

# 快速入门

:::warning Beta 版本

本库目前处于 **Beta** 阶段。API 实现已完成，但测试覆盖率较低。响应模型和方法签名可能会根据测试结果进行调整。

如果您发现响应模型不正确或行为异常，请通过 [GitHub Issues](https://github.com/LibraryLibrarian/misskey_client/issues) 反馈，或提交 [Pull Request](https://github.com/LibraryLibrarian/misskey_client/pulls)。

:::

misskey_client 是一个纯 Dart 编写的 Misskey API 客户端库。
它可以在所有支持 Dart 的环境中运行：Flutter、服务端 Dart、CLI 工具等。

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.1
```

然后获取依赖：

```bash
dart pub get
```

## 基本用法

### 初始化客户端

```dart
import 'package:misskey_client/misskey_client.dart';

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_access_token',
);
```

`baseUrl` 必须是包含协议头（如 `https://`）的 `Uri`。
`tokenProvider` 是一个返回 `FutureOr<String?>` 的回调函数。当只需要访问无需认证的端点时，可以省略此参数。

### 第一次 API 调用

获取服务器信息（无需认证）：

```dart
final serverInfo = await client.meta.fetch();
print(serverInfo.name);        // 服务器名称
print(serverInfo.description); // 服务器描述
```

获取已认证用户自身的账户信息：

```dart
final me = await client.account.i();
print(me.name);     // 显示名称
print(me.username); // 用户名（不含 @）
```

### API 结构

`MisskeyClient` 上的每个属性对应一个 API 域：

```dart
client.account       // 账户和个人资料管理 (/api/i/*)
client.announcements // 服务器公告
client.antennas      // 天线（关键词监控）管理
client.ap            // ActivityPub 端点
client.blocking      // 用户屏蔽
client.channels      // 频道管理
client.charts        // 统计图表
client.chat          // 私信
client.clips         // 笔记便签管理
client.drive         // 文件存储（drive.files, drive.folders, drive.stats）
client.federation    // 联合实例信息
client.flash         // Play（Flash）管理
client.following     // 关注 / 取消关注操作
client.gallery       // 图库帖子管理
client.hashtags      // 话题标签信息
client.invite        // 邀请码管理
client.meta          // 服务器元数据
client.mute          // 用户屏蔽（静音）
client.notes         // 笔记操作（时间线、创建、回应等）
client.notifications // 通知获取和管理
client.pages         // 页面管理
client.renoteMute    // 转发静音管理
client.roles         // 角色管理
client.sw            // Service Worker 推送通知注册
client.users         // 用户搜索、关注列表、用户列表
```

### 控制日志输出

HTTP 请求/响应日志默认禁用。通过 `MisskeyClientConfig` 启用：

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

如需将日志路由到自定义目标，可在构造函数中传入 `Logger` 实现：

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level 为以下之一：'debug', 'info', 'warn', 'error'
    myLogger.log(level, message);
  }),
);
```

详情请参阅[日志](./advanced/logging.md)。

## 下一步

- [认证](./authentication.md) — 基于令牌的认证与 MiAuth 流程
- [错误处理](./error-handling.md) — 异常层级与捕获模式
- [笔记](./api/notes.md) — 创建和获取笔记
- [网盘上传](./advanced/drive-upload.md) — 向网盘上传文件
