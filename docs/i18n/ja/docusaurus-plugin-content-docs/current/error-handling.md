---
sidebar_position: 4
---

# エラーハンドリング

## 例外階層

misskey_client の例外はすべて `MisskeyClientException` を頂点とするsealed classの階層で構成されています。

```
MisskeyClientException (sealed)
├── MisskeyApiException      - サーバーからのエラーレスポンス
│   ├── statusCode: int      - HTTPステータスコード
│   ├── errorCode: String?   - Misskeyエラーコード
│   └── message: String?     - エラーメッセージ
└── MisskeyNetworkException  - ネットワーク到達不能・タイムアウト
    └── cause: Object?       - 元の例外
```

## 階層外の例外

`MisskeyClientException` が対象とするのは API と通信のエラーです。[ドライブヘルパー](./advanced/drive-helpers.md)など一部のヘルパー API は、次の例外もスローする場合があります。

- `ArgumentError` — 不正な引数（たとえば正でない `concurrency` や範囲外の `pageSize`）。リクエストを送信する前にスローされます。
- `StateError` — 前提条件が満たされていない場合。たとえば `main` ストリーミング購読が接続されていない状態で `client.drive.uploadFromUrlAndWait()` を呼び出した場合です。
- `DriveFolderAmbiguousException` — 同じ階層に同名のフォルダが複数ある場合に `resolvePath()` と `getOrCreate()` がスローします。sealed 階層には含まれないため、`on MisskeyClientException` では catch されません。

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} folders named "${e.name}"');
} on MisskeyClientException catch (e) {
  print('Error: $e');
}
```

多数の項目を変更するバッチヘルパー（`createMany()`、`moveBulkAll()`、`dissolveFolder()`、`deleteFolderRecursive()` など）は、変更を開始した後は例外をスローしません。各項目を成功、エラーを伴う失敗、理由を伴うスキップのいずれかとして報告する `MisskeyBatchResult`（またはそれを含む結果）を返します。移動先の確認の失敗など、変更を行う前に発生したエラーは引き続きスローされます。

## 基本的なcatchパターン

```dart
try {
  final note = await client.notes.show(noteId: 'abc123');
} on MisskeyApiException catch (e) {
  print('APIエラー: ${e.statusCode} - ${e.errorCode}');
} on MisskeyNetworkException catch (e) {
  print('ネットワークエラー: ${e.cause}');
} on MisskeyClientException catch (e) {
  print('クライアントエラー: $e');
}
```

## HTTPステータス別ハンドリング

`MisskeyApiException.statusCode` でHTTPステータスコードを確認できます。

```dart
try {
  await client.notes.create(text: 'Hello, Misskey!');
} on MisskeyApiException catch (e) {
  switch (e.statusCode) {
    case 401:
      print('認証が必要です。トークンを確認してください。');
    case 403:
      print('この操作は許可されていません。');
    case 404:
      print('リソースが見つかりません。');
    case 422:
      print('リクエストの内容が不正です: ${e.message}');
    default:
      print('サーバーエラー: ${e.statusCode}');
  }
}
```

## レート制限リトライ

429レスポンス（レート制限）を受けた場合は、一定時間待機してリトライします。

```dart
Future<T> withRateLimitRetry<T>(Future<T> Function() fn) async {
  while (true) {
    try {
      return await fn();
    } on MisskeyApiException catch (e) {
      if (e.statusCode == 429) {
        // レート制限: 少し待ってリトライ
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }
      rethrow;
    }
  }
}

// 使用例
final notes = await withRateLimitRetry(
  () => client.notes.timeline(),
);
```

`MisskeyClientConfig` の `maxRetries` でリトライ回数を設定することもできます。
