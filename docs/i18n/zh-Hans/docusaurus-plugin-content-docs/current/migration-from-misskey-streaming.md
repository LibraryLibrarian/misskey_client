---
title: 从misskey_streaming迁移
---

# 从misskey_streaming迁移

Streaming 现已集成到 `misskey_client`。迁移所有调用点后，请移除独立的 `misskey_streaming` 依赖，并使用首个包含 issue #30 的 `misskey_client` 版本。

## 创建集成客户端

```dart
// 迁移前
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
  enableAutoReconnect: true,
  debugLog: true,
);

// 迁移后
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => token,
  streamingConfig: MisskeyStreamingConfig(enableAutoReconnect: true),
);
await client.streaming.connect();
```

不再需要 `MisskeyStreaming.fromClient()`。集成连接共享 `MisskeyClient` 的 URL、令牌提供器、日志记录器和日志设置。

请用 `FunctionLogger(oldLogger)` 包装现有的 `void oldLogger(String level, String message)` 回调，将其传给客户端的 `logger`，并将 `MisskeyClientConfig.enableLog` 设为 `true`。

## 替换订阅和捕获调用

```dart
// 迁移前
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
  params: {'withRenotes': true},
);
handle.stream.listen((message) => print(message.body));
streaming.captureNote(handle.id, noteId);

// 迁移后
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(withRenotes: true),
);
home.messages.listen((message) => print(message.body));
home.captureNote(noteId);
```

分支特有频道使用 `subscribeRaw(channel: ..., params: ..., id: ...)`。`unsubscribe()` 现在是异步的，请使用 `await` 等待其完成。

| 旧 API | 集成 API |
|---|---|
| `MisskeySubscriptionHandle.stream` | 句柄的 `messages`、`events`、`notes` 或 `notifications` |
| `MisskeyStreamingClient.messagesFor(id)` | 对应句柄的 `messages` |
| `MisskeyStreamingClient.messages` | `client.streaming.messages`（外层信封） |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `uncaptureNote(handle.id, noteId)` | `handle.uncaptureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| 手动进行强类型解码 | `MisskeyStreamingEvent` 和 `MisskeyUnknownEvent` |

## 生命周期和配置的对应关系

| 旧 API | 集成 API |
|---|---|
| `status` 流 | `stateChanges` 加上当前的 `state` |
| `isConnected` | `state == MisskeyStreamingConnectionState.connected` |
| 重连字段 | `MisskeyStreamingConfig` 上的相同字段 |
| — | `MisskeyStreamingConfig.subscriptionTimeout` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `token` / `tokenProvider` | `MisskeyClient` 的 `tokenProvider` 参数 |
| `debugLog` / `logger` 回调 | 客户端的 `enableLog: true` / `logger: FunctionLogger(oldLogger)` |
| `pingInterval` | 已移除；没有公开的应用层 ping 定时器 |
| `customHeaders` / `protocols` | 无公开集成设置 |
| `connector` | 仅供内部测试注入使用 |
| `exceptionMapper` | 强类型 Streaming 异常和 `errors` 流 |

需要复用连接时使用 `disconnect()`。使用完毕后，调用用于彻底释放资源的 `dispose()`，或释放拥有该连接的 `MisskeyClient`。`MisskeyClient.dispose()` 是幂等的，会关闭已初始化的 Streaming 资源和 HTTP 传输层。

`sendToChannel()` 没有公开的集成替代 API。如果上游或分支协议需要向频道发送事件，请提交 issue。

完整示例和事件详情请参阅 [Streaming API指南](./streaming.md)。仓库根目录也提供了[完整迁移参考](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md)。
