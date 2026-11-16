---
title: Streaming API
---

# Streaming API

統合 Streaming API はタイムライン、通知、キャプチャしたノートの更新を WebSocket で配信します。遅延生成される `MisskeyClient.streaming` はクライアントの URL、トークンプロバイダー、ロガー、ログ設定を共有します。

## 設定と接続

接続動作を変更する必要がある場合にのみ `MisskeyStreamingConfig` を渡してください。

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

トークンプロバイダーは再接続を含む新しい接続ごとに評価されます。これにより、クライアントを作り直さずに更新されたトークンを反映できます。現在値は `state`、以後の変化は `stateChanges`、非同期の通信・プロトコル・タイムアウト・購読エラーは `errors` から取得します。自動再接続や再購読の失敗を扱う場合は、接続前に `errors` のリスナーを登録してください。再利用可能な接続は `connect()` / `disconnect()` / `reconnect()` で制御し、`dispose()` で完全に終了します。`disconnect()` は購読や Streaming クライアントを破棄せずに接続を閉じます。

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
| `messages` | envelope を保持した正規化済み `MisskeyStreamingMessage` |
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

`MisskeyUnknownEvent` は `type`、`body`、元の `raw` メッセージ、任意の `decodeError` を保持します。サーバー側で追加されたイベントも確認できるように、フォールバック分岐を残してください。グローバルの `client.streaming.messages` は外側の envelope を保持し、購読の `messages` は内側のイベントに正規化され、その購読の `subscriptionId` を持ちます。

## ノートの更新をキャプチャする

```dart
home.captureNote(noteId);
// eventsで reacted、unreacted、deleted、pollVoted を受信します。
home.uncaptureNote(noteId);
```

キャプチャは購読間で参照カウントされ、再接続後も復元されます。同じハンドルでの繰り返し呼び出しは冪等です。

## フォーク固有チャンネルと終了処理

`subscribeRaw()` にも、同じ ACK・再接続・メッセージ・クリーンアップの挙動が適用されます。Dart ストリームのリスナーは個別にキャンセルしてから、チャンネルの購読を解除してください。

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

明示的に指定する `id` は登録済みの購読間で一意である必要があり、現在の接続世代の tombstone に残っている ID も再利用できません。

`unsubscribe()` と `MisskeyClient.dispose()` は繰り返し・同時呼び出しに対応します。アクティブな購読の上限は32件です。クライアントの破棄後に `client.streaming` にアクセスすると `StateError` がスローされます。

旧パッケージからの移行は[misskey_streamingからの移行](./migration-from-misskey-streaming.md)を参照してください。
