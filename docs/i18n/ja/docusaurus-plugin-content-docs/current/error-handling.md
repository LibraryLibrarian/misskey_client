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
