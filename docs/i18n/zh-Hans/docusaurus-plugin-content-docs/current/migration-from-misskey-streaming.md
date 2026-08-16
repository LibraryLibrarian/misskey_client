---
title: 从misskey_streaming迁移
---

# 从misskey_streaming迁移

Streaming 现已集成到 `misskey_client`。迁移所有调用点后，请移除独立的 `misskey_streaming` 依赖，并使用首个包含 issue #30 的 `misskey_client` 版本。

## 客户端和订阅

```dart
// 迁移前
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
);
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
);

// 迁移后
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => token,
  streamingConfig: MisskeyStreamingConfig(),
);
await client.streaming.connect();
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(),
);
```

不再需要 `MisskeyStreaming.fromClient()`。分支特有频道使用 `subscribeRaw()`，并对现在为异步的 `unsubscribe()` 使用 `await`。

请用 `FunctionLogger(oldLogger)` 包装现有的 `void oldLogger(String level, String message)` 回调，将其传给客户端的 `logger`，并将 `MisskeyClientConfig.enableLog` 设为 `true`。

| 旧 API | 集成 API |
|---|---|
| `handle.stream` | `messages` / `events` / `notes` / `notifications` |
| `messagesFor(id)` | 对应句柄的 `messages` |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| `status` / `isConnected` | `stateChanges` / `state == MisskeyStreamingConnectionState.connected` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `tokenProvider` / `logger` 回调 | `tokenProvider` / `logger: FunctionLogger(oldLogger)`（`enableLog: true`） |
| 重连设置 | `MisskeyStreamingConfig` |
| `pingInterval` | 已移除；没有公开的应用层 ping 设置 |
| `customHeaders` / `protocols` | 无公开集成设置 |
| `exceptionMapper` | 强类型异常和 `errors` |

捕获操作改为 `home.captureNote(noteId)` / `home.uncaptureNote(noteId)`。需要复用连接时使用 `disconnect()`，彻底结束时使用 `dispose()` 或 `MisskeyClient.dispose()`。`sendToChannel()` 没有公开替代项。

详情请参阅[Streaming API指南](./streaming.md)和[完整迁移参考](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md)。
