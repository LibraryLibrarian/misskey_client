[English](README.md) | [日本語](README.ja.md) | 简体中文 | [Deutsch](README.de.md) | [Français](README.fr.md) | [한국어](README.ko.md)

# misskey_client

面向 [Misskey](https://misskey-hub.net/) API 的纯 Dart 客户端库。提供对 25 个 API 域的强类型访问，内置认证、重试逻辑和结构化错误处理。

> **Beta 版本**: API 实现已完成，但测试覆盖率较低。响应模型和方法签名可能会根据测试结果进行调整。详情请参阅 [CHANGELOG](CHANGELOG.md)。

## 特性

- 覆盖 25 个 Misskey API 域（帖子、网盘、用户、频道、聊天等）
- 通过可插拔的 `TokenProvider` 回调实现基于令牌的认证
- 可配置最大重试次数的自动重试
- 用于穷举式错误处理的密封异常类层次结构
- 使用 `json_serializable` 生成的强类型请求和响应模型
- 集成 Streaming API，提供强类型频道、事件和自动重连
- 通过可替换的 `Logger` 接口实现灵活日志记录
- 纯 Dart — 无 Flutter 依赖

## 安装

将包添加到您的 `pubspec.yaml`：

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.6
```

然后运行：

```
dart pub get
```

## 快速开始

```dart
import 'package:misskey_client/misskey_client.dart';

void main() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
      timeout: Duration(seconds: 10),
      maxRetries: 3,
    ),
    // 提供您的访问令牌。回调可以是异步的。
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
  );

  // 获取已认证用户的帖子时间线
  final notes = await client.notes.getTimeline();
  for (final note in notes) {
    print(note.text);
  }
}
```

## API 概览

`MisskeyClient` 公开以下属性，每个属性覆盖 Misskey API 的不同区域：

| 属性 | 说明 |
|---|---|
| `account` | 账号与个人资料管理、注册表、双重认证、Webhook |
| `announcements` | 服务器公告 |
| `antennas` | 天线（基于关键词的订阅源）管理 |
| `ap` | ActivityPub 工具 |
| `blocking` | 用户屏蔽 |
| `channels` | 频道与频道静音 |
| `charts` | 统计图表 |
| `chat` | 聊天室与消息 |
| `clips` | 便签集合 |
| `drive` | 网盘（文件存储）、文件、文件夹、统计信息 |
| `federation` | 联合实例信息 |
| `flash` | Flash（Play）脚本 |
| `following` | 关注与关注请求 |
| `gallery` | 图库帖子 |
| `hashtags` | 话题标签搜索与趋势 |
| `invite` | 邀请码 |
| `meta` | 服务器元数据 |
| `mute` | 用户静音 |
| `notes` | 帖子、回应、投票、搜索、时间线 |
| `notifications` | 通知 |
| `pages` | 页面 |
| `renoteMute` | 转发静音 |
| `roles` | 角色分配 |
| `sw` | 推送通知（Service Worker） |
| `streaming` | 实时时间线、通知和已捕获帖子的更新 |
| `users` | 用户搜索、列表、关系、成就 |

## Streaming API

延迟创建的 `client.streaming` 连接会共享客户端的服务器、令牌提供器和日志记录器。使用强类型 `MisskeyStreamingChannel` 进行订阅，并按应用需求选择已解码的 `notes` / `notifications`、强类型 `events` 或保留完整信息的 `messages`。

```dart
Future<void> streamHomeTimeline() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
    ),
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
    streamingConfig: MisskeyStreamingConfig(maxReconnectAttempts: 5),
  );

  await client.streaming.connect();
  final home = await client.streaming.subscribe(
    const MisskeyStreamingChannel.homeTimeline(
      withRenotes: true,
      withFiles: false,
    ),
  );

  final notesSubscription = home.notes.listen((note) {
    print(note.text);
  });
  final eventsSubscription = home.events.listen((event) {
    if (event is MisskeyNoteReactedEvent) {
      print('${event.noteId}: ${event.reaction}');
    }
  });

  // 捕获已知帖子，以接收回应、删除和投票更新。
  home.captureNote('NOTE_ID');

  await notesSubscription.cancel();
  await eventsSubscription.cancel();
  home.uncaptureNote('NOTE_ID');
  await home.unsubscribe();
  await client.dispose();
}
```

对于分支特有的频道，请使用 `subscribeRaw(channel: ..., params: ...)`。它返回相同的订阅句柄，并包含 `messages` 流。通过 `connect()`、`disconnect()` 和 `reconnect()` 控制可复用连接；`dispose()` 会终止连接。连接状态可通过 `state` 和 `stateChanges` 获取，异步错误则通过 `errors` 报告。

## 认证

在构建客户端时传入 `TokenProvider` 回调。回调返回 `FutureOr<String?>`，因此同步和异步令牌来源均受支持：

```dart
// 同步令牌
final client = MisskeyClient(
  config: config,
  tokenProvider: () => secureStorage.readSync('token'),
);

// 异步令牌
final client = MisskeyClient(
  config: config,
  tokenProvider: () async => await secureStorage.read('token'),
);
```

需要认证的端点会自动注入令牌。可选认证的端点在令牌可用时附加令牌。

## 错误处理

所有异常都继承自密封类 `MisskeyClientException`，支持穷举式模式匹配：

```dart
try {
  final user = await client.users.show(userId: 'abc123');
} on MisskeyUnauthorizedException {
  // 401 — 令牌无效或缺失
} on MisskeyForbiddenException {
  // 403 — 操作不被允许
} on MisskeyNotFoundException {
  // 404 — 资源未找到
} on MisskeyRateLimitException catch (e) {
  // 429 — 请求频率受限；检查 e.retryAfter
} on MisskeyValidationException {
  // 422 — 请求体无效
} on MisskeyServerException {
  // 5xx — 服务器端错误
} on MisskeyNetworkException {
  // 超时、连接被拒绝等
}
```

## 日志记录

通过 `MisskeyClientConfig.enableLog` 启用内置的 stdout 日志记录器，或提供自定义的 `Logger` 实现：

```dart
class MyLogger implements Logger {
  @override void debug(String message) { /* ... */ }
  @override void info(String message)  { /* ... */ }
  @override void warn(String message)  { /* ... */ }
  @override void error(String message, [Object? error, StackTrace? stackTrace]) { /* ... */ }
}

final client = MisskeyClient(
  config: MisskeyClientConfig(baseUrl: Uri.parse('https://misskey.example.com')),
  logger: MyLogger(),
);
```

## 从 misskey_api_core 迁移

### API 对应表

| misskey_api_core | misskey_client |
|---|---|
| `MisskeyHttpClient(config: ..., tokenProvider: ...)` | `MisskeyClient(config: ..., tokenProvider: ...)` |
| `MisskeyApiConfig(baseUrl: ...)` | `MisskeyClientConfig(baseUrl: ...)` |
| `http.send<T>('/emojis', ...)` | 对应的强类型方法，例如 `client.meta.getEmojis()` |
| `MetaClient(http).getMeta()` | `client.meta.getMeta()` |
| `MisskeyApiException` | 包含 `MisskeyApiException`、`MisskeyUnauthorizedException`、`MisskeyForbiddenException`、`MisskeyRateLimitException` 等的密封层次结构 |
| `RequestOptions(authRequired: false)` | 由强类型方法在内部处理，调用方无需指定 |
| `Logger` / `FunctionLogger` | 同名类 |
| `kReleaseMode` / `kDebugMode` | 不属于公共 API；详见下文 |

### MisskeyApiException 名称冲突

两个包都定义了 `MisskeyApiException`，但类的内容和继承关系不同。`misskey_api_core` 版本是简单类，而 `misskey_client` 版本继承 `MisskeyClientException`，并且必须提供 `statusCode`。迁移期间同时导入两个包时，请使用前缀避免冲突：

```dart
import 'package:misskey_api_core/misskey_api_core.dart' as core;
```

### 构建模式常量

`misskey_api_core` 导出了 `kReleaseMode` 和 `kDebugMode`，但 `misskey_client` 不会将它们纳入公共 API。它们是与 Misskey 无关的通用工具。Flutter 应用应使用 `package:flutter/foundation.dart` 中的常量；纯 Dart 应用可使用 `bool.fromEnvironment('dart.vm.product')`。请通过 `MisskeyClientConfig.enableLog` 控制客户端日志，例如传入 `enableLog: kDebugMode`。

### 低级 HTTP 访问

与 `MisskeyHttpClient.send<T>()` 对应的低级 API 不会公开。`misskey_client` 已覆盖 25 个 API 域，请使用强类型方法。如果缺少您需要的端点，请通过 GitHub issue 报告，以便将其加入强类型 API。

## 从 misskey_streaming 迁移

Streaming 现已集成到 `misskey_client` 中。有关从独立 `misskey_streaming` 包迁移依赖项、配置、订阅、事件、帖子捕获和生命周期的对应关系，请参阅[迁移指南](MIGRATION_FROM_MISSKEY_STREAMING.md)。

## 文档

- API 参考文档：https://librarylibrarian.github.io/misskey_client/
- pub.dev 页面：https://pub.dev/packages/misskey_client
- GitHub：https://github.com/LibraryLibrarian/misskey_client

## 许可证

请参阅 [LICENSE](LICENSE)。
