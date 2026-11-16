---
title: Streaming API
---

# Streaming API

統合 Streaming API はタイムライン、通知、キャプチャしたノートの更新を WebSocket で配信します。遅延生成される `MisskeyClient.streaming` はクライアントのベース URL、トークンプロバイダー、ロガー、ログ設定を共有します。

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

トークンプロバイダーは再接続を含む新しい接続ごとに評価されます。これにより、クライアントを作り直さずに更新されたトークンを反映できます。

| メンバー | 用途 |
|---|---|
| `state` | 現在の `MisskeyStreamingConnectionState` |
| `stateChanges` | リスナー登録後に発生する状態変化 |
| `errors` | 非同期の通信・プロトコル・タイムアウト・購読エラー |
| `connect()` | 再利用可能な接続を開く |
| `disconnect()` | 購読や Streaming クライアントを破棄せずに接続を閉じる |
| `reconnect()` | 現在の接続を置き換える |
| `dispose()` | Streaming クライアントを完全に解放する |

アプリケーションで自動再接続や再購読の失敗を扱う場合は、接続前に `errors` のリスナーを登録してください。

## 公式チャンネルを購読する

公式チャンネルには、型付きの `MisskeyStreamingChannel` ファクトリを使います。

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

接続中の `subscribe()` は、サーバーが購読を確認した後に完了します。ハンドルは自動再接続をまたいで登録されたままになり、自動的に再購読されます。

`main`、ホーム・ローカル・ハイブリッド・グローバルの各タイムライン、ユーザーリスト、ハッシュタグ、ロール、アンテナ、チャンネル、ドライブ、サーバー統計とキュー統計、管理、Reversi、ダイレクトチャットとルームチャットの各チャンネルの型付き定義を利用できます。

## イベントの表示形式

購読は、振り分けられたメッセージを複数の形式で公開します。

| ストリーム | 内容 |
|---|---|
| `messages` | デコード済みの生の envelope を保持した正規化済み `MisskeyStreamingMessage` |
| `events` | 型付き `MisskeyStreamingEvent` |
| `notes` | ノートイベントから抽出した `MisskeyNote` |
| `notifications` | 通知イベントから抽出した `MisskeyNotification` |

```dart
final noteListener = home.notes.listen((note) {
  print(note.text);
});

final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId に $reaction が付けられました');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('未対応イベント $type: $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent` は正規化済みの `type`、`body`、元の `raw` メッセージ、任意の `decodeError` を保持します。サーバー側で追加されたイベントも確認できるように、フォールバック分岐を残してください。

グローバルの `client.streaming.messages` ストリームは外側の wire envelope を保持します。購読に振り分けられたメッセージは内側のイベントに正規化され、その購読の `subscriptionId` を持ちます。

## ノートの更新をキャプチャする

更新を受け取るハンドルを通じて、既知のノートをキャプチャします。

```dart
home.captureNote(noteId);
// home.events で reacted、unreacted、deleted、pollVoted イベントを受信できるようになります。

home.uncaptureNote(noteId);
```

キャプチャ操作は購読間で参照カウントされ、再接続後も復元されます。同じハンドルでのキャプチャやキャプチャ解除の繰り返し呼び出しは冪等です。

## フォーク固有チャンネル

Misskey のフォークが型付きファクトリのないチャンネルを公開している場合は、`subscribeRaw()` を使います。

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

同じ ACK・再接続・メッセージ・終了処理の挙動が適用されます。明示的に指定する ID は登録済みの購読間で一意である必要があり、現在の接続世代の tombstone に残っている ID も再利用できません。

## 終了処理

Dart ストリームのリスナーは個別にキャンセルしてから、チャンネルの購読を解除してください。

```dart
await listener.cancel();
await forkChannel.unsubscribe();

await noteListener.cancel();
await eventListener.cancel();
await home.unsubscribe();

await client.dispose();
```

`unsubscribe()` と `MisskeyClient.dispose()` は繰り返し・同時呼び出しに対応します。クライアントあたりのアクティブな Streaming 購読の上限は32件です。クライアントの破棄後に `client.streaming` にアクセスすると `StateError` がスローされます。

旧パッケージからの移行は[misskey_streamingからの移行](./migration-from-misskey-streaming.md)を参照してください。
