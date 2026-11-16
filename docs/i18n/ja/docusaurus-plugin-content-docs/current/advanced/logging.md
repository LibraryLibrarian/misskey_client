---
sidebar_position: 1
---

# ロギング

## デフォルトの動作

`MisskeyClientConfig.enableLog` のデフォルトは `false` で、ログは無効です。`enableLog: true` を設定し、カスタム `logger` を指定しない場合は、`StdoutLogger` が `logger` パッケージを通じて標準出力にログを出力します。

HTTP リクエスト・レスポンス・リトライのログは、`enableLog` が `true` で、リリースビルドではない場合にのみ出力されます。デフォルトの `StdoutLogger` は `logger` パッケージの development filter を使用するため、リリースビルドのように assert が無効な場合はすべての出力が抑制されます。Streaming のログ呼び出しは `enableLog` のみに依存するため、カスタム logger はリリースビルドでも受け取れます。

## ログの無効化

ログ出力が不要な場合は `enableLog` を省略するか、`false` を設定します。

```dart
final config = MisskeyClientConfig(
  baseUrl: Uri.parse('https://misskey.example.com'),
  enableLog: false,
);
```

## FunctionLogger

ログを独自のシステム（ファイル、外部サービスなど）に転送したい場合は `FunctionLogger` を使います。

カスタム `logger` はデフォルトの `StdoutLogger` を置き換えますが、`enableLog` が `true` の間だけ呼び出されます。

```dart
final config = MisskeyClientConfig(
  baseUrl: Uri.parse('https://misskey.example.com'),
  enableLog: true,
);

final logger = FunctionLogger((level, message) {
  myLogService.log(level, message);
});

final client = MisskeyClient(
  config: config,
  tokenProvider: () => 'token',
  logger: logger,
);
```

## カスタムLoggerの実装

`Logger` インターフェースを実装することで、完全にカスタマイズされたロガーを作成できます。

```dart
class MyLogger implements Logger {
  @override
  void debug(String message) { /* ... */ }

  @override
  void info(String message) { /* ... */ }

  @override
  void warn(String message) { /* ... */ }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    // 省略可能な例外とスタックトレースを伴うエラーログを処理する
  }
}

final client = MisskeyClient(
  config: config,
  tokenProvider: () => 'token',
  logger: MyLogger(),
);
```

## まとめ

| 設定 | 説明 |
|---|---|
| `enableLog: true`（カスタム `logger` なし） | `StdoutLogger` で標準出力にログ出力 |
| `enableLog: false`（デフォルト） | カスタム `logger` の有無にかかわらずログ出力なし |
| `enableLog: true` と `logger: FunctionLogger(...)` | コールバック関数へ転送 |
| `enableLog: true` と `logger: MyLogger()` | カスタム実装へ転送 |

HTTP のリクエスト・レスポンス・リトライのログはリリースビルドでは出力されません。デフォルトの `StdoutLogger` は logger パッケージの development filter を使うため、アサーションが無効なリリースビルドでは何も出力しません。Streaming のログは `enableLog` だけで判定されるため、カスタム logger にはリリースビルドでも届きます。
