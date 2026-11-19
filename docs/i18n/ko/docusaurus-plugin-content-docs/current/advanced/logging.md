---
sidebar_position: 1
title: 로깅
---

# 로깅

misskey_client는 HTTP 요청과 응답을 로깅할 수 있습니다. 로깅은 기본적으로 비활성화되어 있습니다.

## 로그 활성화

`MisskeyClientConfig`에서 `enableLog: true`를 설정합니다:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

활성화하면 기본 `StdoutLogger`가 `logger` 패키지를 통해 stdout에 출력합니다.

## 로그 비활성화

`enableLog`를 생략하거나 `false`로 설정합니다 (기본값):

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: false, // 기본값
  ),
);
```

## FunctionLogger를 사용한 커스텀 로거

`FunctionLogger`는 간단한 콜백을 `Logger` 인터페이스에 맞게 조정합니다:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level은 'debug', 'info', 'warn', 'error' 중 하나입니다
    myLogger.log(level, message);
  }),
);
```

커스텀 로거는 기본 `StdoutLogger`를 대체하지만 `enableLog` 설정을 우회하지는 않습니다. `enableLog`가 `true`인 동안에만 로그 호출을 받습니다.

## 커스텀 Logger 구현

완전한 제어를 위해 `Logger` 인터페이스를 직접 구현할 수 있습니다:

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
    // 선택적 스택 트레이스와 함께 오류 처리
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

## 기본 동작

`enableLog: true`로 설정하고 커스텀 `logger`를 제공하지 않으면 `StdoutLogger`가 사용됩니다. 내부적으로 `logger` 패키지에 위임합니다.

HTTP 요청, 응답 및 재시도 로그는 `enableLog`가 `true`이고 릴리스 빌드가 아닐 때만 출력됩니다. 기본 `StdoutLogger`는 `logger` 패키지의 development filter를 사용하므로 릴리스 빌드처럼 assert가 비활성화된 경우 모든 출력이 억제됩니다. Streaming 로그 호출은 `enableLog`에만 의존하므로 커스텀 로거는 릴리스 빌드에서도 이를 받을 수 있습니다.

로그 형식:

```
[misskey_client] [LEVEL] 2025-01-01 12:00:00.000000 message
```
