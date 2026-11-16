---
sidebar_position: 1
title: Logging
---

# Logging

misskey_client can log HTTP requests and responses. Logging is disabled by default.

## Enabling logs

Set `enableLog: true` in `MisskeyClientConfig`:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

When enabled, the default `StdoutLogger` writes to stdout via the `logger` package.

## Disabling logs

Omit `enableLog` or set it to `false` (the default):

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: false, // default
  ),
);
```

## Custom logger with FunctionLogger

`FunctionLogger` adapts a simple callback to the `Logger` interface:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level is one of: 'debug', 'info', 'warn', 'error'
    myLogger.log(level, message);
  }),
);
```

A custom logger replaces the default `StdoutLogger`, but it does not bypass `enableLog`: it receives log calls only while `enableLog` is `true`.

## Implementing a custom Logger

For full control, implement the `Logger` interface:

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

## Default behavior

When `enableLog: true` is set and no custom `logger` is supplied, the `StdoutLogger` is used. It delegates to the `logger` package internally.

HTTP request, response, and retry logs are emitted only when `enableLog` is `true` and the app is not a release build. In release builds the `StdoutLogger` itself outputs only warnings and errors.

Log format:

```
[misskey_client] [LEVEL] 2025-01-01 12:00:00.000000 message
```
