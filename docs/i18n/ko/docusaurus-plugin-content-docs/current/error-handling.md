---
sidebar_position: 3
title: 오류 처리
---

# 오류 처리

이 라이브러리는 Misskey API 오류를 `MisskeyClientException`을 루트로 하는 sealed class 계층으로 매핑합니다.

## 예외 계층 구조

```
MisskeyClientException (sealed)
├── MisskeyApiException              // 일반적인 HTTP 응답 오류
│   ├── MisskeyUnauthorizedException // 401 - 잘못되거나 누락된 토큰
│   ├── MisskeyForbiddenException    // 403 - 작업 권한 없음
│   ├── MisskeyNotFoundException     // 404 - 리소스를 찾을 수 없음
│   ├── MisskeyRateLimitException    // 429 - 요청 한도 초과
│   │   └── retryAfter               //   서버 제안 대기 시간
│   ├── MisskeyValidationException   // 422 - 잘못된 요청 본문
│   └── MisskeyServerException       // 5xx - 서버 측 오류
└── MisskeyNetworkException          // 타임아웃, 연결 거부 등
```

`MisskeyApiException`은 Misskey 고유 필드도 포함합니다:

- `code` — Misskey 오류 코드 문자열 (예: `AUTHENTICATION_FAILED`, `NO_SUCH_NOTE`)
- `errorId` — Misskey 오류 유형을 식별하는 UUID
- `endpoint` — 오류가 발생한 API 경로

## 기본 catch 패턴

### 모든 오류 잡기

```dart
try {
  final note = await client.notes.show(noteId: '9xyz');
} on MisskeyClientException catch (e) {
  print('Error: $e');
}
```

### HTTP 상태별 처리

```dart
try {
  final note = await client.notes.show(noteId: noteId);
} on MisskeyNotFoundException {
  print('노트를 찾을 수 없습니다');
} on MisskeyUnauthorizedException {
  print('토큰이 유효하지 않습니다. 다시 인증해 주세요');
} on MisskeyForbiddenException {
  print('이 노트를 볼 권한이 없습니다');
} on MisskeyRateLimitException catch (e) {
  final wait = e.retryAfter ?? const Duration(seconds: 60);
  print('요청 한도 초과. $wait 후 재시도하세요');
} on MisskeyApiException catch (e) {
  print('API 오류 (${e.statusCode}): ${e.message} [${e.code}]');
} on MisskeyNetworkException {
  print('네트워크 연결을 확인하세요');
}
```

### Misskey 오류 코드 확인

```dart
try {
  await client.following.create(userId: userId);
} on MisskeyApiException catch (e) {
  switch (e.code) {
    case 'ALREADY_FOLLOWING':
      print('이미 팔로우 중인 사용자입니다');
    case 'BLOCKING':
      print('차단한 사용자는 팔로우할 수 없습니다');
    default:
      rethrow;
  }
}
```

## 요청 한도 처리

```dart
Future<T> withRetry<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on MisskeyRateLimitException catch (e) {
    final wait = e.retryAfter ?? const Duration(seconds: 60);
    await Future<void>.delayed(wait);
    return action();
  }
}

// 사용 예시
final timeline = await withRetry(
  () => client.notes.timelineHome(limit: 20),
);
```

## 네트워크 오류 처리

`MisskeyNetworkException`은 타임아웃, DNS 오류 등 연결 수준의 장애를 감쌉니다. `cause` 필드에 원인이 되는 예외가 담겨 있습니다:

```dart
try {
  final notes = await client.notes.timelineLocal();
} on MisskeyNetworkException catch (e) {
  print('Network error at ${e.endpoint}: ${e.cause}');
}
```

클라이언트는 예외를 던지기 전에 멱등적 요청에 대해 `MisskeyClientConfig.maxRetries` 횟수 (기본값: 3)만큼 자동으로 재시도합니다.
