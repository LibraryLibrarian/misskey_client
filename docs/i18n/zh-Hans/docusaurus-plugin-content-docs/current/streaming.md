---
title: Streaming API
---

# Streaming API

集成的 Streaming API 通过 WebSocket 提供时间线、通知和已捕获帖子的更新。延迟创建的 `MisskeyClient.streaming` 会共享客户端的 URL、令牌提供器、日志记录器和日志设置。

## 配置并连接

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'YOUR_ACCESS_TOKEN',
  streamingConfig: MisskeyStreamingConfig(
    connectTimeout: const Duration(seconds: 15),
    subscriptionTimeout: const Duration(seconds: 10),
    enableAutoReconnect: true,
    maxReconnectAttempts: 5,
  ),
);
await client.streaming.connect();
```

每次新建连接（包括重连）时都会重新获取令牌。通过 `state` 读取当前状态，通过 `stateChanges` 监听后续变化，通过 `errors` 接收异步传输、协议和订阅错误。`connect()`、`disconnect()` 和 `reconnect()` 控制可复用连接，`dispose()` 则永久释放它。

## 订阅官方频道

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

连接期间，`subscribe()` 会在服务器返回 `connected` 确认后完成。订阅会在自动重连后重新发送。官方主频道、各类时间线、用户列表、话题标签、角色、天线、频道、网盘、统计、管理、Reversi 和聊天均有强类型定义。

## 选择事件视图

| 流 | 内容 |
|---|---|
| `messages` | 保留原始信封的标准化 `MisskeyStreamingMessage` |
| `events` | 强类型 `MisskeyStreamingEvent` |
| `notes` | 从帖子事件中提取的 `MisskeyNote` |
| `notifications` | 从通知事件中提取的 `MisskeyNotification` |

```dart
final noteListener = home.notes.listen((note) => print(note.text));
final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId: $reaction');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('不支持的事件 $type: $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent` 保留 `type`、`body`、源 `raw` 消息和可选的 `decodeError`。全局 `client.streaming.messages` 保留外层网络信封，而订阅的 `messages` 会标准化为内层事件。

## 捕获帖子更新

```dart
home.captureNote(noteId);
// events 可接收 reacted、unreacted、deleted 和 pollVoted。
home.uncaptureNote(noteId);
```

捕获在订阅之间进行引用计数，并会在重连后恢复。同一句柄上的重复调用是幂等的。

## 分支特有频道与清理

```dart
final forkChannel = await client.streaming.subscribeRaw(
  channel: 'forkSpecificChannel',
  params: const <String, Object?>{'option': true},
  id: 'optional-caller-id',
);
final listener = forkChannel.messages.listen(print);

await listener.cancel();
await forkChannel.unsubscribe();
await noteListener.cancel();
await eventListener.cancel();
await home.unsubscribe();
await client.dispose();
```

`unsubscribe()` 和 `MisskeyClient.dispose()` 可安全地重复或并发调用。活动订阅上限为 32 个。

从旧包迁移时，请参阅[从misskey_streaming迁移](./migration-from-misskey-streaming.md)。
