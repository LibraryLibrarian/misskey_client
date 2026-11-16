---
title: Streaming API
---

# Streaming API

集成的 Streaming API 通过 WebSocket 提供时间线、通知和已捕获笔记的更新。延迟创建的 `MisskeyClient.streaming` 会共享客户端的基础 URL、令牌提供器、日志记录器和日志设置。

## 配置并连接

仅在需要更改连接行为时传入 `MisskeyStreamingConfig`。

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

每次新建连接（包括重连）时都会调用令牌提供器。这样无需重新创建客户端即可使更新后的令牌生效。

| 成员 | 用途 |
|---|---|
| `state` | 当前的 `MisskeyStreamingConnectionState` |
| `stateChanges` | 开始监听后发生的状态变化 |
| `errors` | 异步传输、协议、超时和订阅错误 |
| `connect()` | 打开可复用的连接 |
| `disconnect()` | 关闭连接，但不释放订阅或 Streaming 客户端 |
| `reconnect()` | 替换当前连接 |
| `dispose()` | 永久释放 Streaming 客户端 |

如果应用需要处理自动重连或重新订阅时的失败，请在连接前监听 `errors`。

## 订阅官方频道

官方频道使用强类型的 `MisskeyStreamingChannel` 工厂方法。

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

连接期间，`subscribe()` 会在服务器确认订阅后完成。句柄会在自动重连过程中保持注册，并自动重新订阅。

API 为 `main`、首页／本地／混合／全局时间线、用户列表、话题标签、角色、天线、频道、网盘、服务器和队列统计、管理、Reversi，以及私聊或聊天室频道提供强类型定义。

## 选择事件视图

订阅会以多种视图公开路由到它的消息。

| 流 | 内容 |
|---|---|
| `messages` | 保留原始已解码信封的标准化 `MisskeyStreamingMessage` 值 |
| `events` | 强类型 `MisskeyStreamingEvent` 值 |
| `notes` | 从笔记事件中提取的 `MisskeyNote` 值 |
| `notifications` | 从通知事件中提取的 `MisskeyNotification` 值 |

```dart
final noteListener = home.notes.listen((note) {
  print(note.text);
});

final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId 收到了 $reaction');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('不支持的事件 $type: $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent` 保留标准化后的 `type`、`body`、源 `raw` 消息和可选的 `decodeError`。请保留兜底分支，以便仍能观察到服务器新增的事件。

全局 `client.streaming.messages` 流保留外层网络信封。路由到订阅的消息会标准化为内层事件，并携带该订阅的 `subscriptionId`。

## 捕获笔记更新

通过应接收更新的句柄捕获已知笔记：

```dart
home.captureNote(noteId);
// home.events 现在可发出 reacted、unreacted、deleted 和 pollVoted 事件。

home.uncaptureNote(noteId);
```

捕获调用在订阅之间进行引用计数，并会在重连后恢复。同一句柄上重复调用捕获或取消捕获是幂等的。

## 分支特有频道

当 Misskey 分支版本提供没有类型化工厂的频道时，使用 `subscribeRaw()`。

```dart
final forkChannel = await client.streaming.subscribeRaw(
  channel: 'forkSpecificChannel',
  params: const <String, Object?>{'option': true},
  id: 'optional-caller-id',
);

final listener = forkChannel.messages.listen((message) {
  print('${message.type}: ${message.body}');
});
```

同样适用上述确认、重连、消息和清理行为。显式指定的 ID 必须在已注册的订阅中唯一，且不能复用当前连接代次中已被标记为失效（tombstone）的订阅 ID。

## 清理

请单独取消 Dart 流监听器，然后取消频道订阅。

```dart
await listener.cancel();
await forkChannel.unsubscribe();

await noteListener.cancel();
await eventListener.cancel();
await home.unsubscribe();

await client.dispose();
```

`unsubscribe()` 和 `MisskeyClient.dispose()` 可安全地重复或并发调用。每个客户端的活动 Streaming 订阅上限为 32 个。客户端释放后再访问 `client.streaming` 会抛出 `StateError`。

从旧包迁移时，请参阅[从misskey_streaming迁移](./migration-from-misskey-streaming.md)。
