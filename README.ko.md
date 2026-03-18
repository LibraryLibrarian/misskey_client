[English](README.md) | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | 한국어

# misskey_client

[Misskey](https://misskey-hub.net/) API를 위한 순수 Dart 클라이언트 라이브러리입니다. 25개의 API 도메인에 대한 타입 안전 접근을 제공하며, 인증, 재시도 로직, 구조화된 오류 처리를 내장하고 있습니다.

## 기능

- 25개의 Misskey API 도메인 지원 (노트, 드라이브, 사용자, 채널, 채팅 등)
- 교체 가능한 `TokenProvider` 콜백을 통한 토큰 기반 인증
- 최대 재시도 횟수를 설정할 수 있는 자동 재시도
- 망라적 오류 처리를 위한 sealed 예외 클래스 계층 구조
- `json_serializable`로 생성된 강타입 요청 및 응답 모델
- 교체 가능한 `Logger` 인터페이스를 통한 유연한 로깅
- 순수 Dart — Flutter 의존성 불필요

## 설치

`pubspec.yaml`에 패키지를 추가하세요:

```yaml
dependencies:
  misskey_client: ^0.0.1
```

그런 다음 실행합니다:

```
dart pub get
```

## 빠른 시작

```dart
import 'package:misskey_client/misskey_client.dart';

void main() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
      timeout: Duration(seconds: 10),
      maxRetries: 3,
    ),
    // 액세스 토큰을 제공합니다. 콜백은 비동기로도 사용할 수 있습니다.
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
  );

  // 인증된 사용자의 노트 타임라인 가져오기
  final notes = await client.notes.getTimeline();
  for (final note in notes) {
    print(note.text);
  }
}
```

## API 개요

`MisskeyClient`는 다음 속성들을 노출하며, 각각 Misskey API의 서로 다른 영역을 담당합니다:

| 속성 | 설명 |
|---|---|
| `account` | 계정 및 프로필 관리, 레지스트리, 2단계 인증, 웹훅 |
| `announcements` | 서버 공지사항 |
| `antennas` | 안테나(키워드 기반 피드) 관리 |
| `ap` | ActivityPub 유틸리티 |
| `blocking` | 사용자 차단 |
| `channels` | 채널 및 채널 뮤트 |
| `charts` | 통계 차트 |
| `chat` | 채팅룸과 메시지 |
| `clips` | 클립 컬렉션 |
| `drive` | 드라이브(파일 저장소), 파일, 폴더, 통계 |
| `federation` | 연합 인스턴스 정보 |
| `flash` | Flash(Play) 스크립트 |
| `following` | 팔로우 및 팔로우 요청 |
| `gallery` | 갤러리 게시물 |
| `hashtags` | 해시태그 검색 및 트렌드 |
| `invite` | 초대 코드 |
| `meta` | 서버 메타데이터 |
| `mute` | 사용자 뮤트 |
| `notes` | 노트, 리액션, 투표, 검색, 타임라인 |
| `notifications` | 알림 |
| `pages` | 페이지 |
| `renoteMute` | 리노트 뮤트 |
| `roles` | 역할 할당 |
| `sw` | 푸시 알림(Service Worker) |
| `users` | 사용자 검색, 리스트, 관계, 업적 |

## 인증

클라이언트를 생성할 때 `TokenProvider` 콜백을 전달합니다. 콜백은 `FutureOr<String?>`을 반환하므로 동기 및 비동기 토큰 소스 모두 지원됩니다:

```dart
// 동기 토큰
final client = MisskeyClient(
  config: config,
  tokenProvider: () => secureStorage.readSync('token'),
);

// 비동기 토큰
final client = MisskeyClient(
  config: config,
  tokenProvider: () async => await secureStorage.read('token'),
);
```

인증이 필요한 엔드포인트는 토큰을 자동으로 주입합니다. 선택적 인증 엔드포인트는 토큰이 있을 때 첨부합니다.

## 오류 처리

모든 예외는 sealed 클래스 `MisskeyClientException`을 상속하므로 망라적 패턴 매칭이 가능합니다:

```dart
try {
  final user = await client.users.show(userId: 'abc123');
} on MisskeyUnauthorizedException {
  // 401 — 토큰이 유효하지 않거나 없음
} on MisskeyForbiddenException {
  // 403 — 작업이 허용되지 않음
} on MisskeyNotFoundException {
  // 404 — 리소스를 찾을 수 없음
} on MisskeyRateLimitException catch (e) {
  // 429 — 요청 속도 제한; e.retryAfter 확인
} on MisskeyValidationException {
  // 422 — 요청 본문이 유효하지 않음
} on MisskeyServerException {
  // 5xx — 서버 측 오류
} on MisskeyNetworkException {
  // 타임아웃, 연결 거부 등
}
```

## 로깅

`MisskeyClientConfig.enableLog`를 통해 내장 stdout 로거를 활성화하거나, 커스텀 `Logger` 구현을 제공할 수 있습니다:

```dart
class MyLogger implements Logger {
  @override void debug(String message) { /* ... */ }
  @override void info(String message)  { /* ... */ }
  @override void warn(String message)  { /* ... */ }
  @override void error(String message, [Object? error, StackTrace? stackTrace]) { /* ... */ }
}

final client = MisskeyClient(
  config: MisskeyClientConfig(baseUrl: Uri.parse('https://misskey.example.com')),
  logger: MyLogger(),
);
```

## 문서

- API 레퍼런스: https://librarylibrarian.github.io/misskey_client/
- pub.dev 페이지: https://pub.dev/packages/misskey_client
- GitHub: https://github.com/LibraryLibrarian/misskey_client

## 라이선스

[LICENSE](LICENSE)를 참조하세요.
