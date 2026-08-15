---
title: Streaming API
---

# Streaming API

統合 Streaming API はタイムライン、通知、キャプチャしたノートの更新を WebSocket で配信します。遅延生成される `MisskeyClient.streaming` はクライアントの URL、トークンプロバイダー、ロガー、ログ設定を共有します。

## 設定と接続

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

トークンプロバイダーは再接続を含む新しい接続ごとに評価されます。現在値は `state`、以後の変化は `stateChanges`、非同期の通信・プロトコル・購読エラーは `errors` から取得します。再利用可能な接続は `connect()` / `disconnect()` / `reconnect()` で制御し、`dispose()` で完全に終了します。

## 公式チャンネルを購読する

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

接続中の `subscribe()` は、サーバーの `connected` ACK 後に完了します。購読定義は自動再接続後に再送されます。`main`、各タイムライン、ユーザーリスト、ハッシュタグ、ロール、アンテナ、チャンネル、ドライブ、統計、管理、Reversi、チャットの型付き定義を利用できます。

## イベントの表示形式

| ストリーム | 内容 |
|---|---|
| `messages` | raw envelopeを保持した正規化済み `MisskeyStreamingMessage` |
| `events` | 型付き `MisskeyStreamingEvent` |
| `notes` | ノートイベントから抽出した `MisskeyNote` |
| `notifications` | 通知イベントから抽出した `MisskeyNotification` |

```dart
final noteListener = home.notes.listen((note) => print(note.text));
final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId: $reaction');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('未対応イベント $type: $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent` は `type`、`body`、元の `raw` メッセージ、任意の `decodeError` を保持します。グローバルの `client.streaming.messages` は外側の wire envelope を保持し、購読の `messages` は内側のイベントに正規化されます。

## ノートの更新をキャプチャする

```dart
home.captureNote(noteId);
// eventsで reacted、unreacted、deleted、pollVoted を受信します。
home.uncaptureNote(noteId);
```

キャプチャは購読間で参照カウントされ、再接続後も復元されます。同じハンドルでの繰り返し呼び出しは冪等です。

## フォーク固有チャンネルと終了処理

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

`unsubscribe()` と `MisskeyClient.dispose()` は繰り返し・同時呼び出しに対応します。アクティブな購読の上限は32件です。

旧パッケージからの移行は[misskey_streamingからの移行](./migration-from-misskey-streaming.md)を参照してください。
