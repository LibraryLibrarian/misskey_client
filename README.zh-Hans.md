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
- 通过可替换的 `Logger` 接口实现灵活日志记录
- 纯 Dart — 无 Flutter 依赖

## 安装

将包添加到您的 `pubspec.yaml`：

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.1
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
| `users` | 用户搜索、列表、关系、成就 |

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

## 文档

- API 参考文档：https://librarylibrarian.github.io/misskey_client/
- pub.dev 页面：https://pub.dev/packages/misskey_client
- GitHub：https://github.com/LibraryLibrarian/misskey_client

## 许可证

请参阅 [LICENSE](LICENSE)。
