---
sidebar_position: 2
title: 인증
---

# 인증

Misskey는 토큰 기반 인증을 사용합니다. Misskey API에서 `i`라 불리는 비밀 토큰은 인증이 필요한 모든 POST 요청 본문에 삽입됩니다. OAuth 기반 API와 달리, Bearer 헤더를 사용하지 않고 토큰이 JSON 본문 안에 포함됩니다.

## TokenProvider 동작 방식

`TokenProvider`는 `FutureOr<String?>`을 반환하는 콜백에 대한 typedef입니다:

```dart
typedef TokenProvider = FutureOr<String?> Function();
```

콜백은 인증이 필요한 요청마다 호출됩니다. 이 설계 덕분에 클라이언트를 재생성하지 않고도 토큰을 갱신하거나 지연 로드할 수 있습니다.

### 동기 토큰

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_token_here',
);
```

### 비동기 토큰 (예: 보안 스토리지에서 로드)

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () async {
    return await secureStorage.read(key: 'misskey_token');
  },
);
```

### 토큰 갱신 패턴

토큰이 교체될 수 있는 경우, 프로바이더에서 최신 값을 반환합니다. 클라이언트는 요청을 보내기 직전에 항상 콜백을 호출하므로, 최신 값을 반환하는 것으로 충분합니다:

```dart
String? _cachedToken;

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => _cachedToken,
);

// 토큰이 변경될 때마다 캐시된 값을 업데이트합니다.
void onTokenRefreshed(String newToken) {
  _cachedToken = newToken;
}
```

## AuthMode 열거형

각 API 엔드포인트는 `AuthMode` 열거형을 사용하여 인증 요건을 선언합니다:

| 모드 | 동작 |
|------|----------|
| `AuthMode.required` | 토큰이 삽입됩니다. 제공되지 않으면 예외가 발생합니다 (기본값) |
| `AuthMode.optional` | 토큰이 있을 때만 삽입됩니다. 없어도 요청이 진행됩니다 |
| `AuthMode.none` | 프로바이더에 관계없이 토큰이 절대 삽입되지 않습니다 |

이는 라이브러리 내부적인 관심사입니다. 사용자는 `tokenProvider`만 제공하면 되며, 라이브러리가 자동으로 삽입을 처리합니다.

`AuthMode.optional`인 엔드포인트는 인증 시 더 풍부한 응답을 반환합니다. 예를 들어 `notes/show`는 토큰이 있을 때만 `myReaction`과 `isFavorited` 필드를 포함합니다.

## 토큰 획득: MiAuth 흐름

Misskey는 OAuth 2.0을 사용하지 않습니다. 서드파티 앱에 권장되는 흐름은 간소화된 브라우저 리다이렉트 방식인 **MiAuth**입니다.

```
1. 세션 UUID 생성
2. 브라우저에서 MiAuth URL 열기
3. 사용자가 Misskey 웹 UI에서 권한 승인
4. 콜백 URL로 리다이렉트 (또는 API 폴링)
5. 세션 UUID를 토큰으로 교환
```

### 1단계: 인증 URL 구성

```dart
import 'package:uuid/uuid.dart';

final session = const Uuid().v4();
final baseUrl = 'https://misskey.example.com';

final authUrl = Uri.parse('$baseUrl/miauth/$session').replace(
  queryParameters: {
    'name': 'My App',
    'callback': 'myapp://auth/callback',
    'permission': 'read:account,write:notes',
  },
);
// authUrl을 브라우저나 WebView에서 엽니다
```

### 2단계: 세션을 토큰으로 교환

사용자가 요청을 승인하면 확인 엔드포인트를 호출합니다. 이는 일반 HTTP GET 요청이며 라이브러리의 인증 경로를 거치지 않습니다:

```dart
final response = await http.get(
  Uri.parse('$baseUrl/api/miauth/$session/check'),
);
final json = jsonDecode(response.body) as Map<String, dynamic>;
final token = json['token'] as String?;
```

토큰을 안전하게 저장하고 `tokenProvider`에 전달합니다.

## 인증 없이 사용하기

공개 엔드포인트에 접근할 때는 `tokenProvider`를 생략합니다:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
);

// 토큰 없이도 동작합니다
final info = await client.meta.fetch();
final notes = await client.notes.timelineLocal(limit: 10);
```

프로바이더 없이 `AuthMode.required` 엔드포인트를 호출하면 `MisskeyUnauthorizedException`이 발생합니다.
