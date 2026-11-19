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

自定义日志记录器会替换默认的 `StdoutLogger`，但不会绕过 `enableLog`：只有在 `enableLog` 为 `true` 时才会接收日志调用。

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
    // 处理错误及可选的堆栈跟踪
  }
}

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
  logger: MyLogger(),
);
```

## 默认行为

当设置了 `enableLog: true` 且未提供自定义 `logger` 时，使用 `StdoutLogger`。它在内部委托给 `logger` 包。

HTTP 请求、响应和重试日志仅在 `enableLog` 为 `true` 且不是发布构建时输出。默认的 `StdoutLogger` 使用 `logger` 包的 development filter，在断言被禁用时（如发布构建）会抑制所有输出。Streaming 日志调用仅取决于 `enableLog`，因此自定义日志记录器在发布构建中也能接收这些调用。

日志格式：

```
[misskey_client] [LEVEL] 2025-01-01 12:00:00.000000 message
```
