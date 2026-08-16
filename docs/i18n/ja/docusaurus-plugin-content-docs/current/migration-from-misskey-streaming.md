---
title: misskey_streamingからの移行
---

# misskey_streamingからの移行

Streaming は `misskey_client` に統合されました。すべての呼び出し元を移行後、単独の `misskey_streaming` 依存を削除し、issue #30を含む最初の `misskey_client` リリースを使用してください。

## クライアントと購読

```dart
// 移行前
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
);
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
);

// 移行後
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

`MisskeyStreaming.fromClient()` は不要です。フォーク固有チャンネルには `subscribeRaw()` を使い、非同期になった `unsubscribe()` を `await` してください。

既存の `void oldLogger(String level, String message)` callbackは `FunctionLogger(oldLogger)` でラップしてclientの `logger` に渡し、`MisskeyClientConfig.enableLog` を `true` にします。

| 旧API | 統合API |
|---|---|
| `handle.stream` | `messages` / `events` / `notes` / `notifications` |
| `messagesFor(id)` | 対象ハンドルの `messages` |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| `status` / `isConnected` | `stateChanges` / `state == MisskeyStreamingConnectionState.connected` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `tokenProvider` / `logger` callback | `tokenProvider` / `logger: FunctionLogger(oldLogger)`（`enableLog: true`） |
| 再接続設定 | `MisskeyStreamingConfig` |
| `pingInterval` | 廃止（公開application-level ping設定なし） |
| `customHeaders` / `protocols` | 公開設定なし |
| `exceptionMapper` | 型付き例外と `errors` |

キャプチャ操作は `home.captureNote(noteId)` / `home.uncaptureNote(noteId)` に移動します。再利用する場合は `disconnect()`、完全終了は `dispose()` または `MisskeyClient.dispose()` を使用します。`sendToChannel()` の公開代替はありません。

詳細は[Streaming APIガイド](./streaming.md)と[完全な移行リファレンス](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md)を参照してください。
