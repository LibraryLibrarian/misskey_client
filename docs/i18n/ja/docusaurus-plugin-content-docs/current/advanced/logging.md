---
sidebar_position: 1
---

# ロギング

## デフォルトの動作

`enableLog` を明示的に設定しない場合、`MisskeyClientConfig` はデフォルトで `StdoutLogger` を使用します。ログはすべて標準出力に出力されます。

## ログの無効化

本番環境などでログ出力が不要な場合は `enableLog: false` を設定します。

```dart
final config = MisskeyClientConfig(
  baseUrl: 'https://misskey.example.com',
  enableLog: false,
);
```

## FunctionLogger

ログを独自のシステム（ファイル、外部サービスなど）に転送したい場合は `FunctionLogger` を使います。

```dart
final logger = FunctionLogger(
  onLog: (message) {
    myLogService.info(message);
  },
);

final client = MisskeyClient(
  config: config,
  tokenProvider: tokenProvider,
  logger: logger,
);
```

## カスタムLoggerの実装

`Logger` インターフェースを実装することで、完全にカスタマイズされたロガーを作成できます。

```dart
class MyLogger implements Logger {
  @override
  void log(String message) {
    // 任意のログ出力処理
    debugPrint('[misskey_client] $message');
  }

  @override
  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    // エラーログの処理
    debugPrint('[misskey_client] ERROR: $message');
    if (error != null) debugPrint('  cause: $error');
  }
}

final client = MisskeyClient(
  config: config,
  tokenProvider: tokenProvider,
  logger: MyLogger(),
);
```

## まとめ

| 設定 | 説明 |
|---|---|
| `enableLog: true`（デフォルト） | `StdoutLogger` で標準出力にログ出力 |
| `enableLog: false` | ログ出力なし |
| `logger: FunctionLogger(...)` | コールバック関数へ転送 |
| `logger: MyLogger()` | カスタム実装 |
