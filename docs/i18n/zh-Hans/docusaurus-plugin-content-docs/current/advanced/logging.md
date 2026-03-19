---
sidebar_position: 1
title: 日志
---

# 日志

misskey_client 可以记录 HTTP 请求和响应。日志功能默认禁用。

## 启用日志

在 `MisskeyClientConfig` 中设置 `enableLog: true`：

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

启用后，默认的 `StdoutLogger` 会通过 `logger` 包将日志写入标准输出。

## 禁用日志

省略 `enableLog` 或将其设置为 `false`（默认值）：

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: false, // default
  ),
);
```

## 使用 FunctionLogger 自定义日志

`FunctionLogger` 将简单的回调适配到 `Logger` 接口：

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level 为以下之一：'debug', 'info', 'warn', 'error'
    myLogger.log(level, message);
  }),
);
```

`FunctionLogger` 优先级高于 `enableLog` 标志。如果你提供了自定义日志记录器，它将接收所有日志调用，与 `enableLog` 的值无关。

## 实现自定义 Logger

如需完全控制，可实现 `Logger` 接口：

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
    // Handle error with optional stack trace
  }
}

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'token',
  logger: MyLogger(),
);
```

## 默认行为

当设置了 `enableLog: true` 且未提供自定义 `logger` 时，使用 `StdoutLogger`。它在内部委托给 `logger` 包。

在调试构建中，所有日志级别（debug 及以上）均会输出。在发布构建中，只输出警告和错误。

日志格式：

```
[misskey_client] [LEVEL] 2025-01-01 12:00:00.000000 message
```
