---
title: misskey_streamingからの移行
---

# misskey_streamingからの移行

Streaming は `misskey_client` に統合されました。すべての呼び出し元を移行後、単独の `misskey_streaming` 依存を削除し、issue #30を含む最初の `misskey_client` リリースを使用してください。

## 統合クライアントを作成する

```dart
// 移行前
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
  enableAutoReconnect: true,
  debugLog: true,
);

// 移行後
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

`MisskeyStreaming.fromClient()` は不要です。統合された接続は `MisskeyClient` の URL、トークンプロバイダー、ロガー、ログ設定を共有します。

既存の `void oldLogger(String level, String message)` コールバックは `FunctionLogger(oldLogger)` でラップしてクライアントの `logger` に渡し、`MisskeyClientConfig.enableLog` を `true` にします。

## 購読とキャプチャの呼び出しを置き換える

```dart
// 移行前
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
  params: {'withRenotes': true},
);
handle.stream.listen((message) => print(message.body));
streaming.captureNote(handle.id, noteId);

// 移行後
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(withRenotes: true),
);
home.messages.listen((message) => print(message.body));
home.captureNote(noteId);
```

フォーク固有チャンネルには `subscribeRaw(channel: ..., params: ..., id: ...)` を使います。`unsubscribe()` は非同期になったため、`await` してください。

| 旧API | 統合API |
|---|---|
| `MisskeySubscriptionHandle.stream` | ハンドルの `messages`、`events`、`notes`、`notifications` |
| `MisskeyStreamingClient.messagesFor(id)` | 対象ハンドルの `messages` |
| `MisskeyStreamingClient.messages` | `client.streaming.messages`（外側の envelope） |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `uncaptureNote(handle.id, noteId)` | `handle.uncaptureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| 手動の型付きデコード | `MisskeyStreamingEvent` と `MisskeyUnknownEvent` |

## ライフサイクルと設定の対応

| 旧API | 統合API |
|---|---|
| `status` ストリーム | `stateChanges` と現在の `state` |
| `isConnected` | `state == MisskeyStreamingConnectionState.connected` |
| 再接続フィールド | `MisskeyStreamingConfig` の同じフィールド |
| — | `MisskeyStreamingConfig.subscriptionTimeout` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `token` / `tokenProvider` | `MisskeyClient` の `tokenProvider` 引数 |
| `debugLog` / `logger` コールバック | クライアントの `enableLog: true` / `logger: FunctionLogger(oldLogger)` |
| `pingInterval` | 廃止（アプリケーションレベルの ping タイマーは公開されません） |
| `customHeaders` / `protocols` | 公開された統合設定なし |
| `connector` | 内部テストでの注入専用 |
| `exceptionMapper` | 型付き Streaming 例外と `errors` ストリーム |

接続を再利用する場合は `disconnect()` を使用します。使い終えたら `dispose()` で完全に終了するか、接続を所有する `MisskeyClient` を破棄してください。`MisskeyClient.dispose()` は冪等で、初期化済みの Streaming リソースと HTTP トランスポートの両方を閉じます。

`sendToChannel()` に対応する統合 API は公開されていません。上流またはフォークのプロトコルでチャンネルへのイベント送信が必要な場合は、Issue を作成してください。

完全な例とイベントの詳細は[Streaming APIガイド](./streaming.md)を参照してください。リポジトリのルートには[完全な移行リファレンス](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md)もあります。
